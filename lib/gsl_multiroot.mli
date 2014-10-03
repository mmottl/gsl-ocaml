(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2012 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)

(** Multidimensional Root-Finding *)

open Fun
open Vector

module NoDeriv :
sig

type kind = 
  | HYBRIDS
  | HYBRID
  | DNEWTON
  | BROYDEN

type t

val make : kind -> int -> multi_fun -> vector -> t

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


module Deriv :
sig

type kind = 
  | HYBRIDSJ
  | HYBRIDJ
  | NEWTON
  | GNEWTON

type t

val make : kind -> int -> multi_fun_fdf -> vector -> t

external name : t -> string
    = "ml_gsl_multiroot_fdfsolver_name"

external iterate : t -> unit
    = "ml_gsl_multiroot_fdfsolver_iterate"

external root : t -> vector -> unit
    = "ml_gsl_multiroot_fdfsolver_root"

external get_state : t -> 
  ?x:vector -> ?f:vector -> 
  ?j:Matrix.matrix -> ?dx:vector -> unit -> unit
    = "ml_gsl_multiroot_fdfsolver_get_state_bc" "ml_gsl_multiroot_fdfsolver_get_state"

external test_delta : t -> epsabs:float -> epsrel:float -> bool
    = "ml_gsl_multiroot_test_delta_fdf"

external test_residual : t -> epsabs:float -> bool
    = "ml_gsl_multiroot_test_residual_fdf"
end
