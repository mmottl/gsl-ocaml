/* gsl-ocaml - OCaml interface to GSL                       */
/* Copyright (©) 2002-2012 - Olivier Andrieu                */
/* Distributed under the terms of the GPL version 3         */

#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/memory.h>
#include <caml/fail.h>

#include <gsl/gsl_poly.h>

#include "wrappers.h"

CAMLprim value ml_gsl_poly_eval(value c, value x)
{
  int len = Double_array_length(c);
  return caml_copy_double(gsl_poly_eval(Double_array_val(c), len, Double_val(x)));
}

CAMLprim value ml_gsl_poly_solve_quadratic(value a, value b, value c)
{
  double x0, x1;
  int n ;
  n = gsl_poly_solve_quadratic(Double_val(a), Double_val(b), 
			       Double_val(c), &x0, &x1);
  {
    CAMLparam0();
    CAMLlocal1(r);
    if(n == 0)
      r = Val_int(0);
    else{
      r = alloc(2, 0);
      Store_field(r, 0, caml_copy_double(x0));
      Store_field(r, 1, caml_copy_double(x1));
    } ;
    CAMLreturn(r);
  }
}

CAMLprim value ml_gsl_poly_complex_solve_quadratic(value a, value b, value c)
{
  gsl_complex z0, z1;
  gsl_poly_complex_solve_quadratic(Double_val(a), Double_val(b),
				   Double_val(c), &z0, &z1);

  { 
    CAMLparam0();
    CAMLlocal3(r,rz0,rz1);
    rz0 = caml_alloc_small(2 * Double_wosize, Double_array_tag);
    Store_double_field(rz0, 0, GSL_REAL(z0));
    Store_double_field(rz0, 1, GSL_IMAG(z0));
    rz1 = caml_alloc_small(2 * Double_wosize, Double_array_tag);
    Store_double_field(rz1, 0, GSL_REAL(z1));
    Store_double_field(rz1, 1, GSL_IMAG(z1));
    r   = caml_alloc_small(2, 0);
    Field(r,0) = rz0 ;
    Field(r,1) = rz1 ; 
    CAMLreturn(r);
  }
}

CAMLprim value ml_gsl_poly_solve_cubic(value a, value b, value c)
{
  double x0, x1, x2;
  int n ;
  n = gsl_poly_solve_cubic(Double_val(a), Double_val(b), 
			   Double_val(c), &x0, &x1, &x2);

  {
    CAMLparam0();
    CAMLlocal1(r);
    r = Val_int(0);		/* to silence compiler warnings */
    switch(n){
    case 0:
      break;
    case 1:
      r = alloc(1, 0);
      Store_field(r, 0, caml_copy_double(x0));
      break;
    case 3:
      r = alloc(3, 1);
      Store_field(r, 0, caml_copy_double(x0));
      Store_field(r, 1, caml_copy_double(x1));
      Store_field(r, 2, caml_copy_double(x2));
    } ;
    CAMLreturn(r);
  };
}

CAMLprim value ml_gsl_poly_complex_solve_cubic(value a, value b, value c)
{
  gsl_complex z0, z1, z2;
  gsl_poly_complex_solve_cubic(Double_val(a), Double_val(b), 
			       Double_val(c), &z0, &z1, &z2);
  {
    CAMLparam0();
    CAMLlocal4(r,rz0, rz1, rz2);
    rz0 = caml_alloc_small(2 * Double_wosize, Double_array_tag);
    Store_double_field(rz0, 0, GSL_REAL(z0));
    Store_double_field(rz0, 1, GSL_IMAG(z0));
    rz1 = caml_alloc_small(2 * Double_wosize, Double_array_tag);
    Store_double_field(rz1, 0, GSL_REAL(z1));
    Store_double_field(rz1, 1, GSL_IMAG(z1));
    rz2 = caml_alloc_small(2 * Double_wosize, Double_array_tag);
    Store_double_field(rz2, 0, GSL_REAL(z2));
    Store_double_field(rz2, 1, GSL_IMAG(z2));
    r   = caml_alloc_small(3, 0);
    Field(r,0) = rz0 ;
    Field(r,1) = rz1 ;
    Field(r,2) = rz2 ;
    CAMLreturn(r);
  }
}

#define POLY_WS(v) (gsl_poly_complex_workspace *)Field((v), 0)
ML1_alloc(gsl_poly_complex_workspace_alloc, Int_val, Abstract_ptr)
ML1(gsl_poly_complex_workspace_free, POLY_WS, Unit)

CAMLprim value ml_gsl_poly_complex_solve(value a, value ws, value r)
{
  gsl_poly_complex_solve(Double_array_val(a), Double_array_length(a),
			 POLY_WS(ws), (gsl_complex_packed_ptr) r);
  return Val_unit;
}
