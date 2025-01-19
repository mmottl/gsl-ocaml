(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2012 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)

let () = Error.init ()

open Fun
open Vector

type t
type kind = LMSDER | LMDER

external _alloc : kind -> n:int -> p:int -> t
  = "ml_gsl_multifit_fdfsolver_alloc"

external _free : t -> unit = "ml_gsl_multifit_fdfsolver_free"

external _set : t -> multi_fun_fdf -> vector -> unit
  = "ml_gsl_multifit_fdfsolver_set"

let make kind ~n ~p gf x =
  let s = _alloc kind ~n ~p in
  Gc.finalise _free s;
  _set s gf x;
  s

external name : t -> string = "ml_gsl_multifit_fdfsolver_name"
external iterate : t -> unit = "ml_gsl_multifit_fdfsolver_iterate"
external position : t -> vector -> unit = "ml_gsl_multifit_fdfsolver_position"

external get_state : t -> ?x:vector -> ?f:vector -> ?dx:vector -> unit -> unit
  = "ml_gsl_multifit_fdfsolver_get_state"

external test_delta : t -> epsabs:float -> epsrel:float -> bool
  = "ml_gsl_multifit_test_delta"

external test_gradient : t -> Matrix.matrix -> epsabs:float -> vector -> bool
  = "ml_gsl_multifit_test_gradient"

external covar : Matrix.matrix -> epsrel:float -> Matrix.matrix -> unit
  = "ml_gsl_multifit_covar"
