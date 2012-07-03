/* gsl-ocaml - OCaml interface to GSL                       */
/* Copyright (©) 2002-2005 - Olivier Andrieu                */
/* Distributed under the terms of the LGPL version 2.1      */


#include <gsl/gsl_eigen.h>

#include "wrappers.h"
#include "mlgsl_permut.h"
#include "mlgsl_complex.h"

#include "mlgsl_vector_complex.h"
#include "mlgsl_matrix_complex.h"

#undef BASE_TYPE
#undef TYPE
#undef _DECLARE_BASE_TYPE
#undef _CONVERT_BASE_TYPE
#undef DECLARE_BASE_TYPE
#undef FUNCTION

#include "mlgsl_matrix_double.h"
#include "mlgsl_vector_double.h"



CAMLprim value ml_gsl_eigen_symm_alloc(value n)
{
  value v;
  gsl_eigen_symm_workspace *ws = gsl_eigen_symm_alloc(Int_val(n));
  Abstract_ptr(v, ws);
  return v;
}

#define SYMM_WS_val(v) ((gsl_eigen_symm_workspace *)Field(v, 0))

ML1(gsl_eigen_symm_free, SYMM_WS_val, Unit)

CAMLprim value ml_gsl_eigen_symm(value A, value EVAL, value ws)
{
  _DECLARE_MATRIX(A);
  _DECLARE_VECTOR(EVAL);
  _CONVERT_MATRIX(A);
  _CONVERT_VECTOR(EVAL);
  gsl_eigen_symm(&m_A, &v_EVAL, SYMM_WS_val(ws));
  return Val_unit;
}

CAMLprim value ml_gsl_eigen_symmv_alloc(value n)
{
  value v;
  gsl_eigen_symmv_workspace *ws = gsl_eigen_symmv_alloc(Int_val(n));
  Abstract_ptr(v, ws);
  return v;
}

#define SYMMV_WS_val(v) ((gsl_eigen_symmv_workspace *)Field(v, 0))

ML1(gsl_eigen_symmv_free, SYMMV_WS_val, Unit)

CAMLprim value ml_gsl_eigen_symmv(value A, value EVAL, value EVEC, value ws)
{
  _DECLARE_MATRIX2(A, EVEC);
  _DECLARE_VECTOR(EVAL);
  _CONVERT_MATRIX2(A, EVEC);
  _CONVERT_VECTOR(EVAL);
  gsl_eigen_symmv(&m_A, &v_EVAL, &m_EVEC, SYMMV_WS_val(ws));
  return Val_unit;
}

static const gsl_eigen_sort_t eigen_sort_type[] = {
  GSL_EIGEN_SORT_VAL_ASC, GSL_EIGEN_SORT_VAL_DESC,
  GSL_EIGEN_SORT_ABS_ASC, GSL_EIGEN_SORT_ABS_DESC, };

CAMLprim value ml_gsl_eigen_symmv_sort(value E, value sort)
{
  value EVAL = Field(E, 0);
  value EVEC = Field(E, 1);
  _DECLARE_MATRIX(EVEC);
  _DECLARE_VECTOR(EVAL);
  _CONVERT_MATRIX(EVEC);
  _CONVERT_VECTOR(EVAL);
  gsl_eigen_symmv_sort(&v_EVAL, &m_EVEC, eigen_sort_type[ Int_val(sort) ]);
  return Val_unit;
}




/* Hermitian matrices */
CAMLprim value ml_gsl_eigen_herm_alloc(value n)
{
  value v;
  gsl_eigen_herm_workspace *ws = gsl_eigen_herm_alloc(Int_val(n));
  Abstract_ptr(v, ws);
  return v;
}

#define HERM_WS_val(v) ((gsl_eigen_herm_workspace *)Field(v, 0))

ML1(gsl_eigen_herm_free, HERM_WS_val, Unit)

CAMLprim value ml_gsl_eigen_herm(value A, value EVAL, value ws)
{
  _DECLARE_COMPLEX_MATRIX(A);
  _DECLARE_VECTOR(EVAL);
  _CONVERT_COMPLEX_MATRIX(A);
  _CONVERT_VECTOR(EVAL);
  gsl_eigen_herm(&m_A, &v_EVAL, HERM_WS_val(ws));
  return Val_unit;
}

CAMLprim value ml_gsl_eigen_hermv_alloc(value n)
{
  value v;
  gsl_eigen_hermv_workspace *ws = gsl_eigen_hermv_alloc(Int_val(n));
  Abstract_ptr(v, ws);
  return v;
}

#define HERMV_WS_val(v) ((gsl_eigen_hermv_workspace *)Field(v, 0))

ML1(gsl_eigen_hermv_free, HERMV_WS_val, Unit)

