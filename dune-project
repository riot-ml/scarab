(lang dune 3.10)

(name scarab)

(generate_opam_files true)

(source
 (github leostera/scarab))

(authors "Leandro Ostera <leandro@abstractmachines.dev>")

(maintainers "Leandro Ostera <leandro@abstractmachines.dev>")

(license "MIT")

(package
 (name scarab)
 (synopsis "Microbenchmarking framework for Riot")
 (description "")
 (depends
   (ocaml (>= "5.1.1"))
   dune
   (ocamlformat (>= "0.17.0"))
   ))
