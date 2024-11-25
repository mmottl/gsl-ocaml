/* gsl-ocaml - OCaml interface to GSL                       */
/* Copyright (©) 2007 - Olivier Andrieu                     */
/* Distributed under the terms of the GPL version 3         */

#include <gsl/gsl_bspline.h>

#include <caml/fail.h>
#include <caml/mlvalues.h>

#include "wrappers.h"

CAMLprim value ml_gsl_bspline_alloc(value k, value nbreak) {
  value r;
  gsl_bspline_workspace *w = gsl_bspline_alloc(Long_val(k), Long_val(nbreak));
  Abstract_ptr(r, w);
  return r;
}

#define Bspline_val(v) ((gsl_bspline_workspace *)(Field((v), 0)))

ML1(gsl_bspline_free, Bspline_val, Unit)
ML1(gsl_bspline_ncoeffs, Bspline_val, Val_long)

#include "mlgsl_vector_double.h"

CAMLprim value ml_gsl_bspline_knots(value b, value w) {
  _DECLARE_VECTOR(b);
  _CONVERT_VECTOR(b);
  gsl_bspline_knots(&v_b, Bspline_val(w));
  return Val_unit;
}

ML3(gsl_bspline_knots_uniform, Double_val, Double_val, Bspline_val, Unit)

CAMLprim value ml_gsl_bspline_eval(value x, value B, value w) {
  _DECLARE_VECTOR(B);
  _CONVERT_VECTOR(B);
  gsl_bspline_eval(Double_val(x), &v_B, Bspline_val(w));
  return Val_unit;
}
