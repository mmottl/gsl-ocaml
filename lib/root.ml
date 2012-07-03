(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2005 - Olivier Andrieu                *)
(* Distributed under the terms of the LGPL version 2.1      *)

module Bracket = 
struct

type kind =
  | BISECTION
  | FALSEPOS
  | BRENT

type t

external _alloc : kind -> t
    = "ml_gsl_root_fsolver_alloc"

external _free : t -> unit
    = "ml_gsl_root_fsolver_free"

external _set : t -> Fun.gsl_fun -> float -> float -> unit
    = "ml_gsl_root_fsolver_set"

let make kind f x y  =
  let s = _alloc kind in
  Gc.finalise _free s ;
  _set s f x y ;
  s

external name : t -> string
    = "ml_gsl_root_fsolver_name"

external iterate : t -> unit
    = "ml_gsl_root_fsolver_iterate"

external root : t -> float
    = "ml_gsl_root_fsolver_root" 

external interval : t -> float * float
    = "ml_gsl_root_fsolver_x_interv"

end


module Polish =
struct

type kind =
  | NEWTON
  | SECANT
  | STEFFENSON

type t

external _alloc : kind -> t
    = "ml_gsl_root_fdfsolver_alloc"

external _free : t -> unit
    = "ml_gsl_root_fdfsolver_free"

external _set : t -> Fun.gsl_fun_fdf -> float -> unit
    = "ml_gsl_root_fdfsolver_set"

let make kind f r =
  let s = _alloc kind in
  Gc.finalise _free s ;
  _set s f r ;
  s

external name : t -> string
    = "ml_gsl_root_fdfsolver_name"

external iterate : t -> unit
    = "ml_gsl_root_fdfsolver_iterate"

external root : t -> float
    = "ml_gsl_root_fdfsolver_root" 

end

external test_interval : lo:float -> up:float -> epsabs:float -> epsrel:float -> bool
    = "ml_gsl_root_test_interval"
external test_delta : x1:float -> x0:float -> epsabs:float -> epsrel:float -> bool
    = "ml_gsl_root_test_delta"
external test_residual : f:float -> epsabs:float -> bool
    = "ml_gsl_root_test_residual"
