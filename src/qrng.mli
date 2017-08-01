(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2012 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)

(** Quasi-Random Sequences *)

type qrng_type =
  | NIEDERREITER_2
  | SOBOL

type t
val make : qrng_type -> int -> t

external init  : t -> unit 
    = "ml_gsl_qrng_init" 

external get : t -> float array -> unit
    = "ml_gsl_qrng_get"

external sample : t -> float array
    = "ml_gsl_qrng_sample"

external name : t -> string
    = "ml_gsl_qrng_name"

external dimension : t -> int
    = "ml_gsl_qrng_dimension"

external memcpy : src:t -> dst:t -> unit
    = "ml_gsl_qrng_memcpy"

external clone : t -> t
    = "ml_gsl_qrng_clone"
