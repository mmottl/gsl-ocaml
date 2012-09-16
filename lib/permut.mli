(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2012 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)

(** Permutations *)

type permut = 
    (int, Bigarray.int_elt, Bigarray.c_layout) Bigarray.Array1.t

val of_array : int array -> permut
val to_array : permut -> int array

val init   : permut -> unit
val create : int -> permut
val make   : int -> permut

val swap : permut -> int -> int -> unit
val size : permut -> int

val valid : permut -> bool

external reverse : permut -> unit
    = "ml_gsl_permutation_reverse"
val inverse : permut -> permut

external next : permut -> unit = "ml_gsl_permutation_next"
external prev : permut -> unit = "ml_gsl_permutation_prev"

external permute : permut -> 'a array -> unit
    = "ml_gsl_permute"
external permute_barr : permut -> ('a, 'b, 'c) Bigarray.Array1.t -> unit
    = "ml_gsl_permute_barr"
external permute_complex : permut -> Gsl_complex.complex_array -> unit
    = "ml_gsl_permute_complex"

external permute_inverse : permut -> 'a array -> unit
    = "ml_gsl_permute_inverse"
external permute_inverse_barr : permut -> 
  ('a, 'b, 'c) Bigarray.Array1.t -> unit
    = "ml_gsl_permute_inverse_barr"
external permute_inverse_complex : permut -> Gsl_complex.complex_array -> unit
    = "ml_gsl_permute_inverse_complex"

val mul : permut -> permut -> permut

val linear_to_canonical : permut -> permut
val canonical_to_linear : permut -> permut
external inversions : permut -> int = "ml_gsl_permute_inversions"
external canonical_cycles : permut -> int = "ml_gsl_permute_canonical_cycles"
external linear_cycles : permut -> int = "ml_gsl_permute_linear_cycles"
