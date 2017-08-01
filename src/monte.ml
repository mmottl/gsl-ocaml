(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2012 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)


open Fun

(* PLAIN algorithm *)
type plain_state
external _alloc_plain : int -> plain_state
    = "ml_gsl_monte_plain_alloc"
external _free_plain : plain_state -> unit
    = "ml_gsl_monte_plain_free"
let make_plain_state s =
  let state = _alloc_plain s in
  Gc.finalise _free_plain state ;
  state
external init_plain : plain_state -> unit
    = "ml_gsl_monte_plain_init"


external integrate_plain : monte_fun -> lo:float array -> up:float array ->
  int -> Rng.t -> plain_state -> Fun.result
    = "ml_gsl_monte_plain_integrate_bc" "ml_gsl_monte_plain_integrate"


(* MISER algorithm *)
type miser_state
type miser_params = {
    estimate_frac : float ;		(* 0.1 *)
    min_calls     : int ;		(* 16 * dim *)
    min_calls_per_bisection : int ;	(* 32 * min_calls *)
    miser_alpha   : float ;		(* 2. *)
    dither        : float ;             (* 0. *)
  } 

external _alloc_miser : int -> miser_state
    = "ml_gsl_monte_miser_alloc"
external _free_miser : miser_state -> unit
    = "ml_gsl_monte_miser_free"
let make_miser_state s =
  let state = _alloc_miser s in
  Gc.finalise _free_miser state ;
  state
external init_miser : miser_state -> unit
    = "ml_gsl_monte_miser_init"


external integrate_miser : monte_fun -> lo:float array -> up:float array ->
  int -> Rng.t -> miser_state -> Fun.result
    = "ml_gsl_monte_miser_integrate_bc" "ml_gsl_monte_miser_integrate"

external get_miser_params : miser_state -> miser_params
    = "ml_gsl_monte_miser_get_params"

external set_miser_params : miser_state -> miser_params -> unit
    = "ml_gsl_monte_miser_set_params"


(* VEGAS algorithm *)
type vegas_state
type vegas_info = {
    result : float ;
    sigma  : float ;
    chisq  : float ;
  } 
type vegas_mode = | STRATIFIED | IMPORTANCE_ONLY | IMPORTANCE 
type vegas_params = {
    vegas_alpha   : float ;		  (* 1.5 *)
    iterations    : int ;		  (* 5 *)
    stage         : int ;
    mode          : vegas_mode ;
    verbose       : int ;		  (* 0 *)
    ostream       : out_channel option ;  (* stdout *)
  } 

external _alloc_vegas : int -> vegas_state
    = "ml_gsl_monte_vegas_alloc"
external _free_vegas : vegas_state -> unit
    = "ml_gsl_monte_vegas_free"
let make_vegas_state s =
  let state = _alloc_vegas s in
  Gc.finalise _free_vegas state ;
  state
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



(* High-level version *)
type kind =
  | PLAIN
  | MISER
  | VEGAS

let integrate kind f ~lo ~up calls rng =
  let dim = Array.length lo in
  let with_state alloc free integ =
    let state = alloc dim in
    try 
      let res = integ f ~lo ~up calls rng state in
      free state ; res
    with exn -> free state ; raise exn in
  match kind with
  | PLAIN ->
      with_state _alloc_plain _free_plain integrate_plain
  | MISER ->
      with_state _alloc_miser _free_miser integrate_miser
  | VEGAS ->
      with_state _alloc_vegas _free_vegas integrate_vegas
