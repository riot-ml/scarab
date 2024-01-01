open Riot

let sum n () =
  let arr = Array.init n (fun k -> k + 1) in
  let _sum = Array.fold_left ( + ) 0 arr in
  Ok ()
;;

Logger.set_log_level None;;

Scarab.run ~name:"sums"
  [
    ("sum 1", sum 1);
    ("sum 100", sum 100);
    ("sum 1_000", sum 1_000);
    ("sum 2_000", sum 2_000);
    ("sum 5_000", sum 5_000);
    ("sum 10_000", sum 10_000);
    ("sum 100_000", sum 100_000);
  ]
