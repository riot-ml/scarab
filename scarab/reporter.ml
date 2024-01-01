open Riot

type Message.t +=
  | Bench_started of { id : int; name : string; max_runs : int }
  | Bench_ended of { id : int; name : string; measures : Measure.t list }
  | Iteration of { id : int; iter : int }
  | Register_handler of Pid.t
  | Shutdown

module type Intf = sig
  type state

  val name : string
  val handle_shutdown : state -> unit
  val handle_bench_start : state -> id:int -> name:string -> state

  val handle_bench_end :
    state -> id:int -> name:string -> measures:Measure.t list -> state
end

type t = R : (module Intf with type state = 'state) * 'state -> t

let make (R ((module B), state)) =
  let module R = struct
    let name = B.name

    type 'a state = { inner : 'a; handlers : Pid.t list }

    let rec loop state =
      match receive () with
      | Register_handler pid ->
          Logger.error (fun f -> f "registering handler for %a" Pid.pp pid);
          loop { state with handlers = pid :: state.handlers }
      | Bench_started { id; name; _ } as msg ->
          let inner = B.handle_bench_start state.inner ~id ~name in
          List.iter (fun pid -> send pid msg) state.handlers;
          loop { state with inner }
      | Bench_ended { id; name; measures } as msg ->
          let inner = B.handle_bench_end state.inner ~id ~name ~measures in
          List.iter (fun pid -> send pid msg) state.handlers;
          loop { state with inner }
      | Iteration _ as msg ->
          List.iter (fun pid -> send pid msg) state.handlers;
          loop state
      | Shutdown ->
          List.iter (fun pid -> send pid Shutdown) state.handlers;
          B.handle_shutdown state.inner
      | msg ->
          Logger.error (fun f ->
              f "unexpected message: %S" (Marshal.to_string msg []));
          loop state

    let init () =
      Logger.info (fun f -> f "Starting %s reporter" B.name);
      loop { inner = state; handlers = [] }

    let start () =
      let pid = spawn (fun () -> init ()) in
      register name pid;
      Ok pid
  end in
  (module R : Riot.Application.Intf)

module Cli = struct
  let name = "scarab.reporter.cli"

  type state = unit

  let handle_shutdown _state = ()

  let handle_bench_start state ~id:_ ~name =
    Logger.debug (fun f -> f "Bench started: %s" name);
    state

  let handle_bench_end state ~id:_ ~name:_ ~measures:_ = state
end

let cli = R ((module Cli), ())
let current_reporter : t ref = ref cli

let begin_bench ~id ~name ~max_runs =
  let (R ((module R), _)) = !current_reporter in
  send_by_name ~name:R.name (Bench_started { id; name; max_runs })

let end_bench ~id ~name ~measures =
  let (R ((module R), _)) = !current_reporter in
  send_by_name ~name:R.name (Bench_ended { id; name; measures })

let iteration ~id ~iter =
  let (R ((module R), _)) = !current_reporter in
  send_by_name ~name:R.name (Iteration { id; iter })

let shutdown () =
  let (R ((module R), _)) = !current_reporter in
  send_by_name ~name:R.name Shutdown

let register_handler pid =
  let (R ((module R), _)) = !current_reporter in
  send_by_name ~name:R.name (Register_handler pid)

