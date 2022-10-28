/* gsl-ocaml - OCaml interface to GSL                       */
/* Copyright (©) 2002-2012 - Olivier Andrieu                */
/* Distributed under the terms of the GPL version 3         */

#include <gsl/gsl_sum.h>

#include <caml/mlvalues.h>
#include <caml/memory.h>

#include "wrappers.h"

#define WS_val(v) ((gsl_sum_levin_u_workspace *)(Field((v), 0)))
ML1_alloc(gsl_sum_levin_u_alloc, Int_val, Abstract_ptr)
ML1(gsl_sum_levin_u_free, WS_val, Unit)

CAMLprim value ml_gsl_sum_levin_u_accel(value arr, value ws)
{
  double sum_accel, abserr;
  gsl_sum_levin_u_accel(Double_array_val(arr), Double_array_length(arr),
			WS_val(ws), &sum_accel, &abserr);
  return copy_two_double_arr(sum_accel, abserr);
}

CAMLprim value ml_gsl_sum_levin_u_getinfo(value ws)
{
  gsl_sum_levin_u_workspace *W=WS_val(ws);
  CAMLparam0();
  CAMLlocal2(v, s);
  s=caml_copy_double(W->sum_plain);
  v=caml_alloc_small(3, 0);
  Field(v, 0)=Val_int(W->size);
  Field(v, 1)=Val_int(W->terms_used);
  Field(v, 2)=s;
  CAMLreturn(v);
}

#define WStrunc_val(v) ((gsl_sum_levin_utrunc_workspace *)(Field((v), 0)))
ML1_alloc(gsl_sum_levin_utrunc_alloc, Int_val, Abstract_ptr)
ML1(gsl_sum_levin_utrunc_free, WStrunc_val, Unit)

CAMLprim value ml_gsl_sum_levin_utrunc_accel(value arr, value ws)
{
  double sum_accel, abserr;
  gsl_sum_levin_utrunc_accel(Double_array_val(arr), Double_array_length(arr),
			     WStrunc_val(ws), &sum_accel, &abserr);
  return copy_two_double_arr(sum_accel, abserr);
}

CAMLprim value ml_gsl_sum_levin_utrunc_getinfo(value ws)
{
  gsl_sum_levin_utrunc_workspace *W=WStrunc_val(ws);
  CAMLparam0();
  CAMLlocal2(v, s);
  s=caml_copy_double(W->sum_plain);
  v=caml_alloc_small(3, 0);
  Field(v, 0)=Val_int(W->size);
  Field(v, 1)=Val_int(W->terms_used);
  Field(v, 2)=s;
  CAMLreturn(v);
}
