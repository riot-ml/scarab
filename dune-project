(lang dune 3.10)
(using mdx 0.4)

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
   (riot (>= "0.0.8"))
   (minttea (>= "0.0.2"))
   (mdx (and :with-test (>= "2.3.1")))
   dune
   )
 (tags (microbenchmark benchmark bench riot multicore tui minttea)))
