(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2012 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)


let () = Error.init ()

type system 

external _alloc : 
  (float -> float array -> float array -> unit) ->
  ?jacobian:(float -> float array -> Matrix.matrix -> float array -> unit) ->
  int -> system = "ml_gsl_odeiv_alloc_system"

external _free : system -> unit = "ml_gsl_odeiv_free_system"

let make_system f ?jac dim =
  let s = _alloc f ?jacobian:jac dim in
  Gc.finalise _free s ;
  s

type step
type step_kind = 
  | RK2
  | RK4
  | RKF45 
  | RKCK
  | RK8PD 
  | RK2IMP
  | RK2SIMP
  | RK4IMP 
  | BSIMP
  | GEAR1 
  | GEAR2

external _step_alloc : step_kind -> dim:int -> step = "ml_gsl_odeiv_step_alloc"
external _step_free : step -> unit = "ml_gsl_odeiv_step_free"

let make_step kind ~dim = 
  let s = _step_alloc kind ~dim in
  Gc.finalise _step_free s ;
  s

external step_reset : step -> unit = "ml_gsl_odeiv_step_reset"
external step_name  : step -> string = "ml_gsl_odeiv_step_name"
external step_order : step -> int = "ml_gsl_odeiv_step_order"

external step_apply : step -> t:float -> h:float -> y:float array ->
  yerr:float array -> ?dydt_in:float array -> ?dydt_out:float array ->
    system -> unit
	= "ml_gsl_odeiv_step_apply_bc" "ml_gsl_odeiv_step_apply"


type control

external _control_free : control -> unit = "ml_gsl_odeiv_control_free"
external _control_standard_new : eps_abs:float -> eps_rel:float ->
  a_y:float -> a_dydt:float -> control = "ml_gsl_odeiv_control_standard_new"
external _control_y_new  : eps_abs:float -> eps_rel:float -> control = "ml_gsl_odeiv_control_y_new"
external _control_yp_new : eps_abs:float -> eps_rel:float -> control = "ml_gsl_odeiv_control_yp_new"
external _control_scaled_new : eps_abs:float -> eps_rel:float ->
  a_y:float -> a_dydt:float -> scale_abs:float array -> control = "ml_gsl_odeiv_control_scaled_new"

let make_control_standard_new ~eps_abs ~eps_rel ~a_y ~a_dydt =
  let c = _control_standard_new ~eps_abs ~eps_rel ~a_y ~a_dydt in
  Gc.finalise _control_free c ;
  c
let make_control_y_new ~eps_abs ~eps_rel =
  let c = _control_y_new ~eps_abs ~eps_rel in
  Gc.finalise _control_free c ;
  c
let make_control_yp_new ~eps_abs ~eps_rel =
  let c = _control_yp_new ~eps_abs ~eps_rel in
  Gc.finalise _control_free c ;
  c
let make_control_scaled_new ~eps_abs ~eps_rel ~a_y ~a_dydt ~scale_abs =
  let c = _control_scaled_new ~eps_abs ~eps_rel ~a_y ~a_dydt ~scale_abs in
  Gc.finalise _control_free c ;
  c

external control_name : control -> string = "ml_gsl_odeiv_control_name"

type hadjust =
  | HADJ_DEC
  | HADJ_NIL
  | HADJ_INC

external control_hadjust : control -> step -> y:float array ->
  yerr:float array -> dydt:float array -> h:float -> hadjust * float
      = "ml_gsl_odeiv_control_hadjust_bc" "ml_gsl_odeiv_control_hadjust"

type evolve

external _evolve_alloc : int -> evolve = "ml_gsl_odeiv_evolve_alloc"
external _evolve_free  : evolve -> unit = "ml_gsl_odeiv_evolve_free"
let make_evolve dim =
  let e = _evolve_alloc dim in
  Gc.finalise _evolve_free e ;
  e

external evolve_reset : evolve -> unit = "ml_gsl_odeiv_evolve_reset"

external evolve_apply : evolve -> control -> step -> system ->
  t:float -> t1:float -> h:float -> y:float array -> float * float
      = "ml_gsl_odeiv_evolve_apply_bc" "ml_gsl_odeiv_evolve_apply"
