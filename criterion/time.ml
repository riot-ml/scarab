type t = Millis of float | Micros of float | Nanos of float

let now () = Int64.of_float (Unix.gettimeofday () *. 1_000_000.0)

let of_nanos n =
  let n = Int64.to_float n in
  match n with
  (* nano to ms *)
  | n when n > 10_000.0 -> Millis (n /. 10_000.0)
  (* nano no micro *)
  | n when n > 1_000.0 -> Micros (n /. 1_000.0)
  | n -> Nanos n

let to_human_friendly t =
  match t with
  | Millis millis -> Printf.sprintf "%4.3gms" millis
  | Micros micros -> Printf.sprintf "%4.3gμs" micros
  | Nanos nanos -> Printf.sprintf "%4.3gns" nanos
