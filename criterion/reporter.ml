type t = {
  begin_bench : name:string -> unit;
  end_bench : name:string -> measures:Measure.t list -> unit;
}

let cli : t =
  {
    begin_bench = (fun ~name:_ -> ());
    end_bench =
      (fun ~name ~measures ->
        let slowest_run = Measure.slowest measures in
        let fastest_run = Measure.fastest measures in
        let median = Measure.median measures in

        Printf.printf "%-20s[iter: %5d; slow: %s; med: %s; fast: %s]\n%!" name
          (List.length measures)
          (Time.to_human_friendly (Time.of_nanos slowest_run.elapsed_time))
          (Time.to_human_friendly (Time.of_nanos median))
          (Time.to_human_friendly (Time.of_nanos fastest_run.elapsed_time)));
  }
