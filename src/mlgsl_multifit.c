/* gsl-ocaml - OCaml interface to GSL                       */
/* Copyright (©) 2002-2012 - Olivier Andrieu                */
/* Distributed under the terms of the GPL version 3         */


#include <gsl/gsl_multifit_nlin.h>

#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/fail.h>

#include "wrappers.h"
#include "mlgsl_fun.h"
#include "mlgsl_vector_double.h"
#include "mlgsl_matrix_double.h"

/* solvers */
static const gsl_multifit_fdfsolver_type *fdfsolver_of_value(value t)
{
  const gsl_multifit_fdfsolver_type *solver_types[] = {
    gsl_multifit_fdfsolver_lmsder,
    gsl_multifit_fdfsolver_lmder, } ;
  return solver_types[Int_val(t)];
}

CAMLprim value ml_gsl_multifit_fdfsolver_alloc(value type, value n, value p)
{
  gsl_multifit_fdfsolver *S;
  struct callback_params *params;
  value res;

  S=gsl_multifit_fdfsolver_alloc(fdfsolver_of_value(type), 
				 Int_val(n), Int_val(p));
  params=stat_alloc(sizeof(*params));

  res=caml_alloc_small(2, Abstract_tag);
  Field(res, 0) = (value)S;
  Field(res, 1) = (value)params;

  params->gslfun.mffdf.f   = &gsl_multifit_callback_f;  
  params->gslfun.mffdf.df  = &gsl_multifit_callback_df; 
  params->gslfun.mffdf.fdf = &gsl_multifit_callback_fdf;
  params->gslfun.mffdf.n   = Int_val(n);
  params->gslfun.mffdf.p   = Int_val(p);
  params->gslfun.mffdf.params = params;
  params->closure = Val_unit;
  params->dbl     = Val_unit;
  register_global_root(&(params->closure));
  return res;
}
#define FDFSOLVER_VAL(v) ((gsl_multifit_fdfsolver *)(Field(v, 0)))
#define CALLBACKPARAMS_VAL(v)    ((struct callback_params *)(Field(v, 1)))

CAMLprim value ml_gsl_multifit_fdfsolver_set(value S, value fun, value x)
{
  CAMLparam2(S, x);
  struct callback_params *p=CALLBACKPARAMS_VAL(S);
  _DECLARE_VECTOR(x);
  _CONVERT_VECTOR(x);
  p->closure = fun;
  gsl_multifit_fdfsolver_set(FDFSOLVER_VAL(S), &(p->gslfun.mffdf), &v_x);
  CAMLreturn(Val_unit);
}

CAMLprim value ml_gsl_multifit_fdfsolver_free(value S)
{
  struct callback_params *p=CALLBACKPARAMS_VAL(S);
  remove_global_root(&(p->closure));
  stat_free(p);
  gsl_multifit_fdfsolver_free(FDFSOLVER_VAL(S));
  return Val_unit;
}

ML1(gsl_multifit_fdfsolver_name, FDFSOLVER_VAL, caml_copy_string)

ML1(gsl_multifit_fdfsolver_iterate, FDFSOLVER_VAL, Unit)

CAMLprim value ml_gsl_multifit_fdfsolver_position(value S, value x)
{
  CAMLparam2(S, x);
  gsl_vector *pos;
  _DECLARE_VECTOR(x);
  _CONVERT_VECTOR(x);
  pos=gsl_multifit_fdfsolver_position(FDFSOLVER_VAL(S));
  gsl_vector_memcpy(&v_x, pos);
  CAMLreturn(Val_unit);
}

CAMLprim value ml_gsl_multifit_fdfsolver_get_state(value solv, value xo, value fo, 
					  value dxo, value unit)
{
  gsl_multifit_fdfsolver *S=FDFSOLVER_VAL(solv);
  if(Is_block(xo)) {
    value x=Unoption(xo);
    _DECLARE_VECTOR(x);
    _CONVERT_VECTOR(x);
    gsl_vector_memcpy(&v_x, S->x);
  }
  if(Is_block(fo)) {
    value f=Unoption(fo);
    _DECLARE_VECTOR(f);
    _CONVERT_VECTOR(f);
    gsl_vector_memcpy(&v_f, S->f);
  }
  if(Is_block(dxo)) {
    value dx=Unoption(dxo);
    _DECLARE_VECTOR(dx);
    _CONVERT_VECTOR(dx);
    gsl_vector_memcpy(&v_dx, S->dx);
  }
  return Val_unit;
}

CAMLprim value ml_gsl_multifit_test_delta(value S, value epsabs, value epsrel)
{
  gsl_multifit_fdfsolver *solv=FDFSOLVER_VAL(S);
  int status = gsl_multifit_test_delta(solv->dx, solv->x, 
				       Double_val(epsabs), Double_val(epsrel));
  return Val_negbool(status);
}

CAMLprim value ml_gsl_multifit_test_gradient(value S, value J, value epsabs, value g)
{
  int status;
  gsl_multifit_fdfsolver *solv=FDFSOLVER_VAL(S);
  _DECLARE_VECTOR(g);
  _CONVERT_VECTOR(g);
  _DECLARE_MATRIX(J);
  _CONVERT_MATRIX(J);
  gsl_multifit_gradient(&m_J, solv->f, &v_g);
  status = gsl_multifit_test_gradient(&v_g, Double_val(epsabs));
  return Val_negbool(status);
}

CAMLprim value ml_gsl_multifit_covar(value J, value epsrel, value covar)
{
  _DECLARE_MATRIX(J);
  _CONVERT_MATRIX(J);
  _DECLARE_MATRIX(covar);
  _CONVERT_MATRIX(covar);
  gsl_multifit_covar(&m_J, Double_val(epsrel), &m_covar);
  return Val_unit;
}
