/* gsl-ocaml - OCaml interface to GSL                        */
/* Copyright (©) 2002-2005 - Olivier Andrieu                */
/* Distributed under the terms of the LGPL version 2.1      */

#include <string.h>

#include <caml/memory.h>

#include <gsl/gsl_math.h>
#include <gsl/gsl_chebyshev.h>

#include "wrappers.h"
#include "mlgsl_fun.h"

#define CHEB_VAL(v) ((gsl_cheb_series *)Field((v), 0))
ML1_alloc(gsl_cheb_alloc, Int_val, Abstract_ptr)
ML1(gsl_cheb_free, CHEB_VAL, Unit)

CAMLprim value ml_gsl_cheb_order(value c)
{
  return Val_int(CHEB_VAL(c)->order);
}

CAMLprim value ml_gsl_cheb_coefs(value c)
{
  CAMLparam1(c);
  CAMLlocal1(a);
  gsl_cheb_series *cs = CHEB_VAL(c);
  size_t len = cs->order + 1;
  a = alloc(len * Double_wosize, Double_array_tag);
  memcpy(Bp_val(a), cs->c, len * sizeof (double));
  CAMLreturn(a);
}

CAMLprim value ml_gsl_cheb_init(value cs, value f, value a, value b)
{
  CAMLparam2(cs, f);
  GSLFUN_CLOSURE(gf, f);
  gsl_cheb_init(CHEB_VAL(cs), &gf, Double_val(a), Double_val(b));
  CAMLreturn(Val_unit);
}

ML2(gsl_cheb_eval, CHEB_VAL, Double_val, copy_double)

CAMLprim value ml_gsl_cheb_eval_err(value cheb, value x)
{
  double res,err;
  gsl_cheb_eval_err(CHEB_VAL(cheb), Double_val(x), &res, &err);
  return copy_two_double_arr(res, err);
}

ML3(gsl_cheb_eval_n, CHEB_VAL, Int_val, Double_val, copy_double)

CAMLprim value ml_gsl_cheb_eval_n_err(value cheb, value order, value x)
{
  double res,err;
  gsl_cheb_eval_n_err(CHEB_VAL(cheb), Int_val(order),
		      Double_val(x), &res, &err);
  return copy_two_double_arr(res, err);
}

ML2(gsl_cheb_calc_deriv, CHEB_VAL, CHEB_VAL, Unit)
ML2(gsl_cheb_calc_integ, CHEB_VAL, CHEB_VAL, Unit)
