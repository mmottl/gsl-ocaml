(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2012 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)

(** Simple linear algebra operations *)

open Vectmat
open Gsl_complex

(** {3 Simple matrix multiplication} *)

external matmult :
  a:mat -> ?transpa:bool -> b:mat -> ?transpb:bool -> mat -> unit
  = "ml_gsl_linalg_matmult_mod"
(** [matmult a ~transpa b ~transpb c] stores in matrix [c] the product of
    matrices [a] and [b]. [transpa] or [transpb] allow transposition of either
    matrix, so it can compute a.b or Trans(a).b or a.Trans(b) or
    Trans(a).Trans(b) .

    See also {!Gsl.Blas.gemm}. *)

(** {3 LU decomposition} *)

(** {4 Low-level functions} *)

external _LU_decomp : mat -> Permut.permut -> int = "ml_gsl_linalg_LU_decomp"

external _LU_solve : mat -> Permut.permut -> b:vec -> x:vec -> unit
  = "ml_gsl_linalg_LU_solve"

external _LU_svx : mat -> Permut.permut -> vec -> unit = "ml_gsl_linalg_LU_svx"

external _LU_refine :
  a:mat -> lu:mat -> Permut.permut -> b:vec -> x:vec -> res:vec -> unit
  = "ml_gsl_linalg_LU_refine_bc" "ml_gsl_linalg_LU_refine"

external _LU_invert : mat -> Permut.permut -> mat -> unit
  = "ml_gsl_linalg_LU_invert"

external _LU_det : mat -> int -> float = "ml_gsl_linalg_LU_det"
external _LU_lndet : mat -> float = "ml_gsl_linalg_LU_lndet"
external _LU_sgndet : mat -> int -> int = "ml_gsl_linalg_LU_sgndet"

(** {4 Higher-level functions} *)

(** With these, the arguments are protected (copied) and necessary intermediate
    datastructures are allocated; *)

val decomp_LU :
  ?protect:bool ->
  [< `M of Matrix.matrix
  | `MF of Matrix_flat.matrix
  | `A of float array * int * int
  | `AA of float array array ] ->
  mat * Permut.permut * int

