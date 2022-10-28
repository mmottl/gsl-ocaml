/* gsl-ocaml - OCaml interface to GSL                       */
/* Copyright (©) 2002-2012 - Olivier Andrieu                */
/* Distributed under the terms of the GPL version 3         */


#include <gsl/gsl_errno.h>
#include <gsl/gsl_interp.h>

#include <caml/alloc.h>
#include <caml/memory.h>
#include <caml/fail.h>

#include "wrappers.h"

static const gsl_interp_type *interp_type_of_val(value t)
{
  const gsl_interp_type* interp_type[] = {
    gsl_interp_linear, gsl_interp_polynomial,
    gsl_interp_cspline, gsl_interp_cspline_periodic,
    gsl_interp_akima, gsl_interp_akima_periodic };
  return interp_type[Int_val(t)];
}

#define Interp_val(v)       ((gsl_interp *)Field((v), 0))
#define InterpAccel_val(v)  ((gsl_interp_accel *)Field((v), 0))

CAMLprim value ml_gsl_interp_alloc(value type, value size)
{
  value r;
  gsl_interp *i=gsl_interp_alloc(interp_type_of_val(type), Int_val(size));
  Abstract_ptr(r, i);
  return r;
}

CAMLprim value ml_gsl_interp_free(value i)
{
  gsl_interp_free(Interp_val(i));
  return Val_unit;
}

CAMLprim value ml_gsl_interp_init(value i, value x, value y, value size)
{
  gsl_interp_init(Interp_val(i), Double_array_val(x),
		  Double_array_val(y), Int_val(size));
  return Val_unit;
}

CAMLprim value ml_gsl_interp_name(value i)
{
  return copy_string(gsl_interp_name(Interp_val(i)));
}

CAMLprim value ml_gsl_interp_min_size(value i)
{
  return Val_int(gsl_interp_min_size(Interp_val(i)));
}

CAMLprim value ml_gsl_interp_accel_alloc(value unit)
{
  value r;
  Abstract_ptr(r, gsl_interp_accel_alloc());
  return r;
}

CAMLprim value ml_gsl_interp_accel_free(value ia)
{
  gsl_interp_accel_free(InterpAccel_val(ia));
  return Val_unit;
}

CAMLprim value ml_gsl_interp_eval(value i, value xa, value ya, value x, value A)
{
  return caml_copy_double(gsl_interp_eval(Interp_val(i),
				     Double_array_val(xa),
				     Double_array_val(ya),
				     Double_val(x),
				     InterpAccel_val(A)));
}

CAMLprim value ml_gsl_interp_eval_deriv(value i, value xa, value ya, 
					value x, value A)
{
  return caml_copy_double(gsl_interp_eval_deriv(Interp_val(i),
					   Double_array_val(xa),
					   Double_array_val(ya),
					   Double_val(x),
					   InterpAccel_val(A)));
}

CAMLprim value ml_gsl_interp_eval_deriv2(value i, value xa, value ya, 
					 value x, value A)
{
  return caml_copy_double(gsl_interp_eval_deriv2(Interp_val(i),
					    Double_array_val(xa),
					    Double_array_val(ya),
					    Double_val(x),
					    InterpAccel_val(A)));
}

CAMLprim value ml_gsl_interp_eval_integ(value i, value xa, value ya, 
					value a, value b, value A)
{
  return caml_copy_double(gsl_interp_eval_integ(Interp_val(i),
					   Double_array_val(xa),
					   Double_array_val(ya),
					   Double_val(a), Double_val(b),
					   InterpAccel_val(A)));
}

CAMLprim value ml_gsl_interp_eval_integ_bc(value *args, int nb)
{
  return ml_gsl_interp_eval_integ(args[0], args[1], args[2],
				  args[3], args[4], args[5]);
}

CAMLprim value ml_gsl_interp_eval_array(value i, value xa, value ya)
{
  mlsize_t lx = Double_array_length(xa);
  mlsize_t ly = Double_array_length(ya);
  mlsize_t j;
  gsl_interp *c_i = Interp_val(Field(i, 0));
  gsl_interp_accel *c_A = InterpAccel_val(Field(i, 1));
  double *c_x = Double_array_val(Field(i, 2));
  double *c_y = Double_array_val(Field(i, 3));
  double *c_xa = Double_array_val(xa) ;
  double *c_ya = Double_array_val(ya) ;
  if(lx != ly)
    GSL_ERROR("array sizes differ", GSL_EBADLEN);
  for(j=0;j<lx;j++)
    gsl_interp_eval_e(c_i, c_x, c_y, c_xa[j], c_A, &c_ya[j]);
  return Val_unit;
}
