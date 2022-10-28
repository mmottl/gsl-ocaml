/* gsl-ocaml - OCaml interface to GSL                       */
/* Copyright (©) 2002-2012 - Olivier Andrieu                */
/* Distributed under the terms of the GPL version 3         */

#include <string.h>

#include <gsl/gsl_math.h>

#include <caml/callback.h>
#include <caml/alloc.h>
#include <caml/fail.h>
#include <caml/memory.h>
#include <caml/bigarray.h>

#include "wrappers.h"
#include "mlgsl_fun.h"


/* CALLBACKS */
double gslfun_callback(double x, void *params)
{
  struct callback_params *p=params;
  value res;
  value v_x = caml_copy_double(x);
  res=callback(p->closure, v_x);
  return Double_val(res);
}

/* FDF CALLBACKS */
double gslfun_callback_indir(double x, void *params)
{
  value res;
  value v_x = caml_copy_double(x);
  value *closure = params;
  res=callback(*closure, v_x);
  return Double_val(res);
}
 
double gslfun_callback_f(double x, void *params)
{
  struct callback_params *p=params;
  value res;
  value v_x=caml_copy_double(x);
  res=callback(Field(p->closure, 0), v_x);
  return Double_val(res);
}

double gslfun_callback_df(double x, void *params)
{
  struct callback_params *p=params;
  value res;
  value v_x=caml_copy_double(x);
  res=callback(Field(p->closure, 1), v_x);
  return Double_val(res);
}

void gslfun_callback_fdf(double x, void *params, 
			 double *f, double *df)
{
  struct callback_params *p=params;
  value res;
  value v_x=caml_copy_double(x);
  res=callback(Field(p->closure, 2), v_x);
  *f =Double_val(Field(res, 0));
  *df=Double_val(Field(res, 1));
}


/* MONTE CALLBACKS */
double gsl_monte_callback(double *x_arr, size_t dim, void *params)
{
  struct callback_params *p=params;
  value res;

  memcpy(Double_array_val(p->dbl), x_arr, dim*sizeof(double));
  res=callback(p->closure, p->dbl);
  return Double_val(res);
}

double gsl_monte_callback_fast(double *x_arr, size_t dim, void *params)
{
  struct callback_params *p=params;
  value res;

  res=callback(p->closure, (value)x_arr);
  return Double_val(res);
}



/* MULTIROOT CALLBACKS */
int gsl_multiroot_callback(const gsl_vector *x, void *params, gsl_vector *F)
{
  int barr_flags = BIGARRAY_FLOAT64 | BIGARRAY_C_LAYOUT;
  struct callback_params *p=params;
  value x_barr, f_barr;
  int len = x->size;
  gsl_vector_view x_v, f_v;

  x_barr = caml_ba_alloc_dims(barr_flags, 1, NULL, len);
  f_barr = caml_ba_alloc_dims(barr_flags, 1, NULL, len);
  x_v = gsl_vector_view_array(Caml_ba_data_val(x_barr), len);
  f_v = gsl_vector_view_array(Caml_ba_data_val(f_barr), len);

  gsl_vector_memcpy(&x_v.vector, x);
  callback2(p->closure, x_barr, f_barr);
  gsl_vector_memcpy(F, &f_v.vector);
  return GSL_SUCCESS;
}

int gsl_multiroot_callback_f(const gsl_vector *x, void *params, gsl_vector *F)
{
  int barr_flags = BIGARRAY_FLOAT64 | BIGARRAY_C_LAYOUT;
  struct callback_params *p=params;
  value x_barr, f_barr;
  int len = x->size;
  gsl_vector_view x_v, f_v;

  x_barr = caml_ba_alloc_dims(barr_flags, 1, NULL, len);
  f_barr = caml_ba_alloc_dims(barr_flags, 1, NULL, len);
  x_v = gsl_vector_view_array(Caml_ba_data_val(x_barr), len);
  f_v = gsl_vector_view_array(Caml_ba_data_val(f_barr), len);

  gsl_vector_memcpy(&x_v.vector, x);
  callback2(Field(p->closure, 0), x_barr, f_barr);
  gsl_vector_memcpy(F, &f_v.vector);
  return GSL_SUCCESS;
}

