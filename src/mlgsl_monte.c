/* gsl-ocaml - OCaml interface to GSL                       */
/* Copyright (©) 2002-2012 - Olivier Andrieu                */
/* Distributed under the terms of the GPL version 3         */

#include <stdio.h>

#ifdef WIN32
#include <stdlib.h>
#include <io.h>
#else
#include <unistd.h> 
#endif 

#include <string.h>

#include <gsl/gsl_errno.h>
#include <gsl/gsl_monte_plain.h>
#include <gsl/gsl_monte_miser.h>
#include <gsl/gsl_monte_vegas.h>

#include <caml/callback.h>
#include <caml/alloc.h>
#include <caml/memory.h>
#include <caml/fail.h>

#include "wrappers.h"
#include "mlgsl_fun.h"
#include "mlgsl_rng.h"

#include <stdint.h>
#include "io.h"

#define CallbackParams_val(v)   ((struct callback_params *)Field((v), 1))


/* PLAIN algorithm */
#define GSLPLAINSTATE_VAL(v) ((gsl_monte_plain_state *)Field((v), 0))

CAMLprim value ml_gsl_monte_plain_alloc(value d)
{
  gsl_monte_plain_state *s;
  struct callback_params *params;
  int dim=Int_val(d);

  s=gsl_monte_plain_alloc(dim);
  params=stat_alloc(sizeof(*params));

  {
    CAMLparam0();
    CAMLlocal1(res);

    res=caml_alloc_small(2, Abstract_tag);
    Field(res, 0) = (value)s;
    Field(res, 1) = (value)params;
    params->gslfun.mf.f = &gsl_monte_callback;
    params->gslfun.mf.dim = dim;
    params->gslfun.mf.params = params;
    params->closure = Val_unit;
    params->dbl = alloc(dim * Double_wosize, Double_array_tag);
  
    register_global_root(&(params->closure));
    register_global_root(&(params->dbl));
    CAMLreturn(res);
  }
}

ML1(gsl_monte_plain_init, GSLPLAINSTATE_VAL, Unit)

CAMLprim value ml_gsl_monte_plain_free(value s)
{
  remove_global_root(&(CallbackParams_val(s)->closure));
  remove_global_root(&(CallbackParams_val(s)->dbl));
  stat_free(CallbackParams_val(s));
  gsl_monte_plain_free(GSLPLAINSTATE_VAL(s));
  return Val_unit;
}

CAMLprim value ml_gsl_monte_plain_integrate(value fun, value xlo, value xup, 
				   value calls, value rng, value state)
{
  CAMLparam2(rng, state);
  double result, abserr;
  size_t dim=Double_array_length(xlo);
  LOCALARRAY(double, c_xlo, dim); 
  LOCALARRAY(double, c_xup, dim); 
  struct callback_params *params=CallbackParams_val(state);

  if(params->gslfun.mf.dim != dim)
    GSL_ERROR("wrong number of dimensions for function", GSL_EBADLEN);
  if(Double_array_length(xup) != dim)
    GSL_ERROR("array sizes differ", GSL_EBADLEN);
  params->closure = fun;
  memcpy(c_xlo, Double_array_val(xlo), dim*sizeof(double));
  memcpy(c_xup, Double_array_val(xup), dim*sizeof(double));
  gsl_monte_plain_integrate(&params->gslfun.mf,
			    c_xlo, c_xup, dim,
			    Int_val(calls),
			    Rng_val(rng),
			    GSLPLAINSTATE_VAL(state),
			    &result, &abserr);
  CAMLreturn(copy_two_double_arr(result, abserr));
}

CAMLprim value ml_gsl_monte_plain_integrate_bc(value *argv, int argc)
{
  return ml_gsl_monte_plain_integrate(argv[0], argv[1], argv[2],
				      argv[3], argv[4], argv[5]);
}



/* MISER algorithm */
#define GSLMISERSTATE_VAL(v) ((gsl_monte_miser_state *)Field((v), 0))

CAMLprim value ml_gsl_monte_miser_alloc(value d)
{
  gsl_monte_miser_state *s;
  struct callback_params *params;
  int dim=Int_val(d);

  s=gsl_monte_miser_alloc(dim);
  params=stat_alloc(sizeof(*params));

  {
    CAMLparam0();
    CAMLlocal1(res);
    res=caml_alloc_small(2, Abstract_tag);
    Field(res, 0) = (value)s;
    Field(res, 1) = (value)params;
    params->gslfun.mf.f = &gsl_monte_callback;
    params->gslfun.mf.dim = dim;
    params->gslfun.mf.params = params;
    params->closure = Val_unit;
    params->dbl = alloc(dim * Double_wosize, Double_array_tag);
  
    register_global_root(&(params->closure));
    register_global_root(&(params->dbl));
    CAMLreturn(res);
  }
}

