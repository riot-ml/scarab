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
test 1              [elapsed_time:    41ns; rate:  24.39 ops/ns]
test 100            [elapsed_time:   738ns; rate:   1.36 ops/ns]
test 1_000          [elapsed_time:     7μs; rate:   0.13 ops/ns]
test 2_000          [elapsed_time:     1ms; rate:   0.06 ops/ns]
test 5_000          [elapsed_time:     3ms; rate:   0.03 ops/ns]
test 10_000         [elapsed_time:     6ms; rate:   0.02 ops/ns]
test 1_000_000      [elapsed_time:   690ms; rate:   0.00 ops/ns]
```
