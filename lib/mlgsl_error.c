/* gsl-ocaml - OCaml interface to GSL                       */
/* Copyright (©) 2002-2012 - Olivier Andrieu                */
/* Distributed under the terms of the GPL version 3         */

#include <gsl/gsl_errno.h>
#include <gsl/gsl_version.h>

#include <caml/alloc.h>
#include <caml/memory.h>
#include <caml/callback.h>
#include <caml/fail.h>

CAMLprim value ml_gsl_version(value unit)
{
  return copy_string(gsl_version);
}

CAMLprim value ml_gsl_strerror(value ml_errno)
{
  int c_errno = Int_val(ml_errno);
  int gsl_errno = (c_errno <= 1) ? (c_errno - 2) : (c_errno - 1) ;
  return copy_string(gsl_strerror(gsl_errno));
}

static value *ml_gsl_err_handler = NULL;

static void ml_gsl_error_handler(const char *reason, const char *file,
				 int line, int gsl_errno)
{
  CAMLparam0();
  CAMLlocal1(exn_msg);
  int ml_errno;

  if (0 < gsl_errno && gsl_errno <= GSL_EOF)
    ml_errno = gsl_errno + 1;
  else if (GSL_CONTINUE <= gsl_errno && gsl_errno <= GSL_FAILURE)
    ml_errno = gsl_errno + 2;
  else
    failwith("invalid GSL error code");

  exn_msg = copy_string(reason);
  caml_callback2(Field(*ml_gsl_err_handler,0), Val_int(ml_errno), exn_msg);

  CAMLreturn0;
}

CAMLprim value ml_gsl_error_init(value init)
{
  static gsl_error_handler_t *old;
  if(ml_gsl_err_handler == NULL)
    ml_gsl_err_handler = caml_named_value("mlgsl_err_handler");

  if (Bool_val(init)) {
    gsl_error_handler_t *prev;
    prev = gsl_set_error_handler(&ml_gsl_error_handler);
    if (prev != ml_gsl_error_handler)
      old = prev;
  }
  else
    gsl_set_error_handler(old);

  return Val_unit;
}
