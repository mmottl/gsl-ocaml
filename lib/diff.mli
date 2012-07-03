(* gsl-ocaml - OCaml interface to GSL                        *)
(* Copyright (©) 2002-2005 - Olivier Andrieu                *)
(* Distributed under the terms of the LGPL version 2.1      *)

(** Numerical Differentiation *)

external central  : Fun.gsl_fun -> float -> Fun.result
    = "ml_gsl_diff_central"

external forward  : Fun.gsl_fun -> float -> Fun.result
    = "ml_gsl_diff_forward"

external backward : Fun.gsl_fun -> float -> Fun.result
    = "ml_gsl_diff_backward"
