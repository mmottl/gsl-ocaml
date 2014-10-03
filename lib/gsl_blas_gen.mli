(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2012 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)


type order = Blas.order =
  | RowMajor
  | ColMajor

type transpose = Blas.transpose =
  | NoTrans
  | Trans
  | ConjTrans

type uplo = Blas.uplo =
  | Upper
  | Lower

type diag = Blas.diag =
  | NonUnit
  | Unit

type side = Blas.side =
  | Left
  | Right


open Vectmat


(* LEVEL 1 *)
external dot : [< vec] -> [< vec] -> float = "ml_gsl_blas_ddot"
external nrm2 : [< vec] -> float = "ml_gsl_blas_dnrm2"
external asum : [< vec] -> float = "ml_gsl_blas_dasum"
external iamax : [< vec] -> int = "ml_gsl_blas_idamax"
external swap : [< vec] -> [< vec] -> unit = "ml_gsl_blas_dswap"
external copy : [< vec] -> [< vec] -> unit = "ml_gsl_blas_dcopy"
external axpy : float -> [< vec] -> [< vec] -> unit = "ml_gsl_blas_daxpy"
external rot : [< vec] -> [< vec] -> float -> float -> unit = "ml_gsl_blas_drot"
external scal : float -> [< vec] -> unit = "ml_gsl_blas_dscal"


(* LEVEL 2 *)
external gemv : transpose -> alpha:float -> a:[< mat] -> 
  x:[< vec] -> beta:float -> y:[< vec] -> unit
      = "ml_gsl_blas_dgemv_bc" "ml_gsl_blas_dgemv"
external trmv : uplo -> transpose -> diag -> 
  a:[< mat] -> x:[< vec] -> unit
      = "ml_gsl_blas_dtrmv"
external trsv : uplo -> transpose -> diag -> 
  a:[< mat] -> x:[< vec] -> unit
      = "ml_gsl_blas_dtrsv"
external symv : uplo -> alpha:float -> a:[< mat] -> 
  x:[< vec] -> beta:float -> y:[< vec] -> unit
      = "ml_gsl_blas_dsymv_bc" "ml_gsl_blas_dsymv"
external dger : alpha:float -> x:[< vec] -> 
  y:[< vec] -> a:[< mat] -> unit
      = "ml_gsl_blas_dger"
external syr : uplo -> alpha:float -> x:[< vec] -> 
  a:[< mat] -> unit
      = "ml_gsl_blas_dsyr"
external syr2 : uplo -> alpha:float -> x:[< vec] -> 
  y:[< vec] -> a:[< mat] -> unit
      = "ml_gsl_blas_dsyr2"


(* LEVEL 3 *)
external gemm : ta:transpose -> tb:transpose ->
  alpha:float -> a:[< mat] -> b:[< mat] ->
    beta:float -> c:[< mat] -> unit
	= "ml_gsl_blas_dgemm_bc" "ml_gsl_blas_dgemm"
external symm : side -> uplo ->
  alpha:float -> a:[< mat] -> b:[< mat] ->
    beta:float -> c:[< mat] -> unit
	= "ml_gsl_blas_dsymm_bc" "ml_gsl_blas_dsymm"
external trmm : side -> uplo -> transpose -> diag -> 
  alpha:float -> a:[< mat] -> b:[< mat] -> unit
	= "ml_gsl_blas_dtrmm_bc" "ml_gsl_blas_dtrmm"
external trsm : side -> uplo -> transpose -> diag -> 
  alpha:float -> a:[< mat] -> b:[< mat] -> unit
	= "ml_gsl_blas_dtrsm_bc" "ml_gsl_blas_dtrsm"
external syrk : uplo -> transpose -> 
  alpha:float -> a:[< mat] -> beta:float -> c:[< mat] -> unit
	= "ml_gsl_blas_dsyrk_bc" "ml_gsl_blas_dsyrk"
external syr2k : uplo -> transpose -> 
  alpha:float -> a:[< mat] -> b:[< mat] -> 
    beta:float -> c:[< mat] -> unit
	= "ml_gsl_blas_dsyr2k_bc" "ml_gsl_blas_dsyr2k"



open Gsl_complex

module Complex :
  sig