int gsl_multiroot_callback_df(const gsl_vector *x, void *params, gsl_matrix *J)
{
  int barr_flags = BIGARRAY_FLOAT64 | BIGARRAY_C_LAYOUT;
  struct callback_params *p=params;
  value x_barr, j_barr;
  int len = x->size;
  gsl_vector_view x_v;
  gsl_matrix_view j_v;

  x_barr = caml_ba_alloc_dims(barr_flags, 1, NULL, len);
  j_barr = caml_ba_alloc_dims(barr_flags, 2, NULL, len, len);
  x_v = gsl_vector_view_array(Caml_ba_data_val(x_barr), len);
  j_v = gsl_matrix_view_array(Caml_ba_data_val(j_barr), len, len);

  gsl_vector_memcpy(&x_v.vector, x);
  callback2(Field(p->closure, 1), x_barr, j_barr);
  gsl_matrix_memcpy(J, &j_v.matrix);
  return GSL_SUCCESS;
}

int gsl_multiroot_callback_fdf(const gsl_vector *x, void *params, 
			   gsl_vector *F, gsl_matrix *J)
{
  int barr_flags = BIGARRAY_FLOAT64 | BIGARRAY_C_LAYOUT;
  struct callback_params *p=params;
  value x_barr, f_barr, j_barr;
  int len = x->size;
  gsl_vector_view x_v, f_v;
  gsl_matrix_view j_v;
  
  x_barr = caml_ba_alloc_dims(barr_flags, 1, NULL, len);
  f_barr = caml_ba_alloc_dims(barr_flags, 1, NULL, len);
  j_barr = caml_ba_alloc_dims(barr_flags, 2, NULL, len, len);
  x_v = gsl_vector_view_array(Caml_ba_data_val(x_barr), len);
  f_v = gsl_vector_view_array(Caml_ba_data_val(f_barr), len);
  j_v = gsl_matrix_view_array(Caml_ba_data_val(j_barr), len, len);

  gsl_vector_memcpy(&x_v.vector, x);
  callback3(Field(p->closure, 2), x_barr, f_barr, j_barr);
  gsl_vector_memcpy(F, &f_v.vector);
  gsl_matrix_memcpy(J, &j_v.matrix);
  return GSL_SUCCESS;
}



/* MULTIMIN CALLBACKS */
double gsl_multimin_callback(const gsl_vector *x, void *params)
{
  int barr_flags = BIGARRAY_FLOAT64 | BIGARRAY_C_LAYOUT;
  struct callback_params *p=params;
  value x_barr;
  int len = x->size;
  gsl_vector_view x_v;
  value res;

  x_barr = caml_ba_alloc_dims(barr_flags, 1, NULL, len);
  x_v = gsl_vector_view_array(Caml_ba_data_val(x_barr), len);

  gsl_vector_memcpy(&x_v.vector, x);
  res=callback(p->closure, x_barr);
  return Double_val(res);
}

double gsl_multimin_callback_f(const gsl_vector *x, void *params)
{
  int barr_flags = BIGARRAY_FLOAT64 | BIGARRAY_C_LAYOUT;
  struct callback_params *p=params;
  value x_barr;
  int len = x->size;
  gsl_vector_view x_v;
  value res;

  x_barr = caml_ba_alloc_dims(barr_flags, 1, NULL, len);
  x_v = gsl_vector_view_array(Caml_ba_data_val(x_barr), len);

  gsl_vector_memcpy(&x_v.vector, x);
  res=callback(Field(p->closure, 0), x_barr);
  return Double_val(res);
}

void gsl_multimin_callback_df(const gsl_vector *x, void *params, gsl_vector *G)
{
  int barr_flags = BIGARRAY_FLOAT64 | BIGARRAY_C_LAYOUT;
  struct callback_params *p=params;
  value x_barr, g_barr;
  int len = x->size;
  gsl_vector_view x_v, g_v;

  x_barr = caml_ba_alloc_dims(barr_flags, 1, NULL, len);
  g_barr = caml_ba_alloc_dims(barr_flags, 1, NULL, len);
  x_v = gsl_vector_view_array(Caml_ba_data_val(x_barr), len);
  g_v = gsl_vector_view_array(Caml_ba_data_val(g_barr), len);

  gsl_vector_memcpy(&x_v.vector, x);
  callback2(Field(p->closure, 1), x_barr, g_barr);
  gsl_vector_memcpy(G, &g_v.vector);
}

