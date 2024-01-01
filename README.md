# scarab

A microbenchmarking framework for Riot inspired by Elixir's [benchee][benchee]
and Rust's [criterion-rs][criterion].

[benchee]: https://github.com/bencheeorg/benchee
[criterion]: https://github.com/bheisler/criterion.rs

<!-- $MDX file=./test/run_test.ml,part=run -->
```ocaml
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
```
