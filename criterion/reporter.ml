type t = {
  begin_bench : name:string -> start_time:Int64.t -> unit;
  end_bench : name:string -> end_time:Int64.t -> iter:Int64.t -> unit;
}

let cli : t =
  let start_times : (string, Int64.t) Hashtbl.t = Hashtbl.create 256 in
  {
    begin_bench =
      (fun ~name ~start_time -> Hashtbl.add start_times name start_time);
    end_bench =
      (fun ~name ~end_time ~iter ->
        let start_time = Hashtbl.find start_times name in
        let ( - ) = Int64.sub in
        let elapsed_time =
          end_time - start_time |> Int64.to_int |> Time.of_nanos
          |> Time.to_human_friendly
        in
        let rate =
          let t0 = Int64.to_float start_time in
          let t1 = Int64.to_float end_time in
          let mx = Int64.to_float iter in
          mx /. (t1 -. t0)
        in

        Printf.printf "%-20s[elapsed_time: %s; rate: %6.2f ops/ns]\n%!" name
          elapsed_time rate);
  }
