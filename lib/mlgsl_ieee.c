/* gsl-ocaml - OCaml interface to GSL                       */
/* Copyright (©) 2002-2012 - Olivier Andrieu                */
/* Distributed under the terms of the GPL version 3         */


#include <gsl/gsl_ieee_utils.h>

#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/memory.h>

#include "wrappers.h"

static value rep_val(const gsl_ieee_double_rep *r)
{
  CAMLparam0();
  CAMLlocal2(v, m);
  m=copy_string(r->mantissa);
  v=alloc_small(4, 0);
  Field(v, 0)= Val_int(r->sign);
  Field(v, 1)= m;
  Field(v, 2)= Val_int(r->exponent);
  Field(v, 3)= Val_int(r->type - 1);
  CAMLreturn(v);
}

CAMLprim value ml_gsl_ieee_double_to_rep(value x)
{
  double d;
  gsl_ieee_double_rep r;
  d = Double_val(x);
  gsl_ieee_double_to_rep(&d, &r);
  return rep_val(&r);
}

CAMLprim value ml_gsl_ieee_env_setup(value unit)
{
  gsl_ieee_env_setup();
  return Val_unit;
}

CAMLprim value ml_gsl_ieee_set_mode(value oprecision, value orounding, value ex_list)
{
  static const int precision_conv [] = { 
    GSL_IEEE_SINGLE_PRECISION, GSL_IEEE_DOUBLE_PRECISION, GSL_IEEE_EXTENDED_PRECISION };
  static const int round_conv [] = { 
    GSL_IEEE_ROUND_TO_NEAREST, GSL_IEEE_ROUND_DOWN, GSL_IEEE_ROUND_UP, GSL_IEEE_ROUND_TO_ZERO };
  static int mask_conv [] = {
    GSL_IEEE_MASK_INVALID, GSL_IEEE_MASK_DENORMALIZED,
    GSL_IEEE_MASK_DENORMALIZED, GSL_IEEE_MASK_OVERFLOW,
    GSL_IEEE_MASK_UNDERFLOW, GSL_IEEE_MASK_ALL,
    GSL_IEEE_TRAP_INEXACT } ;
  int mask = convert_flag_list(ex_list, mask_conv);

#define Lookup_precision(v) precision_conv[ Int_val(v) ]
#define Lookup_round(v)     round_conv[ Int_val(v) ]

  gsl_ieee_set_mode(Opt_arg(oprecision, Lookup_precision, 0), 
		    Opt_arg(orounding,  Lookup_round, 0), 
		    mask);
  return Val_unit;
}

#ifdef HAVE_FENV
#include <fenv.h>

static int except_conv [] = {
#ifdef FE_INEXACT
    FE_INEXACT,
#else
    0,
#endif
#ifdef FE_DIVBYZERO
    FE_DIVBYZERO,
#else
    0,
#endif
#ifdef FE_UNDERFLOW
    FE_UNDERFLOW,
#else
    0,
#endif
#ifdef FE_OVERFLOW
    FE_OVERFLOW,
#else
    0,
#endif
#ifdef FE_INVALID
    FE_INVALID,
#else
    0,
#endif
#ifdef FE_ALL_EXCEPT
    FE_ALL_EXCEPT,
#else
    0,
#endif
};

static int conv_excepts(value e)
{
  return convert_flag_list(e, except_conv);
}

static value rev_conv_excepts(int e)
{
  CAMLparam0();
  CAMLlocal2(v, c);
  int i, tab_size = (sizeof except_conv / sizeof (int)) ;
  v = Val_emptylist;
  
  for(i = tab_size-2; i >= 0 ; i--)
    if(except_conv[i] & e) {
      c = alloc_small(2, Tag_cons);
      Field(c, 0) = Val_int(i);
      Field(c, 1) = v;
      v = c;
    }
  CAMLreturn(v);
}

CAMLprim value ml_feclearexcept(value e)
{
  feclearexcept(conv_excepts(e));
  return Val_unit;
}

CAMLprim value ml_fetestexcept(value e)
{
  return rev_conv_excepts(fetestexcept(conv_excepts(e)));
}

#else /* HAVE_FENV */

CAMLprim value ml_feclearexcept(value e)
{
  return Val_unit;
}

CAMLprim value ml_fetestexcept(value e)
{
  return Val_emptylist;
}

#endif /* HAVE_FENV */
