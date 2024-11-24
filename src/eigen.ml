(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2012 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)

open Vectmat

let () = Error.init ()

type symm_ws

external _symm_alloc : int -> symm_ws = "ml_gsl_eigen_symm_alloc"
external _symm_free : symm_ws -> unit = "ml_gsl_eigen_symm_free"

let make_symm_ws s =
  let ws = _symm_alloc s in
  Gc.finalise _symm_free ws;
  ws

external _symm : mat -> vec -> symm_ws -> unit = "ml_gsl_eigen_symm"

let symm ?protect a =
  let a' = Vectmat.mat_convert ?protect a in
  let n, _ = Vectmat.dims a' in
  let v = Vector.create n in
  let ws = _symm_alloc n in
  (try _symm a' (`V v) ws
   with exn ->
     _symm_free ws;
     raise exn);
  _symm_free ws;
  v

type symmv_ws

external _symmv_alloc_v : int -> symmv_ws = "ml_gsl_eigen_symmv_alloc"
external _symmv_free_v : symmv_ws -> unit = "ml_gsl_eigen_symmv_free"

let make_symmv_ws s =
  let ws = _symmv_alloc_v s in
  Gc.finalise _symmv_free_v ws;
  ws

external _symmv : mat -> vec -> mat -> symmv_ws -> unit = "ml_gsl_eigen_symmv"

let symmv ?protect a =
  let a' = Vectmat.mat_convert ?protect a in
  let n, _ = Vectmat.dims a' in
  let v = Vector.create n in
  let evec = Matrix.create n n in
  let ws = _symmv_alloc_v n in
  (try _symmv a' (`V v) (`M evec) ws
   with exn ->
     _symmv_free_v ws;
     raise exn);
  _symmv_free_v ws;
  (v, evec)

type sort = VAL_ASC | VAL_DESC | ABS_ASC | ABS_DESC

external symmv_sort : Vector.vector * Matrix.matrix -> sort -> unit
  = "ml_gsl_eigen_symmv_sort"

(* Complex Hermitian Matrices *)

type herm_ws

external _herm_alloc : int -> herm_ws = "ml_gsl_eigen_herm_alloc"
external _herm_free : herm_ws -> unit = "ml_gsl_eigen_herm_free"

let make_herm_ws s =
  let ws = _herm_alloc s in
  Gc.finalise _herm_free ws;
  ws

external _herm : cmat -> vec -> herm_ws -> unit = "ml_gsl_eigen_herm"

let herm ?protect a =
  let a' = Vectmat.cmat_convert ?protect a in
  let n, _ = Vectmat.dims a' in
  let v = Vector.create n in
  let ws = _herm_alloc n in
  (try _herm a' (`V v) ws
   with exn ->
     _herm_free ws;
     raise exn);
  _herm_free ws;
  v

type hermv_ws

external _hermv_alloc_v : int -> hermv_ws = "ml_gsl_eigen_hermv_alloc"
external _hermv_free_v : hermv_ws -> unit = "ml_gsl_eigen_hermv_free"

let make_hermv_ws s =
  let ws = _hermv_alloc_v s in
  Gc.finalise _hermv_free_v ws;
  ws

external _hermv : cmat -> vec -> cmat -> hermv_ws -> unit = "ml_gsl_eigen_hermv"

let hermv ?protect a =
  let a' = Vectmat.cmat_convert ?protect a in
  let n, _ = Vectmat.dims a' in
  let v = Vector.create n in
  let evec = Matrix_complex.create n n in
  let ws = _hermv_alloc_v n in
  (try _hermv a' (`V v) (`CM evec) ws
   with exn ->
     _hermv_free_v ws;
     raise exn);
  _hermv_free_v ws;
  (v, evec)

external hermv_sort : Vector.vector * Matrix_complex.matrix -> sort -> unit
  = "ml_gsl_eigen_hermv_sort"

type nonsymm_ws
(** Real Nonsymmetric Matrices *)

external _nonsymm_alloc : int -> nonsymm_ws = "ml_gsl_eigen_nonsymm_alloc"
external _nonsymm_free : nonsymm_ws -> unit = "ml_gsl_eigen_nonsymm_free"

let make_nonsymm_ws s =
  let ws = _nonsymm_alloc s in
  Gc.finalise _nonsymm_free ws;
  ws

external _nonsymm : mat -> cvec -> nonsymm_ws -> unit = "ml_gsl_eigen_nonsymm"

external _nonsymm_Z : mat -> cvec -> mat -> nonsymm_ws -> unit
  = "ml_gsl_eigen_nonsymm_Z"

let nonsymm ?protect a =
  let a' = Vectmat.mat_convert ?protect a in
  let n, _ = Vectmat.dims a' in
  let v = Vector_complex.create n in
  let ws = _nonsymm_alloc n in
  (try _nonsymm a' (`CV v) ws
   with exn ->
     _nonsymm_free ws;
     raise exn);
  _nonsymm_free ws;
  v

type nonsymmv_ws

external _nonsymmv_alloc_v : int -> nonsymmv_ws = "ml_gsl_eigen_nonsymmv_alloc"
external _nonsymmv_free_v : nonsymmv_ws -> unit = "ml_gsl_eigen_nonsymmv_free"

let make_nonsymmv_ws s =
  let ws = _nonsymmv_alloc_v s in
  Gc.finalise _nonsymmv_free_v ws;
  ws

external _nonsymmv : mat -> cvec -> cmat -> nonsymmv_ws -> unit
  = "ml_gsl_eigen_nonsymmv"

external _nonsymmv_Z : mat -> cvec -> cmat -> mat -> nonsymmv_ws -> unit
  = "ml_gsl_eigen_nonsymmv_Z"

let nonsymmv ?protect a =
  let a' = Vectmat.mat_convert ?protect a in
  let n, _ = Vectmat.dims a' in
  let v = Vector_complex.create n in
  let evec = Matrix_complex.create n n in
  let ws = _nonsymmv_alloc_v n in
  (try _nonsymmv a' (`CV v) (`CM evec) ws
   with exn ->
     _nonsymmv_free_v ws;
     raise exn);
  _nonsymmv_free_v ws;
  (v, evec)

external nonsymmv_sort :
  Vector_complex.vector * Matrix_complex.matrix -> sort -> unit
  = "ml_gsl_eigen_nonsymmv_sort"
