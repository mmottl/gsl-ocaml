/* gsl-ocaml - OCaml interface to GSL                       */
/* Copyright (©) 2002-2012 - Olivier Andrieu                */
/* Distributed under the terms of the GPL version 3         */


#include <caml/bigarray.h>

#define GSL_PERMUT_OF_BIGARRAY(arr) \
  struct caml_ba_array *bigarr_##arr = Caml_ba_array_val(arr); \
  gsl_permutation perm_##arr = { \
      /*.size =*/ bigarr_##arr->dim[0], \
      /*.data =*/ bigarr_##arr->data }

