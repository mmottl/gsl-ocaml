/* gsl-ocaml - OCaml interface to GSL                        */
/* Copyright (©) 2005 - Olivier Andrieu                     */
/* Distributed under the terms of the LGPL version 2.1      */

#include <caml/fail.h>
#include <caml/memory.h>
#include <caml/callback.h>
#include <caml/bigarray.h>

#include <gsl/gsl_errno.h>
#include <gsl/gsl_wavelet.h>
#include <gsl/gsl_wavelet2d.h>

#include "mlgsl_matrix_double.h"
#include "wrappers.h"

static const gsl_wavelet_type *
gslwavelettype_val (value v)
{
  const gsl_wavelet_type *w_type[] = {
    gsl_wavelet_daubechies,
    gsl_wavelet_daubechies_centered,
    gsl_wavelet_haar,
    gsl_wavelet_haar_centered,
    gsl_wavelet_bspline,
    gsl_wavelet_bspline_centered };
  return w_type [ Int_val (v) ] ;
}

CAMLprim value
ml_gsl_wavelet_alloc (value ty, value k)
{
  value r;
  gsl_wavelet *w;
  w = gsl_wavelet_alloc (gslwavelettype_val (ty), Long_val (k));
  Abstract_ptr (r, w);
  return r;
}

#define Wavelet_val(v) (gsl_wavelet *)Field(v, 0)

ML1 (gsl_wavelet_free, Wavelet_val, Unit)
ML1 (gsl_wavelet_name, Wavelet_val, copy_string)

CAMLprim value
ml_gsl_wavelet_workspace_alloc (value n)
{
  value r;
  gsl_wavelet_workspace *ws;
  ws = gsl_wavelet_workspace_alloc (Long_val (n));
  Abstract_ptr (r, ws);
  return r;
}

#define WS_val(v) (gsl_wavelet_workspace *)Field(v, 0)

CAMLprim value
ml_gsl_wavelet_workspace_size (value ws)
{
  return Val_long ((WS_val (ws))->n);
}

ML1 (gsl_wavelet_workspace_free, WS_val, Unit)

static inline gsl_wavelet_direction
gsl_direction_val (value v)
{
  static const gsl_wavelet_direction conv[] = { 
    gsl_wavelet_forward, 
    gsl_wavelet_backward };
  return conv [ Int_val (v) ];
}

static void
check_array (value vf)
{
  mlsize_t len = Double_array_length (Field (vf, 0));
  size_t off    = Long_val (Field (vf, 1));
  size_t n      = Long_val (Field (vf, 2));
  size_t stride = Long_val (Field (vf, 3));
  if (off + (n - 1) * stride >= len)
    GSL_ERROR_VOID ("Inconsistent array specification", GSL_EBADLEN);
}

CAMLprim value
ml_gsl_wavelet_transform (value w, value dir, value vf, value ws)
{
  double *data  = Double_array_val (Field (vf, 0)) + Long_val (Field (vf, 1));
  size_t n = Long_val (Field (vf, 2));
  size_t stride = Long_val (Field (vf, 3));
  check_array (vf);
  gsl_wavelet_transform (Wavelet_val (w), data, stride, n,
			 gsl_direction_val (dir), WS_val (ws));
  return Val_unit;
}

CAMLprim value
ml_gsl_wavelet_transform_bigarray (value w, value dir, value b, value ws)
{
  struct caml_bigarray *bigarr = Bigarray_val(b);
  double *data  = bigarr->data;
  size_t n      = bigarr->dim[0];
  gsl_wavelet_transform (Wavelet_val (w), data, 1, n,
			 gsl_direction_val (dir), WS_val (ws));
  return Val_unit;
}


/* 2D transforms */
CAMLprim value
ml_gsl_wavelet2d_transform_matrix (value w, value ordering,
				   value dir, value a, value ws)
{
  _DECLARE_MATRIX(a);
  _CONVERT_MATRIX(a);
  if (Int_val (ordering) == 0)
    gsl_wavelet2d_transform_matrix (Wavelet_val (w), &m_a,
				    gsl_direction_val (dir), WS_val (ws));
  else
    gsl_wavelet2d_nstransform_matrix (Wavelet_val (w), &m_a,
				      gsl_direction_val (dir), WS_val (ws));
  return Val_unit;
}
