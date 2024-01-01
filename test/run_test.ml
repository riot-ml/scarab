open Riot

let sum n =
  let arr = Array.init n (fun k -> k + 1) in
  let _sum = Array.fold_left ( + ) 0 arr in
  Ok ()
;;

Logger.set_log_level None;;

(* $MDX part-begin=run *)
Scarab.run ~name:"sums"
  [
    ("sum 1", fun () -> sum 1);
    ("sum 100", fun () -> sum 100);
    ("sum 1_000", fun () -> sum 1_000);
    ("sum 2_000", fun () -> sum 2_000);
    ("sum 5_000", fun () -> sum 5_000);
    ("sum 10_000", fun () -> sum 10_000);
    ("sum 100_000", fun () -> sum 100_000);
  ]
(* $MDX part-end *)
