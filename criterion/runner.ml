type t = { suites : Suite.t list }

let make ~suites = { suites }
let run t ~reporter = List.iter (Suite.run ~reporter) t.suites
