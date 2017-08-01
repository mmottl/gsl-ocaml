open Base
open Stdio

let gsl_include_dir =
  Caml.Filename.concat
    (String.rstrip (In_channel.read_all "gsl_include.sexp")) "gsl"
