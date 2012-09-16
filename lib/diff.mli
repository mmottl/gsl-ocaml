(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2012 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)

(** Numerical Differentiation *)

external central  : Fun.gsl_fun -> float -> Fun.result
    = "ml_gsl_diff_central"

external forward  : Fun.gsl_fun -> float -> Fun.result
    = "ml_gsl_diff_forward"

external backward : Fun.gsl_fun -> float -> Fun.result
    = "ml_gsl_diff_backward"
