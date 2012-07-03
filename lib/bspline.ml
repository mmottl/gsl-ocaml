(* gsl-ocaml - OCaml interface to GSL                        *)
(* Copyright (©) 2007 - Olivier Andrieu                     *)
(* distributed under the terms of the GPL version 2         *)

type ws

external _alloc : k:int -> nbreak:int -> ws = "ml_gsl_bspline_alloc"
external _free  : ws -> unit = "ml_gsl_bspline_free"

let make ~k ~nbreak =
  let ws = _alloc ~k ~nbreak in
  Gc.finalise _free ws ;
  ws

external ncoeffs : ws -> int = "ml_gsl_bspline_ncoeffs" "noalloc"

open Vectmat

external knots : [< vec] -> ws -> unit = "ml_gsl_bspline_knots"
external knots_uniform : a:float -> b:float -> ws -> unit = "ml_gsl_bspline_knots_uniform"

external _eval : float -> [< vec] -> ws -> unit = "ml_gsl_bspline_eval"
let eval ws x =
  let n = ncoeffs ws in
  let v = `V (Vector.create n) in
  _eval x v ws ;
  v

