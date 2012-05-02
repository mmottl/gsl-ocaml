(* gsl-ocaml - OCaml interface to GSL                        *)
(* Copyright (©) 2002-2005 - Olivier Andrieu                *)
(* distributed under the terms of the GPL version 2         *)

(** Series Acceleration *)

type ws

val make : int -> ws

external accel : float array -> ws -> Gsl_fun.result
    = "ml_gsl_sum_levin_u_accel"

type ws_info = {
    size       : int ;
    terms_used : int ;
    sum_plain  : float ;
  } 
external get_info : ws -> ws_info
    = "ml_gsl_sum_levin_u_getinfo"

module Trunc :
sig
type ws

val make : int -> ws

external accel : float array -> ws -> Gsl_fun.result
    = "ml_gsl_sum_levin_utrunc_accel"

type ws_info = {
    size       : int ;
    terms_used : int ;
    sum_plain  : float ;
  } 
external get_info : ws -> ws_info
    = "ml_gsl_sum_levin_utrunc_getinfo"
end
