(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2012 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)

(** Eigensystems *)

open Vectmat

(** {3 Real Symmetric Matrices} *)

type symm_ws
val make_symm_ws : int -> symm_ws

external _symm : mat -> vec -> symm_ws -> unit
    = "ml_gsl_eigen_symm"

val symm : 
  ?protect:bool ->
  [< `M of Matrix.matrix
   | `MF of Matrix_flat.matrix
   | `A of float array * int * int
   | `AA of float array array] ->
  Vector.vector

type symmv_ws
val make_symmv_ws : int -> symmv_ws

external _symmv : mat -> vec -> mat -> symmv_ws -> unit
    = "ml_gsl_eigen_symmv"

val symmv : 
  ?protect:bool ->
  [< `M of Matrix.matrix
   | `MF of Matrix_flat.matrix
   | `A of float array * int * int
   | `AA of float array array] ->
  Vector.vector * Matrix.matrix


type sort =
  | VAL_ASC
  | VAL_DESC
  | ABS_ASC
  | ABS_DESC

external symmv_sort : Vector.vector * Matrix.matrix -> sort -> unit
    = "ml_gsl_eigen_symmv_sort"


(** {3 Complex Hermitian Matrices} *)

type herm_ws
val make_herm_ws : int -> herm_ws

external _herm : cmat -> vec -> herm_ws -> unit
    = "ml_gsl_eigen_herm"

val herm : 
  ?protect:bool ->
  [< `CM of Matrix_complex.matrix
   | `CMF of Matrix_complex_flat.matrix
   | `CA of Gsl_complex.complex_array * int * int ] -> 
  Vector.vector

type hermv_ws
val make_hermv_ws : int -> hermv_ws

external _hermv : cmat -> vec -> cmat -> hermv_ws -> unit
    = "ml_gsl_eigen_hermv"

val hermv : 
  ?protect:bool ->
  [< `CM of Matrix_complex.matrix
   | `CMF of Matrix_complex_flat.matrix
   | `CA of Gsl_complex.complex_array * int * int ] -> 
  Vector.vector * Matrix_complex.matrix

external hermv_sort : 
  Vector.vector * Matrix_complex.matrix -> 
    sort -> unit
    = "ml_gsl_eigen_hermv_sort"


(** {3 Real Nonsymmetric Matrices} *)

type nonsymm_ws
val make_nonsymm_ws : int -> nonsymm_ws

external _nonsymm : mat -> cvec -> nonsymm_ws -> unit
    = "ml_gsl_eigen_nonsymm"
external _nonsymm_Z : mat -> cvec -> mat -> nonsymm_ws -> unit
    = "ml_gsl_eigen_nonsymm_Z"

val nonsymm : 
  ?protect:bool ->
  [< `M of Matrix.matrix
   | `MF of Matrix_flat.matrix
   | `A of float array * int * int
   | `AA of float array array] ->
  Vector_complex.vector

type nonsymmv_ws
val make_nonsymmv_ws : int -> nonsymmv_ws

external _nonsymmv : mat -> cvec -> cmat -> nonsymmv_ws -> unit
    = "ml_gsl_eigen_nonsymmv"
external _nonsymmv_Z : mat -> cvec -> cmat -> mat -> nonsymmv_ws -> unit
    = "ml_gsl_eigen_nonsymmv_Z"

val nonsymmv : 
  ?protect:bool ->
  [< `M of Matrix.matrix
   | `MF of Matrix_flat.matrix
   | `A of float array * int * int
   | `AA of float array array] ->
  Vector_complex.vector * Matrix_complex.matrix


external nonsymmv_sort : Vector_complex.vector * Matrix_complex.matrix -> sort -> unit
    = "ml_gsl_eigen_nonsymmv_sort"
