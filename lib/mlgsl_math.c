/* gsl-ocaml - OCaml interface to GSL                       */
/* Copyright (©) 2002-2005 - Olivier Andrieu                */
/* Distributed under the terms of the LGPL version 2.1      */

#include <gsl/gsl_math.h>

#include <caml/alloc.h>
#include "wrappers.h"


ML1(gsl_log1p, Double_val, copy_double)
ML1(gsl_expm1, Double_val, copy_double)
ML2(gsl_hypot, Double_val, Double_val, copy_double)
ML1(gsl_acosh, Double_val, copy_double)
ML1(gsl_asinh, Double_val, copy_double)
ML1(gsl_atanh, Double_val, copy_double)

ML3(gsl_fcmp, Double_val, Double_val, Double_val, Val_int)
