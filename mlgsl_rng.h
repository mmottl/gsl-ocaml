/* gsl-ocaml - OCaml interface to GSL                        */
/* Copyright (©) 2002-2005 - Olivier Andrieu                */
/* distributed under the terms of the GPL version 2         */

#include <caml/mlvalues.h>
#include <gsl/gsl_rng.h>

#define Rng_val(v) ((gsl_rng *)(Field(v, 0)))