void gsl_multimin_callback_fdf(const gsl_vector *x, void *params, 
			       double *f, gsl_vector *G)
{
  int barr_flags = BIGARRAY_FLOAT64 | BIGARRAY_C_LAYOUT;
  struct callback_params *p=params;
  value x_barr, g_barr;
  int len = x->size;
  gsl_vector_view x_v, g_v;
  value res;
  
  x_barr = caml_ba_alloc_dims(barr_flags, 1, NULL, len);
  g_barr = caml_ba_alloc_dims(barr_flags, 1, NULL, len);
  x_v = gsl_vector_view_array(Caml_ba_data_val(x_barr), len);
  g_v = gsl_vector_view_array(Caml_ba_data_val(g_barr), len);

  gsl_vector_memcpy(&x_v.vector, x);
  res=callback2(Field(p->closure, 2), x_barr, g_barr);
  gsl_vector_memcpy(G, &g_v.vector);
  *f=Double_val(res);
}



/* MULTIFIT CALLBACKS */
int gsl_multifit_callback_f(const gsl_vector *X, void *params, gsl_vector *F)
{
  int barr_flags = BIGARRAY_FLOAT64 | BIGARRAY_C_LAYOUT;
  struct callback_params *parms=params;
  value x_barr, f_barr;
  size_t p = X->size;
  size_t n = F->size;
  gsl_vector_view x_v, f_v;

  x_barr = caml_ba_alloc_dims(barr_flags, 1, NULL, p);
  f_barr = caml_ba_alloc_dims(barr_flags, 1, NULL, n);
  x_v = gsl_vector_view_array(Caml_ba_data_val(x_barr), p);
  f_v = gsl_vector_view_array(Caml_ba_data_val(f_barr), n);

  gsl_vector_memcpy(&x_v.vector, X);
  callback2(Field(parms->closure, 0), x_barr, f_barr);
  gsl_vector_memcpy(F, &f_v.vector);
  return GSL_SUCCESS;
}

int gsl_multifit_callback_df(const gsl_vector *X, void *params, gsl_matrix *J)
{
  int barr_flags = BIGARRAY_FLOAT64 | BIGARRAY_C_LAYOUT;
  struct callback_params *parms=params;
  value x_barr, j_barr;
  size_t p = X->size;
  size_t n = J->size1;
  gsl_vector_view x_v;
  gsl_matrix_view j_v;
  value res;

  x_barr = caml_ba_alloc_dims(barr_flags, 1, NULL, p);
  j_barr = caml_ba_alloc_dims(barr_flags, 2, NULL, n, p);
  x_v = gsl_vector_view_array(Caml_ba_data_val(x_barr), p);
  j_v = gsl_matrix_view_array(Caml_ba_data_val(j_barr), n, p);

  gsl_vector_memcpy(&x_v.vector, X);
  res=callback2(Field(parms->closure, 1), x_barr, j_barr);
  if(Is_exception_result(res))
    return GSL_FAILURE;
  gsl_matrix_memcpy(J, &j_v.matrix);
  return GSL_SUCCESS;
}

int gsl_multifit_callback_fdf(const gsl_vector *X, void *params, 
			      gsl_vector *F, gsl_matrix *J)
{
  int barr_flags = BIGARRAY_FLOAT64 | BIGARRAY_C_LAYOUT;
  struct callback_params *parms=params;
  value x_barr, f_barr, j_barr;
  size_t p = X->size;
  size_t n = F->size;
  gsl_vector_view x_v, f_v;
  gsl_matrix_view j_v;
  
  x_barr = caml_ba_alloc_dims(barr_flags, 1, NULL, p);
  f_barr = caml_ba_alloc_dims(barr_flags, 1, NULL, n);
  j_barr = caml_ba_alloc_dims(barr_flags, 2, NULL, n, p);
  x_v = gsl_vector_view_array(Caml_ba_data_val(x_barr), p);
  f_v = gsl_vector_view_array(Caml_ba_data_val(f_barr), n);
  j_v = gsl_matrix_view_array(Caml_ba_data_val(j_barr), n, p);

  gsl_vector_memcpy(&x_v.vector, X);
  callback3(Field(parms->closure, 2), x_barr, f_barr, j_barr);
  gsl_vector_memcpy(F, &f_v.vector);
  gsl_matrix_memcpy(J, &j_v.matrix);
  return GSL_SUCCESS;
}
