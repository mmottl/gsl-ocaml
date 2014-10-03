(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2012 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)

(** Random Number Generation *)

type rng_type =
  | BOROSH13
  | COVEYOU
  | CMRG
  | FISHMAN18
  | FISHMAN20
  | FISHMAN2X
  | GFSR4
  | KNUTHRAN
  | KNUTHRAN2
  | KNUTHRAN2002
  | LECUYER21
  | MINSTD
  | MRG
  | MT19937
  | MT19937_1999
  | MT19937_1998
  | R250
  | RAN0
  | RAN1
  | RAN2
  | RAN3
  | RAND
  | RAND48
  | RANDOM128_BSD
  | RANDOM128_GLIBC2
  | RANDOM128_LIBC5
  | RANDOM256_BSD
  | RANDOM256_GLIBC2
  | RANDOM256_LIBC5
  | RANDOM32_BSD
  | RANDOM32_GLIBC2
  | RANDOM32_LIBC5
  | RANDOM64_BSD
  | RANDOM64_GLIBC2
  | RANDOM64_LIBC5
  | RANDOM8_BSD
  | RANDOM8_GLIBC2
  | RANDOM8_LIBC5
  | RANDOM_BSD
  | RANDOM_GLIBC2
  | RANDOM_LIBC5
  | RANDU
  | RANF
  | RANLUX
  | RANLUX389
  | RANLXD1
  | RANLXD2
  | RANLXS0
  | RANLXS1
  | RANLXS2
  | RANMAR
  | SLATEC
  | TAUS
  | TAUS_2
  | TAUS_113
  | TRANSPUTER
  | TT800
  | UNI
  | UNI32
  | VAX
  | WATERMAN14
  | ZUF

type t

(** {3 Default values} *)

external default : unit -> rng_type 
    = "ml_gsl_rng_get_default"
external default_seed : unit -> nativeint 
    = "ml_gsl_rng_get_default_seed"

external set_default : rng_type -> unit
    = "ml_gsl_rng_set_default"
external set_default_seed : nativeint -> unit
    = "ml_gsl_rng_set_default_seed"

external env_setup : unit -> unit 
    = "ml_gsl_rng_env_setup"


(** {3 Creating} *)

val make : rng_type -> t

external set  : t -> nativeint -> unit = "ml_gsl_rng_set"
external name : t -> string = "ml_gsl_rng_name"
external get_type :  t-> rng_type = "ml_gsl_rng_get_type"

(** warning : the nativeint used for seeds are in fact unsigned but
   ocaml treats them as signed.
   But you can still print them using %nu with printf functions. *)

external max : t -> nativeint = "ml_gsl_rng_max"
external min : t -> nativeint = "ml_gsl_rng_min"

external memcpy : t -> t -> unit = "ml_gsl_rng_memcpy"
external clone  : t -> t = "ml_gsl_rng_clone"

external dump_state : t -> string * string = "ml_gsl_rng_dump_state"
external set_state  : t -> string * string -> unit = "ml_gsl_rng_set_state"

(** {3 Sampling} *)

external get : t -> nativeint = "ml_gsl_rng_get"
external uniform : t -> float = "ml_gsl_rng_uniform"
external uniform_pos : t -> float = "ml_gsl_rng_uniform_pos"
external uniform_int : t -> int -> int = "ml_gsl_rng_uniform_int" "noalloc"

(** These function fill the array with random numbers : *)

external uniform_arr     : t -> float array -> unit 
    = "ml_gsl_rng_uniform_arr" "noalloc"
external uniform_pos_arr : t -> float array -> unit 
    = "ml_gsl_rng_uniform_pos_arr" "noalloc"
