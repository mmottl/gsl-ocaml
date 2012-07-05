/* gsl-ocaml - OCaml interface to GSL                       */
/* Copyright (©) 2002-2005 - Olivier Andrieu                */
/* Distributed under the terms of the GPL version 3         */


#include <gsl/gsl_histogram.h>

#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/memory.h>
#include <caml/bigarray.h>

#include "wrappers.h"

static inline void histo_of_val(gsl_histogram *h, value vh)
{
  h->n = Int_val(Field(vh, 0));
  h->range = Double_array_val(Field(vh, 1));
  h->bin   = Double_array_val(Field(vh, 2));
}

CAMLprim value ml_gsl_histogram_set_ranges(value vh, value range)
{
  gsl_histogram h;
  histo_of_val(&h, vh);
  gsl_histogram_set_ranges(&h, Double_array_val(range), 
			   Double_array_length(range));
  return Val_unit;
}

CAMLprim value ml_gsl_histogram_set_ranges_uniform(value vh, 
						   value xmin, value xmax)
{
  gsl_histogram h;
  histo_of_val(&h, vh);
  gsl_histogram_set_ranges_uniform(&h, Double_val(xmin), 
				   Double_val(xmax));
  return Val_unit;
}

CAMLprim value ml_gsl_histogram_accumulate(value vh, value ow, value x)
{
  gsl_histogram h;
  double w = Opt_arg(ow, Double_val, 1.);
  histo_of_val(&h, vh);
  gsl_histogram_accumulate(&h, Double_val(x), w);
  return Val_unit;
}

CAMLprim value ml_gsl_histogram_find(value vh, value x)
{
  gsl_histogram h;
  size_t i;
  histo_of_val(&h, vh);
  gsl_histogram_find(&h, Double_val(x), &i);
  return Val_int(i);
}

CAMLprim value ml_gsl_histogram_max_val(value vh)
{
  gsl_histogram h;
  histo_of_val(&h, vh);
  return copy_double(gsl_histogram_max_val(&h));
}

CAMLprim value ml_gsl_histogram_max_bin(value vh)
{
  gsl_histogram h;
  histo_of_val(&h, vh);
  return Val_int(gsl_histogram_max_bin(&h));
}

CAMLprim value ml_gsl_histogram_min_val(value vh)
{
  gsl_histogram h;
  histo_of_val(&h, vh);
  return copy_double(gsl_histogram_min_val(&h));
}

CAMLprim value ml_gsl_histogram_min_bin(value vh)
{
  gsl_histogram h;
  histo_of_val(&h, vh);
  return Val_int(gsl_histogram_min_bin(&h));
}

CAMLprim value ml_gsl_histogram_mean(value vh)
{
  gsl_histogram h;
  histo_of_val(&h, vh);
  return copy_double(gsl_histogram_mean(&h));
}

CAMLprim value ml_gsl_histogram_sigma(value vh)
{
  gsl_histogram h;
  histo_of_val(&h, vh);
  return copy_double(gsl_histogram_sigma(&h));
}

CAMLprim value ml_gsl_histogram_sum(value vh)
{
  gsl_histogram h;
  histo_of_val(&h, vh);
  return copy_double(gsl_histogram_sum(&h));
}

CAMLprim value ml_gsl_histogram_equal_bins_p(value vh1, value vh2)
{
  gsl_histogram h1, h2;
  histo_of_val(&h1, vh1);
  histo_of_val(&h2, vh2);
  return Val_bool(gsl_histogram_equal_bins_p(&h1, &h2));
}

CAMLprim value ml_gsl_histogram_add(value vh1, value vh2)
{
  gsl_histogram h1, h2;
  histo_of_val(&h1, vh1);
  histo_of_val(&h2, vh2);
  gsl_histogram_add(&h1, &h2);
  return Val_unit;
}

CAMLprim value ml_gsl_histogram_sub(value vh1, value vh2)
{
  gsl_histogram h1, h2;
  histo_of_val(&h1, vh1);
  histo_of_val(&h2, vh2);
  gsl_histogram_sub(&h1, &h2);
  return Val_unit;
}

CAMLprim value ml_gsl_histogram_mul(value vh1, value vh2)
{
  gsl_histogram h1, h2;
  histo_of_val(&h1, vh1);
  histo_of_val(&h2, vh2);
  gsl_histogram_mul(&h1, &h2);
  return Val_unit;
}

CAMLprim value ml_gsl_histogram_div(value vh1, value vh2)
{
  gsl_histogram h1, h2;
  histo_of_val(&h1, vh1);
  histo_of_val(&h2, vh2);
  gsl_histogram_div(&h1, &h2);
  return Val_unit;
}

CAMLprim value ml_gsl_histogram_scale(value vh, value s)
{
  gsl_histogram h;
  histo_of_val(&h, vh);
  gsl_histogram_scale(&h, Double_val(s));
  return Val_unit;
}

CAMLprim value ml_gsl_histogram_shift(value vh, value s)
{
  gsl_histogram h;
  histo_of_val(&h, vh);
  gsl_histogram_shift(&h, Double_val(s));
  return Val_unit;
}

static inline void histopdf_of_val(gsl_histogram_pdf *p, value vh)
{
  p->n = Int_val(Field(vh, 0));
  p->range = Double_array_val(Field(vh, 1));
  p->sum   = Double_array_val(Field(vh, 2));
}

CAMLprim value ml_gsl_histogram_pdf_init(value vp, value vh)
{
  gsl_histogram_pdf p;
  gsl_histogram h;
  histopdf_of_val(&p, vp);
  histo_of_val(&h, vh);
  gsl_histogram_pdf_init(&p, &h);
  return Val_unit;
}

CAMLprim value ml_gsl_histogram_pdf_sample(value vp, value r)
{
  gsl_histogram_pdf p;
  histopdf_of_val(&p, vp);
  return copy_double(gsl_histogram_pdf_sample(&p, r));
}
