/* gsl-ocaml - OCaml interface to GSL                       */
/* Copyright (©) 2002-2005 - Olivier Andrieu                */
/* Distributed under the terms of the LGPL version 2.1      */


#include <caml/bigarray.h>

#define GSL_PERMUT_OF_BIGARRAY(arr) \
  struct caml_bigarray *bigarr_##arr = Bigarray_val(arr); \
  gsl_permutation perm_##arr = { \
      /*.size =*/ bigarr_##arr->dim[0], \
      /*.data =*/ bigarr_##arr->data }