(* LEVEL 1 *)
  external dotu : [< cvec] -> [< cvec] -> complex = "ml_gsl_blas_zdotu"
  external dotc : [< cvec] -> [< cvec] -> complex = "ml_gsl_blas_zdotc"
  external nrm2 : [< cvec] -> float = "ml_gsl_blas_znrm2"
  external asum : [< cvec] -> float = "ml_gsl_blas_zasum"
  external iamax : [< cvec] -> int = "ml_gsl_blas_izamax"
  external swap : [< cvec] -> [< cvec] -> unit = "ml_gsl_blas_zswap"
  external copy : [< cvec] -> [< cvec] -> unit = "ml_gsl_blas_zcopy"
  external axpy : complex -> [< cvec] -> [< cvec] -> unit = "ml_gsl_blas_zaxpy"
  external scal : complex -> [< cvec] -> unit = "ml_gsl_blas_zscal"
  external zdscal : float -> [< cvec] -> unit = "ml_gsl_blas_zdscal"

(* LEVEL 2 *)
  external gemv : transpose -> alpha:complex -> a:[< cmat] -> 
    x:[< cvec] -> beta:complex -> y:[< cvec] -> unit
	= "ml_gsl_blas_zgemv_bc" "ml_gsl_blas_zgemv"
  external trmv : uplo -> transpose -> diag -> 
    a:[< cmat] -> x:[< cvec] -> unit
	= "ml_gsl_blas_ztrmv"
  external trsv : uplo -> transpose -> diag -> 
    a:[< cmat] -> x:[< cvec] -> unit
	= "ml_gsl_blas_ztrsv"
  external hemv : uplo -> alpha:complex -> a:[< cmat] -> 
    x:[< cvec] -> beta:complex -> y:[< cvec] -> unit
	= "ml_gsl_blas_zhemv_bc" "ml_gsl_blas_zhemv"
  external geru : alpha:complex -> x:[< cvec] -> 
    y:[< cvec] -> a:[< cmat] -> unit
	= "ml_gsl_blas_zgeru"
  external gerc : alpha:complex -> x:[< cvec] -> 
    y:[< cvec] -> a:[< cmat] -> unit
	= "ml_gsl_blas_zgerc"
  external her : uplo -> alpha:float -> 
    x:[< cvec] -> a:[< cmat] -> unit
	= "ml_gsl_blas_zher"
  external her2 : uplo -> alpha:complex -> 
    x:[< cvec] -> y:[< cvec] -> a:[< cmat] -> unit
	= "ml_gsl_blas_zher2"

(* LEVEL 3 *)
  external gemm : ta:transpose -> tb:transpose ->
    alpha:complex -> a:[< cmat] -> b:[< cmat] ->
      beta:complex -> c:[< cmat] -> unit
	  = "ml_gsl_blas_zgemm_bc" "ml_gsl_blas_zgemm"
  external symm : side -> uplo ->
    alpha:complex -> a:[< cmat] -> b:[< cmat] ->
      beta:complex -> c:[< cmat] -> unit
	  = "ml_gsl_blas_zsymm_bc" "ml_gsl_blas_zsymm"
  external syrk : uplo -> transpose -> 
    alpha:complex -> a:[< cmat] -> beta:complex -> c:[< cmat] -> unit
	= "ml_gsl_blas_zsyrk_bc" "ml_gsl_blas_zsyrk"
  external syr2k : uplo -> transpose -> 
    alpha:complex -> a:[< cmat] -> b:[< cmat] -> 
      beta:complex -> c:[< cmat] -> unit
	  = "ml_gsl_blas_zsyr2k_bc" "ml_gsl_blas_zsyr2k"
  external trmm : side -> uplo -> transpose -> diag -> 
    alpha:complex -> a:[< cmat] -> b:[< cmat] -> unit
	= "ml_gsl_blas_ztrmm_bc" "ml_gsl_blas_ztrmm"
  external trsm : side -> uplo -> transpose -> diag -> 
    alpha:complex -> a:[< cmat] -> b:[< cmat] -> unit
	= "ml_gsl_blas_ztrsm_bc" "ml_gsl_blas_ztrsm"
  external hemm : side -> uplo -> alpha:complex -> 
    a:[< cmat] -> b:[< cmat] -> beta:complex -> c:[< cmat] -> unit
	= "ml_gsl_blas_zhemm_bc" "ml_gsl_blas_zhemm"
  external herk : uplo -> transpose -> alpha:float -> 
    a:[< cmat] -> beta:float -> c:[< cmat] -> unit
	= "ml_gsl_blas_zherk_bc" "ml_gsl_blas_zherk"
  external her2k : uplo -> transpose -> alpha:complex -> 
    a:[< cmat] -> b:[< cmat] -> beta:float -> c:[< cmat] -> unit
	= "ml_gsl_blas_zher2k_bc" "ml_gsl_blas_zher2k"
  end
  
