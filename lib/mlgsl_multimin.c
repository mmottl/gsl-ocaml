/* gsl-ocaml - OCaml interface to GSL                       */
/* Copyright (©) 2002-2005 - Olivier Andrieu                */
/* Distributed under the terms of the GPL version 3         */

#include <gsl/gsl_multimin.h>

#include <caml/alloc.h>
#include <caml/memory.h>
#include <caml/fail.h>
#include <caml/callback.h>

#include "wrappers.h"
#include "mlgsl_fun.h"
#include "mlgsl_vector_double.h"
#include "mlgsl_matrix_double.h"


/* minimizers */
static const gsl_multimin_fdfminimizer_type *fdfminimizer_of_value(value t)
{
  const gsl_multimin_fdfminimizer_type *minimizer_types[] = {
    gsl_multimin_fdfminimizer_conjugate_fr,
    gsl_multimin_fdfminimizer_conjugate_pr,
    gsl_multimin_fdfminimizer_vector_bfgs,
    gsl_multimin_fdfminimizer_vector_bfgs2,
    gsl_multimin_fdfminimizer_steepest_descent, } ;
  return minimizer_types[Int_val(t)];
}

CAMLprim value ml_gsl_multimin_fdfminimizer_alloc(value type, value d)
{
  int dim = Int_val(d);
  struct callback_params *params;
  gsl_multimin_fdfminimizer *T;
  value res;

  T=gsl_multimin_fdfminimizer_alloc(fdfminimizer_of_value(type), dim);
  params=stat_alloc(sizeof(*params));

  res=alloc_small(2, Abstract_tag);
  Field(res, 0) = (value)T;
  Field(res, 1) = (value)params;

  params->gslfun.mmfdf.f   = &gsl_multimin_callback_f;
  params->gslfun.mmfdf.df  = &gsl_multimin_callback_df;
  params->gslfun.mmfdf.fdf = &gsl_multimin_callback_fdf;
  params->gslfun.mmfdf.n   = dim;
  params->gslfun.mmfdf.params = params;
  params->closure = Val_unit;
  params->dbl     = Val_unit;
  register_global_root(&(params->closure));
  return res;
}
#define GSLMULTIMINFDFMINIMIZER_VAL(v) ((gsl_multimin_fdfminimizer *)(Field(v, 0)))
#define CALLBACKPARAMS_VAL(v) ((struct callback_params *)(Field(v, 1)))

CAMLprim value ml_gsl_multimin_fdfminimizer_set(value S, value fun, value X,
				       value step, value tol)
{
  CAMLparam2(S, X);
  struct callback_params *p=CALLBACKPARAMS_VAL(S);
  _DECLARE_VECTOR(X);
  _CONVERT_VECTOR(X);
  p->closure = fun;
  gsl_multimin_fdfminimizer_set(GSLMULTIMINFDFMINIMIZER_VAL(S), 
				&(p->gslfun.mmfdf), &v_X,
				Double_val(step), Double_val(tol));
  CAMLreturn(Val_unit);
}

CAMLprim value ml_gsl_multimin_fdfminimizer_free(value S)
{
  struct callback_params *p=CALLBACKPARAMS_VAL(S);
  remove_global_root(&(p->closure));
  stat_free(p);
  gsl_multimin_fdfminimizer_free(GSLMULTIMINFDFMINIMIZER_VAL(S));
  return Val_unit;
}

ML1(gsl_multimin_fdfminimizer_name, GSLMULTIMINFDFMINIMIZER_VAL, copy_string)
ML1(gsl_multimin_fdfminimizer_iterate, GSLMULTIMINFDFMINIMIZER_VAL, Unit)
ML1(gsl_multimin_fdfminimizer_restart, GSLMULTIMINFDFMINIMIZER_VAL, Unit)

