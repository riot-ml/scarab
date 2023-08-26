# criterion.ml

A microbenchmarking framework for OCaml heavily inspired by [criterion-rs](https://github.com/bheisler/criterion.rs).

The main goals for `criterion.ml` are:

* **Ease-of-use** - setting up and running new benchmarks should be as easy as tagging a function with `let%bench` and running `dune-bench`

> NOTE: this is _super not ready_ for production yet, and I'm only making it to support development of [`serde.ml`](https://github.com/leostera/serde.ml)

```ocaml
open Criterion

type t = | A
[%%deriving serializer, deserializer]

let%bench ser_json b = Serde_json.to_string serialize_t A

let%bench de_json b = Serde_json.of_string deserialize_t "\"A\""

[%suite ser_json de_json]

```

## Sample Results

The default CLI reporter shows you stats per test like this:

```
; dune exec ./criterion/test.exe
test 1              [iter:  1000; slow:    7ns; med:    1ns; fast:    0ns]
test 100            [iter:  1000; slow:   16ns; med:    4ns; fast:    0ns]
test 1_000          [iter:  1000; slow:  218ns; med:   17ns; fast:    6ns]
test 2_000          [iter:  1000; slow:  316ns; med:   30ns; fast:   13ns]
test 5_000          [iter:  1000; slow:  258ns; med:   54ns; fast:   27ns]
test 10_000         [iter:  1000; slow:  303ns; med:   92ns; fast:   55ns]
test 1_000_000      [iter:  1000; slow:    9μs; med: 6.85μs; fast: 6.33μs]
```
