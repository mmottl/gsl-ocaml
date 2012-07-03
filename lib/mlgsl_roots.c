/* gsl-ocaml - OCaml interface to GSL                       */
/* Copyright (©) 2002-2005 - Olivier Andrieu                */
/* Distributed under the terms of the LGPL version 2.1      */

#include <gsl/gsl_roots.h>

#include <caml/alloc.h>
#include <caml/memory.h>
#include <caml/fail.h>

#include "wrappers.h"
#include "mlgsl_fun.h"

static const gsl_root_fsolver_type *Fsolvertype_val(value solver_type)
{
  const gsl_root_fsolver_type *solvers[] = {
    gsl_root_fsolver_bisection,
    gsl_root_fsolver_falsepos,
    gsl_root_fsolver_brent };
  return solvers[Int_val(solver_type)];
}

static const gsl_root_fdfsolver_type *FDFsolvertype_val(value solver_type)
{
  const gsl_root_fdfsolver_type *solvers[] = {
    gsl_root_fdfsolver_newton,
    gsl_root_fdfsolver_secant,
    gsl_root_fdfsolver_steffenson };
  return solvers[Int_val(solver_type)];
}

CAMLprim value ml_gsl_root_fsolver_alloc(value t)
{
  struct callback_params *params;
  gsl_root_fsolver *s;
  
  s = gsl_root_fsolver_alloc(Fsolvertype_val(t));
  params=stat_alloc(sizeof(*params));

  {  
    CAMLparam0();
    CAMLlocal1(res);
    res=alloc_small(2, Abstract_tag);
    Field(res, 0) = (value)s;
    Field(res, 1) = (value)params;
    params->gslfun.gf.function = &gslfun_callback;
    params->gslfun.gf.params   = params;
    params->closure = Val_unit;
    params->dbl     = Val_unit;

    register_global_root(&(params->closure));
    CAMLreturn(res);
  }
}

CAMLprim value ml_gsl_root_fdfsolver_alloc(value t)
{
  struct callback_params *params;
  gsl_root_fdfsolver *s;
  
  s = gsl_root_fdfsolver_alloc(FDFsolvertype_val(t)); 
  params=stat_alloc(sizeof(*params));
  
  {
    CAMLparam0();
    CAMLlocal1(res);
    res=alloc_small(2, Abstract_tag);
    Field(res, 0) = (value)s;
    Field(res, 1) = (value)params;
    params->gslfun.gfdf.f      = &gslfun_callback_f;
    params->gslfun.gfdf.df     = &gslfun_callback_df;
    params->gslfun.gfdf.fdf    = &gslfun_callback_fdf;
    params->gslfun.gfdf.params = params;
    params->closure = Val_unit;
    params->dbl     = Val_unit;

    register_global_root(&(params->closure));
    CAMLreturn(res);
  }
}

#define Fsolver_val(v)   ((gsl_root_fsolver *)Field((v), 0))
#define FDFsolver_val(v) ((gsl_root_fdfsolver *)Field((v), 0))
#define Fparams_val(v)   ((struct callback_params *)Field((v), 1))

CAMLprim value ml_gsl_root_fsolver_set(value s, value f, value lo, value hi)
{
  CAMLparam1(s);
  struct callback_params *p=Fparams_val(s);
  p->closure=f;
  gsl_root_fsolver_set(Fsolver_val(s), &(p->gslfun.gf), 
		       Double_val(lo), Double_val(hi));
  CAMLreturn(Val_unit);
}

CAMLprim value ml_gsl_root_fdfsolver_set(value s, value f, value r)
{
  CAMLparam1(s);
  struct callback_params *p=Fparams_val(s);
  p->closure=f;
  gsl_root_fdfsolver_set(FDFsolver_val(s), &(p->gslfun.gfdf), Double_val(r));
  CAMLreturn(Val_unit);
}

CAMLprim value ml_gsl_root_fsolver_free(value s)
{
  struct callback_params *p=Fparams_val(s);
  remove_global_root(&(p->closure));
  stat_free(p);
  gsl_root_fsolver_free(Fsolver_val(s));
  return Val_unit;
}

CAMLprim value ml_gsl_root_fdfsolver_free(value s)
{
  struct callback_params *p=Fparams_val(s);
  remove_global_root(&(p->closure));
  stat_free(p);
  gsl_root_fdfsolver_free(FDFsolver_val(s));
  return Val_unit;
}

ML1(gsl_root_fsolver_name, Fsolver_val, copy_string)
ML1(gsl_root_fdfsolver_name, FDFsolver_val, copy_string)

ML1(gsl_root_fsolver_iterate, Fsolver_val, Unit)
ML1(gsl_root_fdfsolver_iterate, FDFsolver_val, Unit)
ML1(gsl_root_fsolver_root, Fsolver_val, copy_double)
ML1(gsl_root_fdfsolver_root, FDFsolver_val, copy_double)

CAMLprim value ml_gsl_root_fsolver_x_interv(value S)
{
  return copy_two_double(gsl_root_fsolver_x_lower(Fsolver_val(S)),
			 gsl_root_fsolver_x_upper(Fsolver_val(S)));
}


ML4(gsl_root_test_interval, Double_val, Double_val, Double_val, Double_val, Val_negbool)
ML4(gsl_root_test_delta, Double_val, Double_val, Double_val, Double_val, Val_negbool)
ML2(gsl_root_test_residual, Double_val, Double_val, Val_negbool)
