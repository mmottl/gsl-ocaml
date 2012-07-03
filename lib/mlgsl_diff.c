/* gsl-ocaml - OCaml interface to GSL                        */
/* Copyright (©) 2002-2005 - Olivier Andrieu                */
/* Distributed under the terms of the LGPL version 2.1      */


#include <gsl/gsl_diff.h>

#include <caml/mlvalues.h>
#include <caml/memory.h>

#include "wrappers.h"
#include "mlgsl_fun.h"

value ml_gsl_diff_central(value f, value x)
{
  CAMLparam1(f);
  double result,abserr;
  GSLFUN_CLOSURE(gf, f);
  gsl_diff_central(&gf, Double_val(x),
		   &result, &abserr);
  CAMLreturn(copy_two_double_arr(result, abserr));
}

value ml_gsl_diff_forward(value f, value x)
{
  CAMLparam1(f);
  double result,abserr;
  GSLFUN_CLOSURE(gf, f);
  gsl_diff_forward(&gf, Double_val(x),
		   &result, &abserr);
  CAMLreturn(copy_two_double_arr(result, abserr));
}

value ml_gsl_diff_backward(value f, value x)
{
  CAMLparam1(f);
  double result,abserr;
  GSLFUN_CLOSURE(gf, f);
  gsl_diff_backward(&gf, Double_val(x),
		    &result, &abserr);
  CAMLreturn(copy_two_double_arr(result, abserr));
}
