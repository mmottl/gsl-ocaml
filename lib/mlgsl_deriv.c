/* gsl-ocaml - OCaml interface to GSL                       */
/* Copyright (©) 2002-2012 - Olivier Andrieu                */
/* Distributed under the terms of the GPL version 3         */

#include <gsl/gsl_deriv.h>

#include <caml/memory.h>
#include <caml/mlvalues.h>

#include "mlgsl_fun.h"
#include "wrappers.h"

value ml_gsl_deriv_central(value f, value x, value h) {
  CAMLparam1(f);
  double result, abserr;
  GSLFUN_CLOSURE(gf, f);
  gsl_deriv_central(&gf, Double_val(x), Double_val(h), &result, &abserr);
  CAMLreturn(copy_two_double_arr(result, abserr));
}

value ml_gsl_deriv_forward(value f, value x, value h) {
  CAMLparam1(f);
  double result, abserr;
  GSLFUN_CLOSURE(gf, f);
  gsl_deriv_forward(&gf, Double_val(x), Double_val(h), &result, &abserr);
  CAMLreturn(copy_two_double_arr(result, abserr));
}

value ml_gsl_deriv_backward(value f, value x, value h) {
  CAMLparam1(f);
  double result, abserr;
  GSLFUN_CLOSURE(gf, f);
  gsl_deriv_backward(&gf, Double_val(x), Double_val(h), &result, &abserr);
  CAMLreturn(copy_two_double_arr(result, abserr));
}
