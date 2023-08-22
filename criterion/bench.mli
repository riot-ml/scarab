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

val make : name:string -> ?max_runs:int -> (unit -> bench_result) -> t
(** create a new benchmark *)

val run : t -> reporter:Reporter.t -> unit
(** execute a benchmark, calling the reporter accordingly *)