CAMLprim value ml_gsl_eigen_hermv(value A, value EVAL, value EVEC, value ws)
{
  _DECLARE_VECTOR(EVAL);
  _DECLARE_COMPLEX_MATRIX2(A, EVEC);
  _CONVERT_VECTOR(EVAL);
  _CONVERT_COMPLEX_MATRIX2(A, EVEC);
  gsl_eigen_hermv(&m_A, &v_EVAL, &m_EVEC, HERMV_WS_val(ws));
  return Val_unit;
}

CAMLprim value ml_gsl_eigen_hermv_sort(value E, value sort)
{
  value EVAL = Field(E, 0);
  value EVEC = Field(E, 1);
  _DECLARE_COMPLEX_MATRIX(EVEC);
  _DECLARE_VECTOR(EVAL);
  _CONVERT_COMPLEX_MATRIX(EVEC);
  _CONVERT_VECTOR(EVAL);
  gsl_eigen_hermv_sort(&v_EVAL, &m_EVEC, eigen_sort_type[ Int_val(sort) ]);
  return Val_unit;
}


/* Real Nonsymmetrix Matrices */
CAMLprim value ml_gsl_eigen_nonsymm_alloc(value n)
{
  value v;
  gsl_eigen_nonsymm_workspace *ws = gsl_eigen_nonsymm_alloc(Int_val(n));
  Abstract_ptr(v, ws);
  return v;
}

#define NONSYMM_WS_val(v) ((gsl_eigen_nonsymm_workspace *)Field(v, 0))

ML1(gsl_eigen_nonsymm_free, NONSYMM_WS_val, Unit)

CAMLprim value ml_gsl_eigen_nonsymm(value A, value EVAL, value ws)
{
  _DECLARE_MATRIX(A);
  _DECLARE_COMPLEX_VECTOR(EVAL);
  _CONVERT_MATRIX(A);
  _CONVERT_COMPLEX_VECTOR(EVAL);
  gsl_eigen_nonsymm(&m_A, &v_EVAL, NONSYMM_WS_val(ws));
  return Val_unit;
}

CAMLprim value ml_gsl_eigen_nonsymm_Z(value A, value EVAL, value Z, value ws)
{
  _DECLARE_MATRIX2(A,Z);
  _DECLARE_COMPLEX_VECTOR(EVAL);
  _CONVERT_MATRIX2(A,Z);
  _CONVERT_COMPLEX_VECTOR(EVAL);
  gsl_eigen_nonsymm_Z(&m_A, &v_EVAL, &m_Z, NONSYMM_WS_val(ws));
  return Val_unit;
}

CAMLprim value ml_gsl_eigen_nonsymmv_alloc(value n)
{
  value v;
  gsl_eigen_nonsymmv_workspace *ws = gsl_eigen_nonsymmv_alloc(Int_val(n));
  Abstract_ptr(v, ws);
  return v;
}

#define NONSYMMV_WS_val(v) ((gsl_eigen_nonsymmv_workspace *)Field(v, 0))

ML1(gsl_eigen_nonsymmv_free, NONSYMMV_WS_val, Unit)

CAMLprim value ml_gsl_eigen_nonsymmv(value A, value EVAL, value EVEC, value ws)
{
  _DECLARE_MATRIX(A);
  _DECLARE_COMPLEX_VECTOR(EVAL);
  _DECLARE_COMPLEX_MATRIX(EVEC);
  _CONVERT_MATRIX(A);
  _CONVERT_COMPLEX_VECTOR(EVAL);
  _CONVERT_COMPLEX_MATRIX(EVEC);
  gsl_eigen_nonsymmv(&m_A, &v_EVAL, &m_EVEC, NONSYMMV_WS_val(ws));
  return Val_unit;
}

CAMLprim value ml_gsl_eigen_nonsymmv_Z(value A, value EVAL, value EVEC, value Z, value ws)
{
  _DECLARE_MATRIX2(A,Z);
  _DECLARE_COMPLEX_VECTOR(EVAL);
  _DECLARE_COMPLEX_MATRIX(EVEC);
  _CONVERT_MATRIX2(A,Z);
  _CONVERT_COMPLEX_VECTOR(EVAL);
  _CONVERT_COMPLEX_MATRIX(EVEC);
  gsl_eigen_nonsymmv_Z(&m_A, &v_EVAL, &m_EVEC, &m_Z, NONSYMMV_WS_val(ws));
  return Val_unit;
}

CAMLprim value ml_gsl_eigen_nonsymmv_sort(value E, value sort)
{
  value EVAL = Field(E, 0);
  value EVEC = Field(E, 1);
  _DECLARE_COMPLEX_VECTOR(EVAL);
  _DECLARE_COMPLEX_MATRIX(EVEC);
  _CONVERT_COMPLEX_VECTOR(EVAL);
  _CONVERT_COMPLEX_MATRIX(EVEC);
  gsl_eigen_nonsymmv_sort(&v_EVAL, &m_EVEC, eigen_sort_type[ Int_val(sort) ]);
  return Val_unit;
}
