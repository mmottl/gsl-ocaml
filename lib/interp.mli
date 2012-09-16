(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2012 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)

(** Interpolation *)

type t
type accel
type interp_type =
  | LINEAR
  | POLYNOMIAL
  | CSPLINE
  | CSPLINE_PERIODIC
  | AKIMA
  | AKIMA_PERIODIC

val make : interp_type -> int -> t 
val init : t -> float array -> float array -> unit

external name : t -> string 
    = "ml_gsl_interp_name"

external min_size : t -> int
    = "ml_gsl_interp_min_size"

val make_accel : unit -> accel

external i_eval : t -> float array -> float array 
  -> float -> accel -> float
      = "ml_gsl_interp_eval"

external i_eval_deriv : t -> float array -> float array 
  -> float -> accel -> float
      = "ml_gsl_interp_eval_deriv"

external i_eval_deriv2 : t -> float array -> float array 
  -> float -> accel -> float
      = "ml_gsl_interp_eval_deriv2"

external i_eval_integ : t -> float array -> float array 
  -> float -> float -> accel -> float
      = "ml_gsl_interp_eval_integ_bc" "ml_gsl_interp_eval_integ"


(** {3 Higher level functions} *)

type interp = {
    interp : t ;
    accel  : accel ;
    xa     : float array ;
    ya     : float array ;
    size   : int ;
    i_type : interp_type ;
  }

val make_interp : interp_type -> float array -> float array -> interp

val eval : interp -> float -> float

(** [eval_array interp x_a y_a] fills the array [y_a] with the 
   evaluation of the interpolation function [interp] for each point
   of array [x_a]. [x_a] and [y_a] must have the same length. *)
external eval_array : interp -> float array -> float array -> unit
    = "ml_gsl_interp_eval_array"

val eval_deriv  : interp -> float -> float

val eval_deriv2 : interp -> float -> float

val eval_integ  : interp -> float -> float -> float
