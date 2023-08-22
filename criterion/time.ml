type t = Millis of int | Micros of int | Nanos of int

let of_nanos n =
  match n with
  (* nano to ms *)
  | n when n > 10_000 -> Millis (n / 10_000)
  (* nano no micro *)
  | n when n > 1_000 -> Micros (n / 1_000)
  | n -> Nanos n

let to_human_friendly t =
  match t with
  | Millis millis -> Printf.sprintf "%5dms" millis
  | Micros micros -> Printf.sprintf "%5dμs" micros
  | Nanos nanos -> Printf.sprintf "%5dns" nanos
