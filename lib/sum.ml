(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2005 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)


type ws

external _alloc : int -> ws
    = "ml_gsl_sum_levin_u_alloc"

external _free : ws -> unit
    = "ml_gsl_sum_levin_u_free"

let make size = 
  let ws = _alloc size in
  Gc.finalise _free ws ;
  ws

external accel : float array -> ws -> Fun.result
    = "ml_gsl_sum_levin_u_accel"

type ws_info = {
    size       : int ;
    terms_used : int ;
    sum_plain  : float ;
  } 

external get_info : ws -> ws_info
    = "ml_gsl_sum_levin_u_getinfo"
   
 
module Trunc =
struct
type ws

external _alloc : int -> ws
    = "ml_gsl_sum_levin_utrunc_alloc"

external _free : ws -> unit
    = "ml_gsl_sum_levin_utrunc_free"

let make size = 
  let ws = _alloc size in
  Gc.finalise _free ws ;
  ws

external accel : float array -> ws -> Fun.result
    = "ml_gsl_sum_levin_utrunc_accel"

type ws_info = {
    size       : int ;
    terms_used : int ;
    sum_plain  : float ;
  } 

external get_info : ws -> ws_info
    = "ml_gsl_sum_levin_utrunc_getinfo"
end