module Minttea_reporter = struct
  open Minttea
  open Leaves

  let name = "scarab.tui"

  type measure = { slowest : int64; median : int64; fastest : int64 }

  type bench_progress = {
    id : int;
    name : string;
    max_runs : int;
    current_run : int;
    bar : Progress.t;
    measures : measure option;
  }

  type model = {
    last_message : string;
    benches : bench_progress list;
    finished : bool;
    spinner : Sprite.t;
  }

  let init _ =
    register_handler (self ());
    Command.Seq [ Hide_cursor; Enter_alt_screen ]

  let update (event : Event.t) model =
    match event with
    | Event.Frame now ->
        ({ model with spinner = Sprite.update ~now model.spinner }, Command.Noop)
    | Event.KeyDown (Key "q") ->
        ( { model with finished = true },
          Command.Seq [ Show_cursor; Exit_alt_screen; Quit ] )
    | Event.Custom Shutdown ->
        ( { model with last_message = "finished"; finished = true },
          Command.Seq [ Show_cursor; Exit_alt_screen; Quit ] )
    | Event.Custom (Iteration { id; iter }) ->
        let last_message = Format.sprintf "running bench=%d iter=%d" id iter in
        let benches =
          List.map
            (fun bp ->
              if bp.id = id then
                let inc =
                  Int.to_float iter *. 100. /. Int.to_float bp.max_runs /. 100.
                in
                let bar = Progress.set_progress bp.bar inc in
                { bp with current_run = iter; bar }
              else bp)
            model.benches
        in
        ({ model with last_message; benches }, Command.Noop)
    | Event.Custom (Bench_started { id; name; max_runs }) ->
        let last_message = Format.sprintf "bench started %s" name in
        let bench =
          {
            id;
            name;
            max_runs;
            current_run = 0;
            bar =
              Progress.make ~width:50
                ~color:
                  (`Gradient (Spices.color "#b14fff", Spices.color "#00ffa3"))
                ();
            measures = None;
          }
        in
        let benches = bench :: model.benches in
        ({ model with last_message; benches }, Command.Noop)
    | Event.Custom (Bench_ended { id; measures; _ }) ->
        let slowest = (Measure.slowest measures).elapsed_time in
        let fastest = (Measure.fastest measures).elapsed_time in
        let median = Measure.median measures in
        let benches =
          List.map
            (fun b ->
              if b.id = id then
                { b with measures = Some { slowest; fastest; median } }
              else b)
            model.benches
        in
        ({ model with benches }, Command.Noop)
    | _ -> (model, Command.Noop)

  let dot = Spices.(default |> fg (color "236") |> build) " • "
  let subtle fmt = Spices.(default |> fg (color "241") |> build) fmt
  let keyword fmt = Spices.(default |> fg (color "211") |> build) fmt
  let highlight fmt = Spices.(default |> fg (color "#FF06B7") |> build) fmt

  let view model =
    let header =
      if model.finished then highlight "%s\n" "Scarab 🪲 is finished."
      else
        highlight "%s %s\n"
          (Sprite.view model.spinner)
          "Running Scarab 🪲 benchmark..."
    in
    let status =
      if model.finished then ""
      else subtle "\n> status: %s\r\n" model.last_message
    in
    header
    ^ (model.benches
      |> List.sort (fun b1 b2 -> Int.compare b1.id b2.id)
      |> List.map (fun b ->
             match b.measures with
             | Some m ->
                 Format.sprintf "%-30s[%s: %5d; %s: %s; %s: %s; %s: %s]%!"
                   b.name (subtle "%s" "iter") b.max_runs (subtle "%s" "slow")
                   (Time.to_human_friendly (Time.of_nanos m.slowest))
                   (subtle "%s" "med")
                   (Time.to_human_friendly (Time.of_nanos m.median))
                   (subtle "%s" "fast")
                   (Time.to_human_friendly (Time.of_nanos m.fastest))
             | None ->
                 let name =
                   Format.sprintf "%s(%d/%d)" b.name b.current_run b.max_runs
                 in
                 Format.sprintf "%-30s%s" name (Progress.view b.bar))
      |> String.concat "\n")
    ^ status

  let start () =
    Logger.set_log_level None;
    let pid =
      spawn (fun () ->
          let initial_model =
            {
              last_message = "initializing...";
              benches = [];
              finished = false;
              spinner = Spinner.mini_dot;
            }
          in
          let app = Minttea.app ~init ~update ~view () in
          Minttea.run ~initial_model app)
    in
    Ok pid
end
