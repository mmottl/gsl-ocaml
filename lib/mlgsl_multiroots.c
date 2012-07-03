/* gsl-ocaml - OCaml interface to GSL                       */
/* Copyright (©) 2002-2005 - Olivier Andrieu                */
/* Distributed under the terms of the LGPL version 2.1      */

#include <gsl/gsl_multiroots.h>

#include <caml/alloc.h>
#include <caml/memory.h>
#include <caml/fail.h>
#include <caml/callback.h>

#include "wrappers.h"
#include "mlgsl_fun.h"
#include "mlgsl_vector_double.h"
#include "mlgsl_matrix_double.h"

/* solvers */
static const gsl_multiroot_fsolver_type *fsolver_of_value(value t)
{
  const gsl_multiroot_fsolver_type *solver_types[] = {
    gsl_multiroot_fsolver_hybrids,
    gsl_multiroot_fsolver_hybrid,
    gsl_multiroot_fsolver_dnewton,
    gsl_multiroot_fsolver_broyden, } ;
  return solver_types[Int_val(t)];
}

static const gsl_multiroot_fdfsolver_type *fdfsolver_of_value(value t)
{
  const gsl_multiroot_fdfsolver_type *solver_types[] = {
    gsl_multiroot_fdfsolver_hybridsj,
    gsl_multiroot_fdfsolver_hybridj,
    gsl_multiroot_fdfsolver_newton,
    gsl_multiroot_fdfsolver_gnewton, } ;
  return solver_types[Int_val(t)];
}

#define CALLBACKPARAMS_VAL(v)     ((struct callback_params *)(Field(v, 1)))

CAMLprim value ml_gsl_multiroot_fsolver_alloc(value type, value d)
{
  int dim = Int_val(d);
  gsl_multiroot_fsolver *S;
  struct callback_params *params;
  value res;

  S=gsl_multiroot_fsolver_alloc(fsolver_of_value(type), dim);
  params=stat_alloc(sizeof(*params));

  res=alloc_small(2, Abstract_tag);
  Field(res, 0) = (value)S;
  Field(res, 1) = (value)params;
  params->gslfun.mrf.f      = &gsl_multiroot_callback;
  params->gslfun.mrf.n      = dim ;
  params->gslfun.mrf.params = params;
  params->closure = Val_unit;
  params->dbl     = Val_unit; /* not needed actually */
  register_global_root(&(params->closure));
  return res;
}
#define GSLMULTIROOTSOLVER_VAL(v) ((gsl_multiroot_fsolver *)(Field(v, 0)))

CAMLprim value ml_gsl_multiroot_fdfsolver_alloc(value type, value d)
{
  int dim = Int_val(d);
  gsl_multiroot_fdfsolver *S;
  struct callback_params *params;
  value res;

  S=gsl_multiroot_fdfsolver_alloc(fdfsolver_of_value(type), dim);
  params=stat_alloc(sizeof(*params));

  res=alloc_small(2, Abstract_tag);
  Field(res, 0) = (value)S;
  Field(res, 1) = (value)params;
  params->gslfun.mrfdf.f      = &gsl_multiroot_callback_f;  
  params->gslfun.mrfdf.df     = &gsl_multiroot_callback_df; 
  params->gslfun.mrfdf.fdf    = &gsl_multiroot_callback_fdf;
  params->gslfun.mrfdf.n      = dim ;
  params->gslfun.mrfdf.params = params;
  params->closure = Val_unit;
  params->dbl     = Val_unit; /* not needed actually */
  register_global_root(&(params->closure));
  return res;
}
#define GSLMULTIROOTFDFSOLVER_VAL(v) ((gsl_multiroot_fdfsolver *)(Field(v, 0)))

CAMLprim value ml_gsl_multiroot_fsolver_set(value S, value fun, value X)
{
  CAMLparam2(S, X);
  struct callback_params *p=CALLBACKPARAMS_VAL(S);
  _DECLARE_VECTOR(X);
  _CONVERT_VECTOR(X);
  p->closure = fun;
  if(v_X.size != p->gslfun.mrf.n)
    GSL_ERROR("wrong number of dimensions for function", GSL_EBADLEN);
  gsl_multiroot_fsolver_set(GSLMULTIROOTSOLVER_VAL(S), &(p->gslfun.mrf), &v_X);
  CAMLreturn(Val_unit);
}

CAMLprim value ml_gsl_multiroot_fdfsolver_set(value S, value fun, value X)
{
  CAMLparam2(S,X);
  struct callback_params *p=CALLBACKPARAMS_VAL(S);
  _DECLARE_VECTOR(X);
  _CONVERT_VECTOR(X);
  p->closure = fun;
  if(v_X.size != p->gslfun.mrfdf.n)
    GSL_ERROR("wrong number of dimensions for function", GSL_EBADLEN);
  gsl_multiroot_fdfsolver_set(GSLMULTIROOTFDFSOLVER_VAL(S), 
			      &(p->gslfun.mrfdf), &v_X);
  CAMLreturn(Val_unit);
}

CAMLprim value ml_gsl_multiroot_fsolver_free(value S)
{
  struct callback_params *p=CALLBACKPARAMS_VAL(S);
  remove_global_root(&(p->closure));
  stat_free(p);
  gsl_multiroot_fsolver_free(GSLMULTIROOTSOLVER_VAL(S));
  return Val_unit;
}

