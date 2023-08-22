type bench_err = User of string | Exn of exn
type bench_result = (unit, bench_err) result

type t = {
  name : string;
  max_runs : int;
  fn : unit -> bench_result;
  mutable start_time : Int64.t;
  mutable end_time : Int64.t;
  mutable iter : Int64.t;
  mutable results : bench_result list;
}

let make ~name ?(max_runs = 1_000) fn =
  {
    name;
    max_runs;
    iter = 0L;
    start_time = 0L;
    end_time = 0L;
    fn;
    results = [];
  }

let now () = Int64.of_float (Unix.gettimeofday () *. 1_000_000.0)

let run_safely t =
  List.init t.max_runs (fun _iter ->
      let result = match t.fn () with exception e -> Error (Exn e) | r -> r in
      t.iter <- Int64.add t.iter 1L;
      result)

let run t ~(reporter : Reporter.t) =
  t.start_time <- now ();
  reporter.begin_bench ~name:t.name ~start_time:t.start_time;
  t.results <- run_safely t;
  t.end_time <- now ();
  reporter.end_bench ~name:t.name ~iter:t.iter ~end_time:t.end_time;
  ()
