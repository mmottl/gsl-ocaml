(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2005 - Olivier Andrieu                *)
(* Distributed under the terms of the LGPL version 2.1      *)

type t

external _alloc : int -> t
    = "ml_gsl_cheb_alloc"
external _free :  t -> unit
    = "ml_gsl_cheb_free"

let make n =
  let cs = _alloc n in
  Gc.finalise _free cs ;
  cs

external order : t -> int
    = "ml_gsl_cheb_order"

external coefs : t -> float array = "ml_gsl_cheb_coefs"

external init : t -> Fun.gsl_fun -> a:float -> b:float -> unit
    = "ml_gsl_cheb_init"

external _eval : t -> float -> float
    = "ml_gsl_cheb_eval"

external _eval_err : t -> float -> Fun.result
    = "ml_gsl_cheb_eval_err"

external _eval_n : t -> int -> float -> float
    = "ml_gsl_cheb_eval_n"

external _eval_n_err : t -> int -> float -> Fun.result
    = "ml_gsl_cheb_eval_n_err"

let eval cs ?order x =
  match order with
  | None -> _eval cs x
  | Some o -> _eval_n cs o x

let eval_err cs ?order x =
  match order with
  | None -> _eval_err cs x
  | Some o -> _eval_n_err cs o x

external calc_deriv : t -> t -> unit
    = "ml_gsl_cheb_calc_deriv"
external calc_integ : t -> t -> unit
    = "ml_gsl_cheb_calc_integ"

let deriv cs = 
  let d = make (order cs) in
  calc_deriv d cs ;
  d

let integ cs = 
  let d = make (order cs) in
  calc_integ d cs ;
  d
