open Criterion

let%bench benchmark1 () =
  let arr = Array.init 1_000_000 (fun k -> k + 1) in
  let _ = Array.fold_left ( + ) 0 arr in
  Ok ()

let%bench benchmark2 () =
  let arr = Array.init 1_000_000 (fun k -> k + 1) in
  let _ = Array.fold_left ( + ) 0 arr in
  Ok ()

let%bench benchmark3 () =
  let arr = Array.init 1_000_000 (fun k -> k + 1) in
  let _ = Array.fold_left ( + ) 0 arr in
  Ok ()
