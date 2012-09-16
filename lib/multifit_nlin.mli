(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2012 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)

(** Nonlinear Least-Squares Fitting *)

open Fun
open Vector

type t

type kind =
  | LMSDER
  | LMDER


val make : kind -> n:int -> p:int -> multi_fun_fdf -> vector -> t

external name : t -> string
    = "ml_gsl_multifit_fdfsolver_name"

external iterate : t -> unit
    = "ml_gsl_multifit_fdfsolver_iterate"

external position : t -> vector -> unit
    = "ml_gsl_multifit_fdfsolver_position"

external get_state : t -> ?x:vector -> ?f:vector -> 
  ?dx:vector -> unit -> unit
    = "ml_gsl_multifit_fdfsolver_get_state"

external test_delta : t -> epsabs:float -> epsrel:float -> bool
    = "ml_gsl_multifit_test_delta"

external test_gradient : t -> epsabs:float -> vector -> bool
    = "ml_gsl_multifit_test_gradient"

external covar : t -> epsrel:float -> Matrix.matrix -> unit
    = "ml_gsl_multifit_covar"

