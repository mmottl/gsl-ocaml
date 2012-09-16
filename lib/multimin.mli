(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2012 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)

(** Multidimensional Minimization *)

open Fun
open Vector

module Deriv :
sig

type kind = 
  | CONJUGATE_FR
  | CONJUGATE_PR
  | VECTOR_BFGS
  | VECTOR_BFGS2
  | STEEPEST_DESCENT

type t

val make : kind -> int -> multim_fun_fdf -> x:vector ->
  step:float -> tol:float -> t

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


module NoDeriv :
sig

type kind = 
  | NM_SIMPLEX

type t

val make : kind -> int -> multim_fun -> x:vector ->
  step_size:vector -> t

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
