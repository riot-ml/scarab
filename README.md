# scarab

A microbenchmarking framework for Riot inspired by Elixir's [benchee][benchee]
and Rust's [criterion-rs][criterion].

[benchee]: https://github.com/bencheeorg/benchee
[criterion]: https://github.com/bheisler/criterion.rs

```ocaml
Scarab.run [
  "ser_json", fun () -> Serde_json.to_string serialize_t A;
  "de_json", fun () -> Serde_json.of_json deserialize_t "\"A\"";
];;
```