val solve_LU :
  ?protect:bool ->
  [< `M of Matrix.matrix
  | `MF of Matrix_flat.matrix
  | `A of float array * int * int
  | `AA of float array array ] ->
  [< `A of float array | `VF of Vector_flat.vector | `V of Vector.vector ] ->
  float array

val det_LU :
  ?protect:bool ->
  [< `M of Matrix.matrix
  | `MF of Matrix_flat.matrix
  | `A of float array * int * int
  | `AA of float array array ] ->
  float

val invert_LU :
  ?protect:bool ->
  ?result:mat ->
  [< `M of Matrix.matrix
  | `MF of Matrix_flat.matrix
  | `A of float array * int * int
  | `AA of float array array ] ->
  mat

(** {3 Complex LU decomposition} *)

external complex_LU_decomp : cmat -> Permut.permut -> int
  = "ml_gsl_linalg_complex_LU_decomp"

external complex_LU_solve : cmat -> Permut.permut -> b:cvec -> x:cvec -> unit
  = "ml_gsl_linalg_complex_LU_solve"

external complex_LU_svx : cmat -> Permut.permut -> cvec -> unit
  = "ml_gsl_linalg_complex_LU_svx"

external complex_LU_refine :
  a:cmat -> lu:cmat -> Permut.permut -> b:cvec -> x:cvec -> res:cvec -> unit
  = "ml_gsl_linalg_complex_LU_refine_bc" "ml_gsl_linalg_complex_LU_refine"

external complex_LU_invert : cmat -> Permut.permut -> cmat -> unit
  = "ml_gsl_linalg_complex_LU_invert"

external complex_LU_det : cmat -> int -> complex
  = "ml_gsl_linalg_complex_LU_det"

external complex_LU_lndet : cmat -> float = "ml_gsl_linalg_complex_LU_lndet"

external complex_LU_sgndet : cmat -> int -> complex
  = "ml_gsl_linalg_complex_LU_sgndet"

(** {3 QR decomposition} *)

external _QR_decomp : mat -> vec -> unit = "ml_gsl_linalg_QR_decomp"

external _QR_solve : mat -> vec -> b:vec -> x:vec -> unit
  = "ml_gsl_linalg_QR_solve"

external _QR_svx : mat -> vec -> x:vec -> unit = "ml_gsl_linalg_QR_svx"

external _QR_lssolve : mat -> vec -> b:vec -> x:vec -> res:vec -> unit
  = "ml_gsl_linalg_QR_lssolve"

external _QR_QTvec : mat -> vec -> v:vec -> unit = "ml_gsl_linalg_QR_QTvec"
external _QR_Qvec : mat -> vec -> v:vec -> unit = "ml_gsl_linalg_QR_Qvec"
external _QR_Rsolve : mat -> b:vec -> x:vec -> unit = "ml_gsl_linalg_QR_Rsolve"
external _QR_Rsvx : mat -> x:vec -> unit = "ml_gsl_linalg_QR_Rsvx"

external _QR_unpack : mat -> tau:vec -> q:mat -> r:mat -> unit
  = "ml_gsl_linalg_QR_unpack"

external _QR_QRsolve : mat -> r:mat -> b:vec -> x:vec -> unit
  = "ml_gsl_linalg_QR_QRsolve"

external _QR_update : mat -> r:mat -> w:vec -> v:vec -> unit
  = "ml_gsl_linalg_QR_update"

external _R_solve : r:mat -> b:vec -> x:vec -> unit = "ml_gsl_linalg_R_solve"

(* external _R_svx : r:mat -> x:vec -> unit*)
(*     = "ml_gsl_linalg_R_svx"*)

(** {3 QR Decomposition with Column Pivoting} *)

external _QRPT_decomp : a:mat -> tau:vec -> p:Permut.permut -> norm:vec -> int
  = "ml_gsl_linalg_QRPT_decomp"

external _QRPT_decomp2 :
  a:mat -> q:mat -> r:mat -> tau:vec -> p:Permut.permut -> norm:vec -> int
  = "ml_gsl_linalg_QRPT_decomp2_bc" "ml_gsl_linalg_QRPT_decomp2"

external _QRPT_solve :
  qr:mat -> tau:vec -> p:Permut.permut -> b:vec -> x:vec -> unit
  = "ml_gsl_linalg_QRPT_solve"

external _QRPT_svx : qr:mat -> tau:vec -> p:Permut.permut -> x:vec -> unit
  = "ml_gsl_linalg_QRPT_svx"

external _QRPT_QRsolve :
  q:mat -> r:mat -> p:Permut.permut -> b:vec -> x:vec -> unit
  = "ml_gsl_linalg_QRPT_QRsolve"

external _QRPT_update :
  q:mat -> r:mat -> p:Permut.permut -> u:vec -> v:vec -> unit
  = "ml_gsl_linalg_QRPT_update"

external _QRPT_Rsolve : qr:mat -> p:Permut.permut -> b:vec -> x:vec -> unit
  = "ml_gsl_linalg_QRPT_Rsolve"

external _QRPT_Rsvx : qr:mat -> p:Permut.permut -> x:vec -> unit
  = "ml_gsl_linalg_QRPT_Rsolve"

(** {3 Singular Value Decomposition} *)

external _SV_decomp : a:mat -> v:mat -> s:vec -> work:vec -> unit
  = "ml_gsl_linalg_SV_decomp"

external _SV_decomp_mod : a:mat -> x:mat -> v:mat -> s:vec -> work:vec -> unit
  = "ml_gsl_linalg_SV_decomp_mod"

external _SV_decomp_jacobi : a:mat -> v:mat -> s:vec -> unit
  = "ml_gsl_linalg_SV_decomp_jacobi"

external _SV_solve : u:mat -> v:mat -> s:vec -> b:vec -> x:vec -> unit
  = "ml_gsl_linalg_SV_solve"

(** {3 LQ decomposition} *)

external _LQ_decomp : a:mat -> tau:vec -> unit = "ml_gsl_linalg_LQ_decomp"

external _LQ_solve_T : lq:mat -> tau:vec -> b:vec -> x:vec -> unit
  = "ml_gsl_linalg_LQ_solve_T"

external _LQ_svx_T : lq:mat -> tau:vec -> x:vec -> unit
  = "ml_gsl_linalg_LQ_svx_T"

external _LQ_lssolve_T : lq:mat -> tau:vec -> b:vec -> x:vec -> res:vec -> unit
  = "ml_gsl_linalg_LQ_lssolve_T"

external _LQ_Lsolve_T : lq:mat -> b:vec -> x:vec -> unit
  = "ml_gsl_linalg_LQ_Lsolve_T"

external _LQ_Lsvx_T : lq:mat -> x:vec -> unit = "ml_gsl_linalg_LQ_Lsvx_T"

external _L_solve_T : l:mat -> b:vec -> x:vec -> unit
  = "ml_gsl_linalg_L_solve_T"

external _LQ_vecQ : lq:mat -> tau:vec -> v:vec -> unit = "ml_gsl_linalg_LQ_vecQ"

external _LQ_vecQT : lq:mat -> tau:vec -> v:vec -> unit
  = "ml_gsl_linalg_LQ_vecQT"

external _LQ_unpack : lq:mat -> tau:vec -> q:mat -> l:mat -> unit
  = "ml_gsl_linalg_LQ_unpack"

external _LQ_update : q:mat -> r:mat -> v:vec -> w:vec -> unit
  = "ml_gsl_linalg_LQ_update"

external _LQ_LQsolve : q:mat -> l:mat -> b:vec -> x:vec -> unit
  = "ml_gsl_linalg_LQ_LQsolve"

(** {3 P^T L Q decomposition} *)

external _PTLQ_decomp : a:mat -> tau:vec -> Permut.permut -> norm:vec -> int
  = "ml_gsl_linalg_PTLQ_decomp"

external _PTLQ_decomp2 :
  a:mat -> q:mat -> r:mat -> tau:vec -> Permut.permut -> norm:vec -> int
  = "ml_gsl_linalg_PTLQ_decomp2_bc" "ml_gsl_linalg_PTLQ_decomp2"

external _PTLQ_solve_T :
  qr:mat -> tau:vec -> Permut.permut -> b:vec -> x:vec -> unit
  = "ml_gsl_linalg_PTLQ_solve_T"

external _PTLQ_svx_T : lq:mat -> tau:vec -> Permut.permut -> x:vec -> unit
  = "ml_gsl_linalg_PTLQ_svx_T"

external _PTLQ_LQsolve_T :
  q:mat -> l:mat -> Permut.permut -> b:vec -> x:vec -> unit
  = "ml_gsl_linalg_PTLQ_LQsolve_T"

external _PTLQ_Lsolve_T : lq:mat -> Permut.permut -> b:vec -> x:vec -> unit
  = "ml_gsl_linalg_PTLQ_Lsolve_T"

external _PTLQ_Lsvx_T : lq:mat -> Permut.permut -> x:vec -> unit
  = "ml_gsl_linalg_PTLQ_Lsvx_T"

external _PTLQ_update :
  q:mat -> l:mat -> Permut.permut -> v:vec -> w:vec -> unit
  = "ml_gsl_linalg_PTLQ_update"

(** {3 Cholesky decomposition} *)

external cho_decomp : mat -> unit = "ml_gsl_linalg_cholesky_decomp"

external cho_solve : mat -> b:vec -> x:vec -> unit
  = "ml_gsl_linalg_cholesky_solve"

external cho_svx : mat -> vec -> unit = "ml_gsl_linalg_cholesky_svx"

external cho_decomp_unit : mat -> vec -> unit
  = "ml_gsl_linalg_cholesky_decomp_unit"

(** {3 Tridiagonal Decomposition of Real Symmetric Matrices} *)

external symmtd_decomp : a:mat -> tau:vec -> unit
  = "ml_gsl_linalg_symmtd_decomp"

external symmtd_unpack :
  a:mat -> tau:vec -> q:mat -> diag:vec -> subdiag:vec -> unit
  = "ml_gsl_linalg_symmtd_unpack"

external symmtd_unpack_T : a:mat -> diag:vec -> subdiag:vec -> unit
  = "ml_gsl_linalg_symmtd_unpack_T"

(** {3 Tridiagonal Decomposition of Hermitian Matrices} *)

external hermtd_decomp : a:cmat -> tau:cvec -> unit
  = "ml_gsl_linalg_hermtd_decomp"

external hermtd_unpack :
  a:cmat -> tau:cvec -> q:cmat -> diag:vec -> subdiag:vec -> unit
  = "ml_gsl_linalg_hermtd_unpack"

external hermtd_unpack_T : a:cmat -> diag:vec -> subdiag:vec -> unit
  = "ml_gsl_linalg_hermtd_unpack_T"

(** {3 Bidiagonalization} *)

external bidiag_decomp : a:mat -> tau_u:vec -> tau_v:vec -> unit
  = "ml_gsl_linalg_bidiag_decomp"

external bidiag_unpack :
  a:mat ->
  tau_u:vec ->
  u:mat ->
  tau_v:vec ->
  v:mat ->
  diag:vec ->
  superdiag:vec ->
  unit = "ml_gsl_linalg_bidiag_unpack_bc" "ml_gsl_linalg_bidiag_unpack"

external bidiag_unpack2 : a:mat -> tau_u:vec -> tau_v:vec -> v:mat -> unit
  = "ml_gsl_linalg_bidiag_unpack2"

external bidiag_unpack_B : a:mat -> diag:vec -> superdiag:vec -> unit
  = "ml_gsl_linalg_bidiag_unpack_B"

(** {3 Householder solver} *)

external _HH_solve : mat -> b:vec -> x:vec -> unit = "ml_gsl_linalg_HH_solve"
external _HH_svx : mat -> vec -> unit = "ml_gsl_linalg_HH_svx"

val solve_HH :
  ?protect:bool ->
  [< `M of Matrix.matrix
  | `MF of Matrix_flat.matrix
  | `A of float array * int * int
  | `AA of float array array ] ->
  [< `A of float array | `VF of Vector_flat.vector | `V of Vector.vector ] ->
  float array

(** {3 Tridiagonal Systems} *)

external solve_symm_tridiag : diag:vec -> offdiag:vec -> b:vec -> x:vec -> unit
  = "ml_gsl_linalg_solve_symm_tridiag"

external solve_tridiag :
  diag:vec -> abovediag:vec -> belowdiag:vec -> b:vec -> x:vec -> unit
  = "ml_gsl_linalg_solve_tridiag"

external solve_symm_cyc_tridiag :
  diag:vec -> offdiag:vec -> b:vec -> x:vec -> unit
  = "ml_gsl_linalg_solve_symm_cyc_tridiag"

external solve_cyc_tridiag :
  diag:vec -> abovediag:vec -> belowdiag:vec -> b:vec -> x:vec -> unit
  = "ml_gsl_linalg_solve_cyc_tridiag"

(** {3 Exponential} *)

external _exponential : mat -> mat -> Fun.mode -> unit
  = "ml_gsl_linalg_exponential_ss"

val exponential :
  ?mode:Fun.mode ->
  [< `M of Matrix.matrix
  | `MF of Matrix_flat.matrix
  | `A of float array * int * int ] ->
  [ `M of Matrix.matrix ]
