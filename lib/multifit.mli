(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2012 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)

(** Multi-parameter Least-Squares Fitting *)

open Vectmat

type ws
val make : n:int -> p:int -> ws

external _linear :
  ?weight:vec ->
  x:mat -> y:vec ->
  c:vec -> cov:mat -> ws -> float
  = "ml_gsl_multifit_linear_bc" "ml_gsl_multifit_linear"

external _linear_svd :
  ?weight:vec ->
  x:mat -> y:vec -> tol:float ->
  c:vec -> cov:mat -> ws -> int * float
  = "ml_gsl_multifit_linear_svd_bc" "ml_gsl_multifit_linear_svd"

val linear :
  ?weight:vec -> mat -> vec -> 
    Vector.vector * Matrix.matrix * float

external linear_est : x:vec -> c:vec -> cov:mat -> Fun.result
    = "ml_gsl_multifit_linear_est"

val fit_poly : 
    ?weight:float array -> x:float array -> y:float array -> int ->
      float array * float array array * float
