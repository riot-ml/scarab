open Riot
module Reporter = Reporter

let run reporter ~name:_ benches () =
  let Reporter.(R ((module R), _)) = reporter in
  let reporter = Process.await_name R.name in
  let tui = Process.await_name "Minttea.runner" in
  Logger.trace (fun f -> f "Scarab.run");
  let benches =
    List.mapi (fun id (name, fn) -> Bench.make ~id ~name fn) benches
  in
  let tasks =
    List.map (fun bench -> spawn (fun () -> Bench.run bench)) benches
  in
  wait_pids tasks;
  Reporter.shutdown ();
  wait_pids [ reporter; tui ];
  sleep 1.;
  shutdown ()

let run ?(reporter = Reporter.cli) ~name benches =
  Riot.start
    ~apps:
      [
        (module Riot.Logger);
        Reporter.make reporter;
        (module Reporter.Minttea_reporter);
        (module struct
          let name = "scarab:" ^ name

          let start () =
            let pid = spawn_link (run reporter ~name benches) in
            Ok pid
        end);
      ]
    ()
