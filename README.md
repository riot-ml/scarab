# criterion.ml

A microbenchmarking framework for OCaml heavily inspired by [criterion-rs](https://github.com/bheisler/criterion.rs).

The main goals for `criterion.ml` are:

* **Ease-of-use** - setting up and running new benchmarks should be as easy as tagging a function with `[%%bench]` and running `dune-bench`

*  **

> NOTE: this is _super not ready_ for production yet, and I'm only making it to support development of [`serde.ml`](https://github.com/leostera/serde.ml)

```ocaml
open Criterion

type t = | A
[%%deriving serializer, deserializer]

[%%bench("serialize a json object")]
let ser_json b = Serde_json.to_string serialize_t A

[%%bench("deserialize a json string into a typed value")]
let de_json b = Serde_json.of_string deserialize_t "\"A\""

```
