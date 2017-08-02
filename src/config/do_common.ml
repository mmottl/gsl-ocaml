open Base
open Stdio

let gsl_include_dir =
  let str = In_channel.read_all "gsl_include.sexp" in
  Caml.Filename.concat (string_of_sexp (sexp_of_string str)) "gsl"
