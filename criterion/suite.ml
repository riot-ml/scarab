type t = { name : string; benches : Bench.t list }

let run t ~reporter = List.iter (Bench.run ~reporter) t.benches
