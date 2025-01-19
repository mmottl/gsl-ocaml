/* gsl-ocaml - OCaml interface to GSL                       */
/* Copyright (©) 2002-2012 - Olivier Andrieu                */
/* Distributed under the terms of the GPL version 3         */

static inline CBLAS_ORDER_t CBLAS_ORDER_val(value v) {
  CBLAS_ORDER_t conv[] = {CblasRowMajor, CblasColMajor};
  return conv[Int_val(v)];
}

static inline CBLAS_TRANSPOSE_t CBLAS_TRANS_val(value v) {
  CBLAS_TRANSPOSE_t conv[] = {CblasNoTrans, CblasTrans, CblasConjTrans};
  return conv[Int_val(v)];
}

static inline CBLAS_UPLO_t CBLAS_UPLO_val(value v) {
  CBLAS_UPLO_t conv[] = {CblasUpper, CblasLower};
  return conv[Int_val(v)];
}

static inline CBLAS_DIAG_t CBLAS_DIAG_val(value v) {
  CBLAS_DIAG_t conv[] = {CblasNonUnit, CblasUnit};
  return conv[Int_val(v)];
}

static inline CBLAS_SIDE_t CBLAS_SIDE_val(value v) {
  CBLAS_SIDE_t conv[] = {CblasLeft, CblasRight};
  return conv[Int_val(v)];
}
