(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2012 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)

(** One dimensional Minimization *)

type kind = 
  | GOLDENSECTION
  | BRENT

type t

val make :
  kind -> Fun.gsl_fun -> min:float -> lo:float -> up:float -> t
external name : t -> string
    = "ml_gsl_min_fminimizer_name"

external iterate : t -> unit
    = "ml_gsl_min_fminimizer_iterate"
external minimum : t -> float
    = "ml_gsl_min_fminimizer_x_minimum"
external interval : t -> float * float
    = "ml_gsl_min_fminimizer_x_interv"

external test_interval :
  x_lo:float -> x_up:float -> epsabs:float -> epsrel:float -> bool
  = "ml_gsl_min_test_interval"
