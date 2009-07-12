/* ocamlgsl - OCaml interface to GSL                        */
/* Copyright (©) 2005 - Olivier Andrieu                     */
/* distributed under the terms of the GPL version 2         */

#include <caml/fail.h>
#include <caml/memory.h>
#include <caml/callback.h>
#include <caml/bigarray.h>

#include <gsl/gsl_sort_vector.h>

#include "wrappers.h"
#include "mlgsl_vector_double.h"
#include "mlgsl_permut.h"

CAMLprim value
ml_gsl_sort_vector (value v)
{
  _DECLARE_VECTOR(v);
  _CONVERT_VECTOR(v);
  gsl_sort_vector (&v_v);
  return Val_unit;
}

CAMLprim value
ml_gsl_sort_vector_index (value p, value v)
{
  GSL_PERMUT_OF_BIGARRAY(p);
  _DECLARE_VECTOR(v);
  _CONVERT_VECTOR(v);
  gsl_sort_vector_index (&perm_p, &v_v);
  return Val_unit;
}

CAMLprim value
ml_gsl_sort_vector_smallest (value dest, value v)
{
  _DECLARE_VECTOR(v);
  _CONVERT_VECTOR(v);
  gsl_sort_vector_smallest (Double_array_val (dest), Double_array_length (dest), &v_v);
  return Val_unit;
}

CAMLprim value
ml_gsl_sort_vector_largest (value dest, value v)
{
  _DECLARE_VECTOR(v);
  _CONVERT_VECTOR(v);
  gsl_sort_vector_largest (Double_array_val (dest), Double_array_length (dest), &v_v);
  return Val_unit;
}

CAMLprim value
ml_gsl_sort_vector_smallest_index (value p, value v)
{
  GSL_PERMUT_OF_BIGARRAY(p);
  _DECLARE_VECTOR(v);
  _CONVERT_VECTOR(v);
  gsl_sort_vector_smallest_index (perm_p.data, perm_p.size, &v_v);
  return Val_unit;
}

CAMLprim value
ml_gsl_sort_vector_largest_index (value p, value v)
{
  GSL_PERMUT_OF_BIGARRAY(p);
  _DECLARE_VECTOR(v);
  _CONVERT_VECTOR(v);
  gsl_sort_vector_largest_index (perm_p.data, perm_p.size, &v_v);
  return Val_unit;
}
