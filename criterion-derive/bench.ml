open Ppxlib
module Ast = Ast_builder.Default

let ext_name = "bench"

(** helpers *)
let loc ~ctxt = Expansion_context.Extension.extension_point_loc ctxt

(** let bench expansion *)
let expand_let_bench ~loc ~path:_ pat expr =
  [%stri let [%p pat] = Bench.make ~name:"some benchmark" [%e expr]]

(** bench extension *)
let bench_ext =
  let pattern =
    let open Ast_pattern in
    pstr
      (pstr_value nonrecursive (value_binding ~pat:__ ~expr:__ ^:: nil) ^:: nil)
  in

  Extension.declare ext_name Extension.Context.structure_item pattern
    expand_let_bench

(** registration *)
let () = Driver.register_transformation ext_name ~extensions:[ bench_ext ]
