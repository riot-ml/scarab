type t = {
  name : string;
  max_runs : int;
  fn : unit -> (unit, Measure.err) result;
  mutable iter : Int64.t;
  mutable measures : Measure.t list;
}

let make ~name ?(max_runs = 1_000) fn =
  { name; max_runs; iter = 0L; fn; measures = [] }

let run_measures t =
  List.init t.max_runs (fun _iter ->
      let measure = Measure.make t.fn in
      t.iter <- Int64.add t.iter 1L;
      measure)

let run t ~(reporter : Reporter.t) =
  reporter.begin_bench ~name:t.name;
  t.measures <- run_measures t;
  reporter.end_bench ~name:t.name ~measures:t.measures;
  ()
