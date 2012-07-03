(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2005 - Olivier Andrieu                *)
(* Distributed under the terms of the LGPL version 2.1      *)

type qrng_type =
  | NIEDERREITER_2
  | SOBOL

type t
external _alloc : qrng_type -> int -> t
    = "ml_gsl_qrng_alloc"
external _free  : t -> unit
    = "ml_gsl_qrng_free"
external init  : t -> unit 
    = "ml_gsl_qrng_init"

let make t d =
  let qrng = _alloc t d in
  Gc.finalise _free qrng ;
  qrng

external dimension : t -> int
    = "ml_gsl_qrng_dimension"

external name : t -> string
    = "ml_gsl_qrng_name"

external memcpy : src:t -> dst:t -> unit
    = "ml_gsl_qrng_memcpy"

external clone : t -> t
    = "ml_gsl_qrng_clone"

external get : t -> float array -> unit
    = "ml_gsl_qrng_get"

external sample : t -> float array
    = "ml_gsl_qrng_sample"