CAMLprim value ml_gsl_multiroot_fdfsolver_free(value S)
{
  struct callback_params *p=CALLBACKPARAMS_VAL(S);
  remove_global_root(&(p->closure));
  stat_free(p);
  gsl_multiroot_fdfsolver_free(GSLMULTIROOTFDFSOLVER_VAL(S));
  return Val_unit;
}

ML1(gsl_multiroot_fsolver_name, GSLMULTIROOTSOLVER_VAL, copy_string)
ML1(gsl_multiroot_fdfsolver_name, GSLMULTIROOTFDFSOLVER_VAL, copy_string)

ML1(gsl_multiroot_fsolver_iterate, GSLMULTIROOTSOLVER_VAL, Unit)
ML1(gsl_multiroot_fdfsolver_iterate, GSLMULTIROOTFDFSOLVER_VAL, Unit)

CAMLprim value ml_gsl_multiroot_fsolver_root(value S, value r)
{
  CAMLparam2(S,r);
  gsl_vector *root;
  _DECLARE_VECTOR(r);
  _CONVERT_VECTOR(r);
  root=gsl_multiroot_fsolver_root(GSLMULTIROOTSOLVER_VAL(S));
  gsl_vector_memcpy(&v_r, root);
  CAMLreturn(Val_unit);
}

CAMLprim value ml_gsl_multiroot_fdfsolver_root(value S, value r)
{
  CAMLparam2(S,r);
  gsl_vector *root;
  _DECLARE_VECTOR(r);
  _CONVERT_VECTOR(r);
  root=gsl_multiroot_fdfsolver_root(GSLMULTIROOTFDFSOLVER_VAL(S));
  gsl_vector_memcpy(&v_r, root);
  CAMLreturn(Val_unit);
}

CAMLprim value ml_gsl_multiroot_fsolver_get_state(value S, value ox, 
					 value of, value odx, value unit)
{
  gsl_multiroot_fsolver *s=GSLMULTIROOTSOLVER_VAL(S);
  if(Is_block(ox)) {
    value x=Unoption(ox);
    _DECLARE_VECTOR(x);
    _CONVERT_VECTOR(x);
    gsl_vector_memcpy(&v_x,  s->x);
  }
  if(Is_block(of)) {
    value f=Unoption(of);
    _DECLARE_VECTOR(f);
    _CONVERT_VECTOR(f);
    gsl_vector_memcpy(&v_f,  s->f);
  }
  if(Is_block(odx)) {
    value dx=Unoption(odx);
    _DECLARE_VECTOR(dx);
    _CONVERT_VECTOR(dx);
    gsl_vector_memcpy(&v_dx,  s->dx);
  }
  return Val_unit;
}

CAMLprim value ml_gsl_multiroot_fdfsolver_get_state(value S, value ox, value of, 
					   value oj, value odx, value unit)
{
  gsl_multiroot_fdfsolver *s=GSLMULTIROOTFDFSOLVER_VAL(S);
  if(Is_block(ox)) {
      value x=Unoption(ox);
      _DECLARE_VECTOR(x);
      _CONVERT_VECTOR(x);
      gsl_vector_memcpy(&v_x,  s->x);
  }
  if(Is_block(of)) {
      value f=Unoption(of);
      _DECLARE_VECTOR(f);
      _CONVERT_VECTOR(f);
      gsl_vector_memcpy(&v_f,  s->f);
  }
  if(Is_block(odx)) {
      value dx=Unoption(odx);
      _DECLARE_VECTOR(dx);
      _CONVERT_VECTOR(dx);
      gsl_vector_memcpy(&v_dx,  s->dx);
  }
  if(Is_block(oj)) {
      value j=Unoption(oj);
      _DECLARE_MATRIX(j);
      _CONVERT_MATRIX(j);
      gsl_matrix_memcpy(&m_j,  s->J);
  }
  return Val_unit;
}

CAMLprim value ml_gsl_multiroot_fdfsolver_get_state_bc(value *argv, int argc)
{
  return ml_gsl_multiroot_fdfsolver_get_state(argv[0], argv[1], argv[2],
					      argv[3], argv[4], argv[5]);
}

CAMLprim value ml_gsl_multiroot_test_delta_f(value S, value epsabs, value epsrel)
{
  int status;
  status = gsl_multiroot_test_delta(GSLMULTIROOTSOLVER_VAL(S)->dx, 
				    GSLMULTIROOTSOLVER_VAL(S)->x,
				    Double_val(epsabs), Double_val(epsrel));
  return Val_negbool(status);
}

CAMLprim value ml_gsl_multiroot_test_delta_fdf(value S, value epsabs, value epsrel)
{
  int status;
  status = gsl_multiroot_test_delta(GSLMULTIROOTFDFSOLVER_VAL(S)->dx, 
				    GSLMULTIROOTFDFSOLVER_VAL(S)->x,
				    Double_val(epsabs), Double_val(epsrel));
  return Val_negbool(status);
}

CAMLprim value ml_gsl_multiroot_test_residual_f(value S, value epsabs)
{
  int status;
  status = gsl_multiroot_test_residual(GSLMULTIROOTSOLVER_VAL(S)->f,
				       Double_val(epsabs));
  return Val_negbool(status);
}

CAMLprim value ml_gsl_multiroot_test_residual_fdf(value S, value epsabs)
{
  int status;
  status = gsl_multiroot_test_residual(GSLMULTIROOTFDFSOLVER_VAL(S)->f, 
				       Double_val(epsabs));
  return Val_negbool(status);
}
