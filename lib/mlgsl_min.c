/* gsl-ocaml - OCaml interface to GSL                        */
/* Copyright (©) 2002-2005 - Olivier Andrieu                */
/* Distributed under the terms of the GPL version 2         */

#include <gsl/gsl_min.h>

#include <caml/alloc.h>
#include <caml/memory.h>
#include <caml/fail.h>

#include "wrappers.h"
#include "mlgsl_fun.h"

static const gsl_min_fminimizer_type *Minimizertype_val(value mini_type)
{
  const gsl_min_fminimizer_type *minimizer[] = {
    gsl_min_fminimizer_goldensection,
    gsl_min_fminimizer_brent };
  return minimizer[Int_val(mini_type)];
}

CAMLprim value ml_gsl_min_fminimizer_alloc(value t)
{
  CAMLparam0();
  CAMLlocal1(res);
  struct callback_params *params;
  gsl_min_fminimizer *s;

  s=gsl_min_fminimizer_alloc(Minimizertype_val(t));
  params=stat_alloc(sizeof *params);
  
  res=alloc_small(2, Abstract_tag);
  Field(res, 0) = (value)s;
  Field(res, 1) = (value)params;
  params->gslfun.gf.function = &gslfun_callback ;
  params->gslfun.gf.params   = params;
  params->closure = Val_unit;
  params->dbl     = Val_unit;
  register_global_root(&(params->closure));
  CAMLreturn(res);
}
#define Minimizer_val(v) ((gsl_min_fminimizer *)Field((v), 0))
#define Mparams_val(v)   ((struct callback_params *)Field((v), 1))

CAMLprim value ml_gsl_min_fminimizer_set(value s, value f, value min, value lo, value up)
{
  CAMLparam1(s);
  Mparams_val(s)->closure = f;
  gsl_min_fminimizer_set(Minimizer_val(s), &(Mparams_val(s)->gslfun.gf), 
			 Double_val(min), Double_val(lo), Double_val(up));
  CAMLreturn(Val_unit);
}

CAMLprim value ml_gsl_min_fminimizer_free(value s)
{
  remove_global_root(&(Mparams_val(s)->closure));
  stat_free(Mparams_val(s));
  gsl_min_fminimizer_free(Minimizer_val(s));
  return Val_unit;
}

ML1(gsl_min_fminimizer_name, Minimizer_val, copy_string)

ML1(gsl_min_fminimizer_iterate, Minimizer_val, Unit)

ML1(gsl_min_fminimizer_x_minimum, Minimizer_val, copy_double)

CAMLprim value ml_gsl_min_fminimizer_x_interv(value S)
{
  return copy_two_double(gsl_min_fminimizer_x_lower(Minimizer_val(S)),
			 gsl_min_fminimizer_x_upper(Minimizer_val(S)));
}

ML4(gsl_min_test_interval, Double_val, Double_val, 
    Double_val, Double_val, Val_negbool)
