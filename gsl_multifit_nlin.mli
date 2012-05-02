(* gsl-ocaml - OCaml interface to GSL                        *)
(* Copyright (©) 2002-2005 - Olivier Andrieu                *)
(* distributed under the terms of the GPL version 2         *)

(** Nonlinear Least-Squares Fitting *)

open Gsl_fun
open Gsl_vector

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

external covar : t -> epsrel:float -> Gsl_matrix.matrix -> unit
    = "ml_gsl_multifit_covar"

