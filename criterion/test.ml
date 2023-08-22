open Criterion

let () =
  let suite1 =
    Suite.
      {
        name = "suite-1";
        benches =
          [
            Bench.make ~name:"test 1" (fun () ->
                let arr = Array.init 1 (fun k -> k + 1) in
                let _sum = Array.fold_left ( + ) 0 arr in
                Ok ());
            Bench.make ~name:"test 100" (fun () ->
                let arr = Array.init 100 (fun k -> k + 1) in
                let _sum = Array.fold_left ( + ) 0 arr in
                Ok ());
            Bench.make ~name:"test 1_000" (fun () ->
                let arr = Array.init 1_000 (fun k -> k + 1) in
                let _sum = Array.fold_left ( + ) 0 arr in
                Ok ());
            Bench.make ~name:"test 2_000" (fun () ->
                let arr = Array.init 2_000 (fun k -> k + 1) in
                let _sum = Array.fold_left ( + ) 0 arr in
                Ok ());
            Bench.make ~name:"test 5_000" (fun () ->
                let arr = Array.init 5_000 (fun k -> k + 1) in
                let _sum = Array.fold_left ( + ) 0 arr in
                Ok ());
            Bench.make ~name:"test 10_000" (fun () ->
                let arr = Array.init 10_000 (fun k -> k + 1) in
                let _sum = Array.fold_left ( + ) 0 arr in
                Ok ());
            Bench.make ~name:"test 1_000_000" (fun () ->
                let arr = Array.init 1_000_000 (fun k -> k + 1) in
                let _sum = Array.fold_left ( + ) 0 arr in
                Ok ());
          ];
      }
  in
  let runner = Runner.make ~suites:[ suite1 ] in
  Runner.run runner ~reporter:Reporter.cli
