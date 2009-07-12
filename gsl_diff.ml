(* ocamlgsl - OCaml interface to GSL                        *)
(* Copyright (©) 2002-2005 - Olivier Andrieu                *)
(* distributed under the terms of the GPL version 2         *)


external central  : Gsl_fun.gsl_fun -> float -> Gsl_fun.result
    = "ml_gsl_diff_central"

external forward  : Gsl_fun.gsl_fun -> float -> Gsl_fun.result
    = "ml_gsl_diff_forward"

external backward : Gsl_fun.gsl_fun -> float -> Gsl_fun.result
    = "ml_gsl_diff_backward"
