(* gsl-ocaml - OCaml interface to GSL                        *)
(* Copyright (©) 2002-2005 - Olivier Andrieu                *)
(* distributed under the terms of the GPL version 2         *)

open Fun
open Vector

module NoDeriv = 
struct

type kind = 
  | HYBRIDS
  | HYBRID
  | DNEWTON
  | BROYDEN
type t

external _alloc : kind -> int -> t
    = "ml_gsl_multiroot_fsolver_alloc"

external _free : t -> unit
    = "ml_gsl_multiroot_fsolver_free"

external _set : t -> multi_fun -> vector -> unit
    = "ml_gsl_multiroot_fsolver_set"

let make kind dim f x = 
  let s = _alloc kind dim in
  Gc.finalise _free s ;
  _set s f x ;
  s

external name : t -> string
    = "ml_gsl_multiroot_fsolver_name"

external iterate : t -> unit
    = "ml_gsl_multiroot_fsolver_iterate"

external root : t -> vector -> unit
    = "ml_gsl_multiroot_fsolver_root"

external get_state : t -> 
  ?x:vector -> ?f:vector -> 
  ?dx:vector -> unit -> unit
    = "ml_gsl_multiroot_fsolver_get_state"

external test_delta : t -> epsabs:float -> epsrel:float -> bool
    = "ml_gsl_multiroot_test_delta_f"

external test_residual : t -> epsabs:float -> bool
    = "ml_gsl_multiroot_test_residual_f"
end

module Deriv = 
struct

type kind = 
  | HYBRIDSJ
  | HYBRIDJ
  | NEWTON
  | GNEWTON

type t

external _alloc : kind -> int -> t
    = "ml_gsl_multiroot_fdfsolver_alloc"

external _free : t -> unit
    = "ml_gsl_multiroot_fdfsolver_free"

external _set : t -> multi_fun_fdf -> vector -> unit
    = "ml_gsl_multiroot_fdfsolver_set"

let make kind dim f x = 
  let s = _alloc kind dim in
  Gc.finalise _free s ;
  _set s f x ;
  s

external name : t -> string
    = "ml_gsl_multiroot_fdfsolver_name"

external root : t -> vector -> unit
    = "ml_gsl_multiroot_fdfsolver_root"

external iterate : t -> unit
    = "ml_gsl_multiroot_fdfsolver_iterate"

external get_state : t -> 
  ?x:vector -> ?f:vector -> 
  ?j:Matrix.matrix -> ?dx:vector -> unit -> unit
    = "ml_gsl_multiroot_fdfsolver_get_state_bc" "ml_gsl_multiroot_fdfsolver_get_state"

external test_delta : t -> epsabs:float -> epsrel:float -> bool
    = "ml_gsl_multiroot_test_delta_fdf"

external test_residual : t -> epsabs:float -> bool
    = "ml_gsl_multiroot_test_residual_fdf"
end
