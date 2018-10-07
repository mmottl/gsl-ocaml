open Base
open Stdio

let gsl_include_dir =
  let gsl_include = List.hd_exn (In_channel.read_lines "gsl_include.sexp") in
  Caml.Filename.concat gsl_include "gsl"
