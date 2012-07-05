(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2005 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)

type ieee_type = 
  | NAN
  | INF
  | NORMAL
  | DENORMAL
  | ZERO

type float_rep = {
    sign : int ;
    mantissa : string ;
    exponent : int ;
    ieee_type : ieee_type ;
  }


external rep_of_float : float -> float_rep 
    = "ml_gsl_ieee_double_to_rep"

external env_setup : unit -> unit
    = "ml_gsl_ieee_env_setup"

type precision =
  | SINGLE
  | DOUBLE
  | EXTENDED
type rounding =
  | TO_NEAREST
  | DOWN
  | UP
  | TO_ZERO
type exceptions =
  | MASK_INVALID
  | MASK_DENORMALIZED
  | MASK_DIVISION_BY_ZERO
  | MASK_OVERFLOW
  | MASK_UNDERFLOW
  | MASK_ALL
  | TRAP_INEXACT
external set_mode : ?precision:precision -> ?rounding:rounding -> exceptions list -> unit
    = "ml_gsl_ieee_set_mode"

let print f = 
  let rep = rep_of_float f in
  match rep.ieee_type with
  | NAN -> "NaN"
  | INF when rep.sign = 0 -> "Inf"
  | INF -> "-Inf"
  | ZERO when rep.sign = 0 -> "0"
  | ZERO -> "-0"
  | DENORMAL ->
      (if rep.sign = 0
      then "" else "-")  ^ 
      "0." ^ rep.mantissa ^
      (if rep.exponent = 0
      then "" else string_of_int rep.exponent)
  | NORMAL ->
      (if rep.sign = 0
      then "" else "-")  ^ 
      "1." ^ rep.mantissa ^
      (if rep.exponent = 0
      then "" else ("*2^" ^ (string_of_int rep.exponent)))
      
type excepts =
  | FE_INEXACT
  | FE_DIVBYZERO
  | FE_UNDERFLOW
  | FE_OVERFLOW
  | FE_INVALID
  | FE_ALL_EXCEPT
external clear_except : excepts list -> unit = "ml_feclearexcept"
external test_except  : excepts list -> excepts list = "ml_fetestexcept"
