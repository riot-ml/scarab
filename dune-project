(lang dune 3.10)

(name criterion)

(generate_opam_files true)

(source
 (github leostera/criterion.ml))

(authors "Leandro Ostera <leandro@abstractmachines.dev>")

(maintainers "Leandro Ostera <leandro@abstractmachines.dev>")

(license "MIT")

(package
 (name criterion)
 (synopsis "Microbenchmark in OCaml")
 (description "")
 (depends
   (ocaml (>= "4.12.0"))
   (dune (>= "3.5"))
   (ocamlformat (>= "0.17.0"))
   (ppx_inline_test (>= "0.16.0"))
   (time_now (>= "0.16.0"))
   ))

(package
 (name criterion_derive)
 (synopsis "Derive-macros for the Criterion microbenchmarking framework")
 (description "These macros help mark functions as benchmarks and avoid boilerplate")
 (depends
   (ocaml (>= "4.12.0"))
   (dune (>= "3.5"))
   (ppxlib (>= "0.28.0"))
   (ppx_deriving (>= "5.2.1"))
   (criterion :version)
   ))

(package
 (name dune_bench)
 (synopsis "Dune benchmark runner")
 (description "Adds a `bench` command to dune that will find and execute all of the functions marked with the `[%%bench]` annotation.")
 (depends
   (ocaml (>= "4.12.0"))
   (dune (>= "3.5"))
   (ppxlib (>= "0.28.0"))
   (criterion :version)
   (ppx_deriving (>= "5.2.1"))
   ))
