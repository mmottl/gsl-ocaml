(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2012 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)


(* C code in mlgsl_deriv.c *)

external central : f:(float -> float) -> x:float -> h:float -> Fun.result
  = "ml_gsl_deriv_central"

external forward : f:(float -> float) -> x:float -> h:float -> Fun.result
  = "ml_gsl_deriv_forward"

external backward : f:(float -> float) -> x:float -> h:float -> Fun.result
  = "ml_gsl_deriv_backward"
