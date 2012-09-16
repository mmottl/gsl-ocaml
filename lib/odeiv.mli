(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2012 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)

(** Ordinary Differential Equations *)

type system

val make_system :
  (float -> float array -> float array -> unit) ->
  ?jac:(float -> float array -> Matrix.matrix -> float array -> unit) ->
  int -> system



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
val make_step : step_kind -> dim:int -> step
external step_reset : step -> unit = "ml_gsl_odeiv_step_reset"
external step_name  : step -> string = "ml_gsl_odeiv_step_name"
external step_order : step -> int = "ml_gsl_odeiv_step_order"
external step_apply :
  step ->
  t:float ->
  h:float ->
  y:float array ->
  yerr:float array ->
  ?dydt_in:float array -> ?dydt_out:float array -> system -> unit
  = "ml_gsl_odeiv_step_apply_bc" "ml_gsl_odeiv_step_apply"



type control
val make_control_standard_new :
  eps_abs:float -> eps_rel:float -> a_y:float -> a_dydt:float -> control
val make_control_y_new : eps_abs:float -> eps_rel:float -> control
val make_control_yp_new : eps_abs:float -> eps_rel:float -> control
val make_control_scaled_new :
  eps_abs:float -> eps_rel:float -> a_y:float -> a_dydt:float -> 
  scale_abs:float array -> control
external control_name : control -> string = "ml_gsl_odeiv_control_name"

type hadjust = 
  | HADJ_DEC 
  | HADJ_NIL 
  | HADJ_INC
external control_hadjust :
  control ->
  step ->
  y:float array ->
  yerr:float array -> dydt:float array -> h:float -> hadjust * float
  = "ml_gsl_odeiv_control_hadjust_bc" "ml_gsl_odeiv_control_hadjust"



type evolve
val make_evolve : int -> evolve
external evolve_reset : evolve -> unit = "ml_gsl_odeiv_evolve_reset"
external evolve_apply :
  evolve ->
  control ->
  step ->
  system ->
  t:float ->
  t1:float -> h:float -> y:float array -> float * float
  = "ml_gsl_odeiv_evolve_apply_bc" "ml_gsl_odeiv_evolve_apply"
