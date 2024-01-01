open Riot

type t = {
  id : int;
  name : string;
  max_runs : int;
  fn : unit -> (unit, Measure.err) result;
  mutable iter : Int64.t;
  mutable measures : Measure.t list;
}

let make ~id ~name ?(max_runs = 1_000) fn =
  { id; name; max_runs; iter = 0L; fn; measures = [] }

let run_measures t =
  List.init t.max_runs (fun iter ->
      yield ();
      let measure = Measure.make t.fn in
      Reporter.iteration ~id:t.id ~iter;
      t.iter <- Int64.add t.iter 1L;
      measure)

let run t =
  Reporter.begin_bench ~id:t.id ~name:t.name ~max_runs:t.max_runs;
  t.measures <- run_measures t;
  Reporter.end_bench ~id:t.id ~name:t.name ~measures:t.measures;
  ()
