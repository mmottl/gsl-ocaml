/* gsl-ocaml - OCaml interface to GSL                       */
/* Copyright (©) 2002-2012 - Olivier Andrieu                */
/* Distributed under the terms of the GPL version 3         */

#include <gsl/gsl_qrng.h>

#include "wrappers.h"

static inline const gsl_qrng_type *qrngtype_val(value v) {
  const gsl_qrng_type *qrng_type[] = {gsl_qrng_niederreiter_2, gsl_qrng_sobol};
  return qrng_type[Int_val(v)];
}

#define Qrng_val(v) (gsl_qrng *)Field((v), 0)

CAMLprim value ml_gsl_qrng_alloc(value type, value dim) {
  value r;
  Abstract_ptr(r, gsl_qrng_alloc(qrngtype_val(type), Int_val(dim)));
  return r;
}

ML1(gsl_qrng_free, Qrng_val, Unit)
ML1(gsl_qrng_init, Qrng_val, Unit)

CAMLprim value ml_gsl_qrng_dimension(value qrng) {
  return Val_int((Qrng_val(qrng))->dimension);
}

CAMLprim value ml_gsl_qrng_get(value qrng, value x) {
  if (Double_array_length(x) != (Qrng_val(qrng))->dimension)
    GSL_ERROR("wrong array size", GSL_EBADLEN);
  gsl_qrng_get(Qrng_val(qrng), Double_array_val(x));
  return Val_unit;
}

CAMLprim value ml_gsl_qrng_sample(value qrng) {
  gsl_qrng *q = Qrng_val(qrng);
  value arr = caml_alloc(q->dimension * Double_wosize, Double_array_tag);
  gsl_qrng_get(q, Double_array_val(arr));
  return arr;
}

ML1(gsl_qrng_name, Qrng_val, caml_copy_string)

CAMLprim value ml_gsl_qrng_memcpy(value src, value dst) {
  gsl_qrng_memcpy(Qrng_val(dst), Qrng_val(src));
  return Val_unit;
}

CAMLprim value ml_gsl_qrng_clone(value qrng) {
  value r;
  Abstract_ptr(r, gsl_qrng_clone(Qrng_val(qrng)));
  return r;
}
