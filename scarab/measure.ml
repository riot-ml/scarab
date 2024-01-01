type err = User of string | Exn of exn | Empty_measure

type t = {
  start_time : Int64.t;
  end_time : Int64.t;
  elapsed_time : Int64.t;
  result : (unit, err) result;
}

let make fn =
  let ( - ) = Int64.sub in
  let start_time = Time.now () in
  let result = match fn () with exception e -> Error (Exn e) | r -> r in
  let end_time = Time.now () in
  let elapsed_time = end_time - start_time in
  { start_time; end_time; elapsed_time; result }

let empty =
  {
    start_time = 0L;
    end_time = 0L;
    elapsed_time = 0L;
    result = Error Empty_measure;
  }

let max =
  {
    start_time = Int64.max_int;
    end_time = Int64.max_int;
    elapsed_time = Int64.max_int;
    result = Error Empty_measure;
  }

let fastest ts =
  List.fold_left
    (fun a b -> if a.elapsed_time < b.elapsed_time then a else b)
    max ts

let slowest ts =
  List.fold_left
    (fun a b -> if a.elapsed_time > b.elapsed_time then a else b)
    empty ts

let median ts =
  let times =
    ts |> List.map (fun t -> t.elapsed_time) |> List.sort_uniq Int64.compare
  in

  match List.nth_opt times (List.length times / 2) with
  | Some m -> m
  | _ -> Int64.min_int
