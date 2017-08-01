(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2012 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)

(** Monte Carlo Integration *)

open Fun

(** {3 High-level interface} *)

type kind =
  | PLAIN
  | MISER
  | VEGAS

val integrate : kind -> monte_fun -> lo:float array -> up:float array ->
  int -> Rng.t -> Fun.result



(** {3 Low-level interface} *)

(** {4 PLAIN algorithm} *)

type plain_state
val make_plain_state : int -> plain_state
external init_plain : plain_state -> unit
    = "ml_gsl_monte_plain_init"
external integrate_plain :
  monte_fun ->
  lo:float array ->
  up:float array -> int -> Rng.t -> plain_state -> Fun.result
  = "ml_gsl_monte_plain_integrate_bc" "ml_gsl_monte_plain_integrate"


(** {4 MISER algorithm} *)

type miser_state
type miser_params = {
  estimate_frac           : float;
  min_calls               : int;
  min_calls_per_bisection : int;
  miser_alpha             : float;
  dither                  : float;
} 
val make_miser_state : int -> miser_state
external init_miser : miser_state -> unit
    = "ml_gsl_monte_miser_init"
external integrate_miser :
  monte_fun ->
  lo:float array ->
  up:float array -> int -> Rng.t -> miser_state -> Fun.result
  = "ml_gsl_monte_miser_integrate_bc" "ml_gsl_monte_miser_integrate"

external get_miser_params : miser_state -> miser_params
  = "ml_gsl_monte_miser_get_params"
external set_miser_params : miser_state -> miser_params -> unit
  = "ml_gsl_monte_miser_set_params"


(** {4 VEGAS algorithm} *)

type vegas_state
type vegas_info = {
    result : float ;
    sigma  : float ;
    chisq  : float ;
  } 
type vegas_mode = | STRATIFIED | IMPORTANCE_ONLY | IMPORTANCE 
type vegas_params = {
    vegas_alpha   : float ;		(** 1.5 *)
    iterations    : int ;		(** 5 *)
    stage         : int ;
    mode          : vegas_mode ;
    verbose       : int ;
    ostream       : out_channel option ;
  } 

val make_vegas_state : int -> vegas_state
external init_vegas : vegas_state -> unit
    = "ml_gsl_monte_vegas_init"

external integrate_vegas : monte_fun -> lo:float array -> up:float array ->
  int -> Rng.t -> vegas_state -> Fun.result
    = "ml_gsl_monte_vegas_integrate_bc" "ml_gsl_monte_vegas_integrate"

external get_vegas_info : vegas_state -> vegas_info
    = "ml_gsl_monte_vegas_get_info"
external get_vegas_params : vegas_state -> vegas_params
    = "ml_gsl_monte_vegas_get_params"
external set_vegas_params : vegas_state -> vegas_params -> unit
    = "ml_gsl_monte_vegas_set_params"