ML1(gsl_monte_miser_init, GSLMISERSTATE_VAL, Unit)

CAMLprim value ml_gsl_monte_miser_free(value s)
{
  remove_global_root(&(CallbackParams_val(s)->closure));
  remove_global_root(&(CallbackParams_val(s)->dbl));
  stat_free(CallbackParams_val(s));
  gsl_monte_miser_free(GSLMISERSTATE_VAL(s));
  return Val_unit;
}

CAMLprim value ml_gsl_monte_miser_integrate(value fun, value xlo, value xup, 
				   value calls, value rng, value state)
{
  CAMLparam2(rng, state);
  double result,abserr;
  size_t dim=Double_array_length(xlo);
  LOCALARRAY(double, c_xlo, dim); 
  LOCALARRAY(double, c_xup, dim); 
  struct callback_params *params=CallbackParams_val(state);

  if(params->gslfun.mf.dim != dim)
    GSL_ERROR("wrong number of dimensions for function", GSL_EBADLEN);
  if(Double_array_length(xup) != dim)
    GSL_ERROR("array sizes differ", GSL_EBADLEN);
  params->closure=fun;
  memcpy(c_xlo, Double_array_val(xlo), dim*sizeof(double));
  memcpy(c_xup, Double_array_val(xup), dim*sizeof(double));
  gsl_monte_miser_integrate(&params->gslfun.mf,
			    c_xlo, c_xup, dim,
			    Int_val(calls),
			    Rng_val(rng),
			    GSLMISERSTATE_VAL(state),
			    &result, &abserr);
  CAMLreturn(copy_two_double_arr(result, abserr));
}

CAMLprim value ml_gsl_monte_miser_integrate_bc(value *argv, int argc)
{
  return ml_gsl_monte_miser_integrate(argv[0], argv[1], argv[2],
				      argv[3], argv[4], argv[5]);
}

CAMLprim value ml_gsl_monte_miser_get_params(value state)
{
  CAMLparam0();
  CAMLlocal1(r);
  gsl_monte_miser_state *s = GSLMISERSTATE_VAL(state);
  r=alloc_tuple(5);
  Store_field(r, 0, caml_copy_double(s->estimate_frac));
  Store_field(r, 1, Val_int(s->min_calls));
  Store_field(r, 2, Val_int(s->min_calls_per_bisection));
  Store_field(r, 3, caml_copy_double(s->alpha));
  Store_field(r, 4, caml_copy_double(s->dither));
  CAMLreturn(r);
}

CAMLprim value ml_gsl_monte_miser_set_params(value state, value params)
{
  gsl_monte_miser_state *s = GSLMISERSTATE_VAL(state);
  s->estimate_frac           = Double_val(Field(params, 0));
  s->min_calls               = Int_val(Field(params, 1));
  s->min_calls_per_bisection = Int_val(Field(params, 2));
  s->alpha                   = Double_val(Field(params, 3));
  s->dither                  = Double_val(Field(params, 4));
  return Val_unit;
}



/* VEGAS algorithm */
#define GSLVEGASSTATE_VAL(v)  ((gsl_monte_vegas_state *)Field((v), 0))
#define GSLVEGASSTREAM_VAL(v) Field((v), 2)

CAMLprim value ml_gsl_monte_vegas_alloc(value d)
{
  gsl_monte_vegas_state *s;
  struct callback_params *params;
  int dim=Int_val(d);

  s=gsl_monte_vegas_alloc(dim);
  params=stat_alloc(sizeof(*params));

  {
    CAMLparam0();
    CAMLlocal1(res);    
    res=caml_alloc_small(3, Abstract_tag);
    Field(res, 0) = (value)s;
    Field(res, 1) = (value)params;
    Field(res, 2) = Val_none;
    params->gslfun.mf.f = &gsl_monte_callback;
    params->gslfun.mf.dim = dim;
    params->gslfun.mf.params = params;
    params->closure = Val_unit;
    params->dbl = alloc(dim * Double_wosize, Double_array_tag);
    
    register_global_root(&(params->closure));
    register_global_root(&(params->dbl));
    register_global_root(&(Field(res, 2)));
    CAMLreturn(res);
  }
}

