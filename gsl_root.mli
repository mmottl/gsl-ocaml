(* ocamlgsl - OCaml interface to GSL                        *)
(* Copyright (©) 2002-2005 - Olivier Andrieu                *)
(* distributed under the terms of the GPL version 2         *)

(** One dimensional Root-Finding *)

module Bracket : 
sig

type kind = 
  | BISECTION
  | FALSEPOS
  | BRENT
type t

val make : kind -> Gsl_fun.gsl_fun -> float -> float -> t

external name : t -> string
    = "ml_gsl_root_fsolver_name"
external iterate : t -> unit
    = "ml_gsl_root_fsolver_iterate"
external root : t -> float
    = "ml_gsl_root_fsolver_root"

external interval : t -> float * float
    = "ml_gsl_root_fsolver_x_interv"
end

module Polish : 
sig

type kind = 
  | NEWTON 
  | SECANT
  | STEFFENSON
type t

val make : kind -> Gsl_fun.gsl_fun_fdf -> float -> t

external name : t -> string
    = "ml_gsl_root_fdfsolver_name"
external iterate : t -> unit
    = "ml_gsl_root_fdfsolver_iterate"
external root : t -> float
    = "ml_gsl_root_fdfsolver_root"
end

external test_interval :
  lo:float -> up:float -> epsabs:float -> epsrel:float -> bool
  = "ml_gsl_root_test_interval"
external test_delta :
  x1:float -> x0:float -> epsabs:float -> epsrel:float -> bool
  = "ml_gsl_root_test_delta"
external test_residual : f:float -> epsabs:float -> bool
  = "ml_gsl_root_test_residual"
