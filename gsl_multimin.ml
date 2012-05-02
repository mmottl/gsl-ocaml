(* gsl-ocaml - OCaml interface to GSL                        *)
(* Copyright (©) 2002-2005 - Olivier Andrieu                *)
(* distributed under the terms of the GPL version 2         *)

open Gsl_fun
open Gsl_vector

module Deriv = 
struct

type kind = 
  | CONJUGATE_FR
  | CONJUGATE_PR
  | VECTOR_BFGS
  | VECTOR_BFGS2
  | STEEPEST_DESCENT

type t

external _alloc : kind -> int -> t 
    = "ml_gsl_multimin_fdfminimizer_alloc"

external _free : t -> unit
    = "ml_gsl_multimin_fdfminimizer_free"

external _set : t -> multim_fun_fdf -> x:vector ->
  step:float -> tol:float -> unit
    = "ml_gsl_multimin_fdfminimizer_set"

let make kind dim gf ~x ~step ~tol =
  let mini = _alloc kind dim in
  Gc.finalise _free mini ;
  _set mini gf ~x ~step ~tol ;
  mini

external name : t -> string
    = "ml_gsl_multimin_fdfminimizer_name"

external iterate : t -> unit
    = "ml_gsl_multimin_fdfminimizer_iterate"

external restart : t -> unit
    = "ml_gsl_multimin_fdfminimizer_restart"

external minimum : ?x:vector -> ?dx:vector -> ?g:vector -> t -> float
    = "ml_gsl_multimin_fdfminimizer_minimum"

external test_gradient : t -> float -> bool
    = "ml_gsl_multimin_test_gradient"
end


module NoDeriv = 
struct

type kind = 
  | NM_SIMPLEX

type t

external _alloc : kind -> int -> t 
    = "ml_gsl_multimin_fminimizer_alloc"

external _free : t -> unit
    = "ml_gsl_multimin_fminimizer_free"

external _set : t -> multim_fun -> x:vector ->
  step_size:vector -> unit
    = "ml_gsl_multimin_fminimizer_set"

let make kind dim gf ~x ~step_size =
  let mini = _alloc kind dim in
  Gc.finalise _free mini ;
  _set mini gf ~x ~step_size ;
  mini

external name : t -> string
    = "ml_gsl_multimin_fminimizer_name"

external iterate : t -> unit
    = "ml_gsl_multimin_fminimizer_iterate"

external minimum : ?x:vector -> t -> float
    = "ml_gsl_multimin_fminimizer_minimum"

external size : t  -> float
    = "ml_gsl_multimin_fminimizer_size"

external test_size : t -> float -> bool
    = "ml_gsl_multimin_test_size"
end