ML1(gsl_monte_vegas_init, GSLVEGASSTATE_VAL, Unit)

CAMLprim value ml_gsl_monte_vegas_free(value state)
{
  gsl_monte_vegas_state *s=GSLVEGASSTATE_VAL(state);
  remove_global_root(&(CallbackParams_val(state)->closure));
  remove_global_root(&(CallbackParams_val(state)->dbl));
  stat_free(CallbackParams_val(state));
  if(s->ostream != stdout && s->ostream != stderr)
    fclose(s->ostream);
  remove_global_root(&GSLVEGASSTREAM_VAL(state));
  gsl_monte_vegas_free(s);
  return Val_unit;
}

CAMLprim value ml_gsl_monte_vegas_integrate(value fun, value xlo, value xup, 
				   value calls, value rng, value state)
{
  CAMLparam2(rng, state);
  double result,abserr;
  size_t dim=Double_array_length(xlo);
  LOCALARRAY(double, c_xlo, dim); 
  LOCALARRAY(double, c_xup, dim); 
  struct callback_params *params=CallbackParams_val(state);

  if(params->gslfun.mf.dim != dim)
    GSL_ERROR("wrong number of dimensions for function", GSL_EBADLEN);
  if(Double_array_length(xup) != dim)
    GSL_ERROR("array sizes differ", GSL_EBADLEN);
  params->closure=fun;
  memcpy(c_xlo, Double_array_val(xlo), dim*sizeof(double));
  memcpy(c_xup, Double_array_val(xup), dim*sizeof(double));
  gsl_monte_vegas_integrate(&params->gslfun.mf,
			    c_xlo, c_xup, dim,
			    Int_val(calls),
			    Rng_val(rng),
			    GSLVEGASSTATE_VAL(state),
			    &result, &abserr);
  CAMLreturn(copy_two_double_arr(result, abserr));
}

CAMLprim value ml_gsl_monte_vegas_integrate_bc(value *argv, int argc)
{
  return ml_gsl_monte_vegas_integrate(argv[0], argv[1], argv[2],
				      argv[3], argv[4], argv[5]);
}

CAMLprim value ml_gsl_monte_vegas_get_info(value state)
{
  value r;
  gsl_monte_vegas_state *s = GSLVEGASSTATE_VAL(state);
  r=caml_alloc_small(3 * Double_wosize, Double_array_tag);
  Store_double_field(r, 0, s->result);
  Store_double_field(r, 1, s->sigma);
  Store_double_field(r, 2, s->chisq);
  return r;
}

CAMLprim value ml_gsl_monte_vegas_get_params(value state)
{
  CAMLparam0(); 
  CAMLlocal1(r);
  gsl_monte_vegas_state *s = GSLVEGASSTATE_VAL(state);
  r=alloc_tuple(6);
  Store_field(r, 0, caml_copy_double(s->alpha));
  Store_field(r, 1, Val_int(s->iterations));
  Store_field(r, 2, Val_int(s->stage));
  Store_field(r, 3, Val_int(s->mode + 1));
  Store_field(r, 4, Val_int(s->verbose));
  {
    value vchan;
    if(Is_some(GSLVEGASSTREAM_VAL(state))){
      vchan=caml_alloc_small(1, 0);
      Field(vchan, 0)=GSLVEGASSTREAM_VAL(state);
    }
    else
      vchan=Val_none;
    Store_field(r, 5, vchan);
  }
  CAMLreturn(r);
}

CAMLprim value ml_gsl_monte_vegas_set_params(value state, value params)
{
  gsl_monte_vegas_state *s = GSLVEGASSTATE_VAL(state);
  s->alpha      = Double_val(Field(params, 0));
  s->iterations = Int_val(Field(params, 1));
  s->stage      = Int_val(Field(params, 2));
  s->mode       = Int_val(Field(params, 3)) - 1;
  s->verbose    = Int_val(Field(params, 4));
  {
    value vchan = Field(params, 5);
    if(Is_block(vchan)){
      struct channel *chan=Channel(Field(vchan, 0));
      if(s->ostream != stdout && s->ostream != stderr) 
	fclose(s->ostream);
      flush(chan);
      s->ostream = fdopen(dup(chan->fd), "w");
      GSLVEGASSTREAM_VAL(state) = vchan;
    }
  }
  return Val_unit;
}