CAMLprim value ml_gsl_multimin_fdfminimizer_minimum(value ox, value odx, value og, value T)
{
  gsl_multimin_fdfminimizer *t=GSLMULTIMINFDFMINIMIZER_VAL(T);
  if(Is_block(ox)) {
      value x=Unoption(ox);
      _DECLARE_VECTOR(x);
      _CONVERT_VECTOR(x);
      gsl_vector_memcpy(&v_x,  
			gsl_multimin_fdfminimizer_x(t));
  }
  if(Is_block(odx)) {
      value dx=Unoption(odx);
      _DECLARE_VECTOR(dx);
      _CONVERT_VECTOR(dx);
      gsl_vector_memcpy(&v_dx,  
			gsl_multimin_fdfminimizer_dx(t));
  }
  if(Is_block(og)) {
      value g=Unoption(og);
      _DECLARE_VECTOR(g);
      _CONVERT_VECTOR(g);
      gsl_vector_memcpy(&v_g,  
			gsl_multimin_fdfminimizer_gradient(t));
  }
  return copy_double(gsl_multimin_fdfminimizer_minimum(t));
}

CAMLprim value ml_gsl_multimin_test_gradient(value S, value epsabs)
{
  int status;
  gsl_vector *g = 
    gsl_multimin_fdfminimizer_gradient(GSLMULTIMINFDFMINIMIZER_VAL(S));
  status = gsl_multimin_test_gradient(g, Double_val(epsabs));
  return Val_negbool(status);
}



static const gsl_multimin_fminimizer_type *fminimizer_of_value(value t)
{
  const gsl_multimin_fminimizer_type *minimizer_types[] = {
    gsl_multimin_fminimizer_nmsimplex, } ;
  return minimizer_types[Int_val(t)];
}

CAMLprim value ml_gsl_multimin_fminimizer_alloc(value type, value d)
{
  size_t dim = Int_val(d);
  struct callback_params *params;
  gsl_multimin_fminimizer *T;
  value res;

  T=gsl_multimin_fminimizer_alloc(fminimizer_of_value(type), dim);
  params=stat_alloc(sizeof(*params));

  res=alloc_small(2, Abstract_tag);
  Field(res, 0) = (value)T;
  Field(res, 1) = (value)params;

  params->gslfun.mmf.f   = &gsl_multimin_callback;
  params->gslfun.mmf.n   = dim;
  params->gslfun.mmf.params = params;
  params->closure = Val_unit;
  params->dbl     = Val_unit;
  register_global_root(&(params->closure));
  return res;
}
#define GSLMULTIMINFMINIMIZER_VAL(v) ((gsl_multimin_fminimizer *)(Field(v, 0)))

CAMLprim value ml_gsl_multimin_fminimizer_set(value S, value fun, 
				     value X, value step_size)
{
  CAMLparam3(S, X, step_size);
  struct callback_params *p=CALLBACKPARAMS_VAL(S);
  _DECLARE_VECTOR2(X,step_size);
  _CONVERT_VECTOR2(X,step_size);
  p->closure = fun;
  gsl_multimin_fminimizer_set(GSLMULTIMINFMINIMIZER_VAL(S), 
			      &(p->gslfun.mmf), &v_X, &v_step_size);
  CAMLreturn(Val_unit);
}

CAMLprim value ml_gsl_multimin_fminimizer_free(value S)
{
  struct callback_params *p=CALLBACKPARAMS_VAL(S);
  remove_global_root(&(p->closure));
  stat_free(p);
  gsl_multimin_fminimizer_free(GSLMULTIMINFMINIMIZER_VAL(S));
  return Val_unit;
}

ML1(gsl_multimin_fminimizer_name, GSLMULTIMINFMINIMIZER_VAL, copy_string)
ML1(gsl_multimin_fminimizer_iterate, GSLMULTIMINFMINIMIZER_VAL, Unit)

CAMLprim value ml_gsl_multimin_fminimizer_minimum(value ox, value T)
{
  gsl_multimin_fminimizer *t=GSLMULTIMINFMINIMIZER_VAL(T);
  if(Is_block(ox)) {
      value x=Unoption(ox);
      _DECLARE_VECTOR(x);
      _CONVERT_VECTOR(x);
      gsl_vector_memcpy(&v_x, gsl_multimin_fminimizer_x(t));
  }
  return copy_double(gsl_multimin_fminimizer_minimum(t));
}

ML1(gsl_multimin_fminimizer_size, GSLMULTIMINFMINIMIZER_VAL, copy_double)

CAMLprim value ml_gsl_multimin_test_size(value S, value epsabs)
{
  int status;
  double size = 
    gsl_multimin_fminimizer_size(GSLMULTIMINFMINIMIZER_VAL(S));
  status = gsl_multimin_test_size(size, Double_val(epsabs));
  return Val_negbool(status);
}
