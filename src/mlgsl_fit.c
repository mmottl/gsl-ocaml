/* gsl-ocaml - OCaml interface to GSL                       */
/* Copyright (©) 2002-2012 - Olivier Andrieu                */
/* Distributed under the terms of the GPL version 3         */

#include <gsl/gsl_fit.h>
#include <gsl/gsl_multifit.h>

#include <caml/alloc.h>
#include <caml/memory.h>
#include <caml/fail.h>

#include "wrappers.h"
#include "mlgsl_matrix_double.h"
#include "mlgsl_vector_double.h"


CAMLprim value ml_gsl_fit_linear(value wo, value x, value y)
{
  value r;
  size_t N=Double_array_length(x);
  double c0,c1,cov00,cov01,cov11,sumsq;

  if(Double_array_length(y) != N)
    GSL_ERROR("array sizes differ", GSL_EBADLEN);

  if(Is_none(wo))
    gsl_fit_linear(Double_array_val(x), 1, 
		   Double_array_val(y), 1, N,
		   &c0, &c1, &cov00, &cov01, &cov11, &sumsq);
  else {
    value w=Field(wo, 0);
    if(Double_array_length(w) != N)
      GSL_ERROR("array sizes differ", GSL_EBADLEN);
    gsl_fit_wlinear(Double_array_val(x), 1, 
		    Double_array_val(w), 1,
		    Double_array_val(y), 1, N,
		    &c0, &c1, &cov00, &cov01, &cov11, &sumsq);
  }
  r=caml_alloc_small(6 * Double_wosize, Double_array_tag);
  Store_double_field(r, 0, c0);
  Store_double_field(r, 1, c1);
  Store_double_field(r, 2, cov00);
  Store_double_field(r, 3, cov01);
  Store_double_field(r, 4, cov11);
  Store_double_field(r, 5, sumsq);
  return r;
}

CAMLprim value ml_gsl_fit_linear_est(value x, value coeffs)
{
  double y,y_err;
  gsl_fit_linear_est(Double_val(x), 
		     Double_field(coeffs, 0),
		     Double_field(coeffs, 1),
		     Double_field(coeffs, 2),
		     Double_field(coeffs, 3),
		     Double_field(coeffs, 4),
		     &y, &y_err);
  return copy_two_double_arr(y, y_err);
}

CAMLprim value ml_gsl_fit_mul(value wo, value x, value y)
{
  value r;
  size_t N=Double_array_length(x);
  double c1,cov11,sumsq;
  
  if(Double_array_length(y) != N)
    GSL_ERROR("array sizes differ", GSL_EBADLEN);

  if(Is_none(wo))
    gsl_fit_mul(Double_array_val(x), 1, Double_array_val(y), 1, N,
		&c1, &cov11, &sumsq);
  else {
    value w=Field(wo, 0);
    if(Double_array_length(w) != N)
      GSL_ERROR("array sizes differ", GSL_EBADLEN);
    gsl_fit_wmul(Double_array_val(x), 1, 
		 Double_array_val(w), 1,
		 Double_array_val(y), 1, N,
		 &c1, &cov11, &sumsq);
  }
  r=caml_alloc_small(3 * Double_wosize, Double_array_tag);
  Store_double_field(r, 0, c1);
  Store_double_field(r, 1, cov11);
  Store_double_field(r, 2, sumsq);
  return r;
}

CAMLprim value ml_gsl_fit_mul_est(value x, value coeffs)
{
  double y,y_err;
  gsl_fit_mul_est(Double_val(x), 
		  Double_field(coeffs, 0), 
		  Double_field(coeffs, 1),
		  &y, &y_err);
  return copy_two_double_arr(y, y_err);
}



/* MULTIFIT */

CAMLprim value ml_gsl_multifit_linear_alloc(value n, value p)
{
  value r;
  Abstract_ptr(r, gsl_multifit_linear_alloc(Int_val(n), Int_val(p)));
  return r;
}

#define MultifitWS_val(v) ((gsl_multifit_linear_workspace *)(Field((v), 0)))

ML1(gsl_multifit_linear_free, MultifitWS_val, Unit)

CAMLprim value ml_gsl_multifit_linear(value wo, value x, value y, 
				      value c, value cov, value ws)
{
  double chisq;
  _DECLARE_MATRIX2(x,cov);
  _DECLARE_VECTOR2(y,c);
  _CONVERT_MATRIX2(x,cov);
  _CONVERT_VECTOR2(y,c);
  if(Is_none(wo))
    gsl_multifit_linear(&m_x, &v_y, &v_c, &m_cov, 
			&chisq, MultifitWS_val(ws));
  else {
    value w=Field(wo, 0);
    _DECLARE_VECTOR(w);
    _CONVERT_VECTOR(w);
    gsl_multifit_wlinear(&m_x, &v_w, &v_y, &v_c, &m_cov, 
			 &chisq, MultifitWS_val(ws));
  }
  return caml_copy_double(chisq);
}

CAMLprim value ml_gsl_multifit_linear_bc(value *args, int argc)
{
  return ml_gsl_multifit_linear(args[0], args[1], args[2],
				args[3], args[4], args[5]);
}


CAMLprim value ml_gsl_multifit_linear_est (value x, value c, value cov)
{
  double y, y_err;
  _DECLARE_VECTOR2(x, c);
  _DECLARE_MATRIX(cov);
  _CONVERT_VECTOR2(x, c);
  _CONVERT_MATRIX(cov);
  gsl_multifit_linear_est (&v_x, &v_c, &m_cov, &y, &y_err);
  return copy_two_double_arr (y, y_err);
}
