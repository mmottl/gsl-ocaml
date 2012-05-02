/* gsl-ocaml - OCaml interface to GSL                        */
/* Copyright (©) 2002-2005 - Olivier Andrieu                */
/* distributed under the terms of the GPL version 2         */

#include <caml/fail.h>
#include <caml/memory.h>
#include <caml/callback.h>

#include <gsl/gsl_fft.h>
#include <gsl/gsl_fft_complex.h>
#include <gsl/gsl_fft_halfcomplex.h>
#include <gsl/gsl_fft_real.h>

#include "wrappers.h"

enum mlgsl_fft_array_layout {
  LAYOUT_REAL    = 0 ,
  LAYOUT_HC      = 1 ,
  LAYOUT_HC_RAD2 = 2 ,
  LAYOUT_C       = 3 ,
} ;

static void check_layout(value fft_arr, 
			 enum mlgsl_fft_array_layout layout)
{
  static value *layout_exn;
  if(Int_val(Field(fft_arr, 0)) != layout) { 
    if(!layout_exn) {
      layout_exn = caml_named_value("mlgsl_layout_exn");
      if(!layout_exn) /* Gromeleu */
	invalid_argument("wrong fft_array layout");
    }
    raise_constant(*layout_exn);
  }
}

static inline void update_layout(value fft_arr, 
				 enum mlgsl_fft_array_layout layout)
{
  Store_field(fft_arr, 0, Val_int(layout));
}



/* WORKSPACE AND WAVETABLES */

#define GSL_REAL_WS(v)        ((gsl_fft_real_workspace *)Field((v),0))
#define GSL_COMPLEX_WS(v)     ((gsl_fft_complex_workspace *)Field((v),0))
#define GSL_REAL_WT(v)        ((gsl_fft_real_wavetable *)Field((v),0))
#define GSL_HALFCOMPLEX_WT(v) ((gsl_fft_halfcomplex_wavetable *)Field((v),0))
#define GSL_COMPLEX_WT(v)     ((gsl_fft_complex_wavetable *)Field((v),0))

ML1_alloc(gsl_fft_real_workspace_alloc, Int_val, Abstract_ptr)
ML1_alloc(gsl_fft_complex_workspace_alloc, Int_val, Abstract_ptr)
ML1_alloc(gsl_fft_real_wavetable_alloc, Int_val, Abstract_ptr)
ML1_alloc(gsl_fft_halfcomplex_wavetable_alloc, Int_val, Abstract_ptr)
ML1_alloc(gsl_fft_complex_wavetable_alloc, Int_val, Abstract_ptr)

ML1(gsl_fft_real_workspace_free, GSL_REAL_WS, Unit)
ML1(gsl_fft_complex_workspace_free, GSL_COMPLEX_WS, Unit)
ML1(gsl_fft_real_wavetable_free, GSL_REAL_WT, Unit)
ML1(gsl_fft_halfcomplex_wavetable_free, GSL_HALFCOMPLEX_WT, Unit)
ML1(gsl_fft_complex_wavetable_free, GSL_COMPLEX_WT, Unit)


/* UNPACKING ROUTINES */

CAMLprim value ml_gsl_fft_real_unpack(value stride, value r, value c)
{
  const size_t c_stride = Opt_arg(stride, Int_val, 1);
  const size_t n = Double_array_length(r);
  gsl_fft_real_unpack(Double_array_val(r), Double_array_val(c), c_stride, n) ;
  return Val_unit;
}

CAMLprim value ml_gsl_fft_halfcomplex_unpack(value stride, value hc, value c)
{
  const size_t c_stride = Opt_arg(stride, Int_val, 1);
  const size_t n = Double_array_length(hc);
  gsl_fft_halfcomplex_unpack(Double_array_val(hc), Double_array_val(c),
			     c_stride, n) ;
  return Val_unit;
}

CAMLprim value ml_gsl_fft_halfcomplex_unpack_rad2(value stride, value hc, value c)
{
  const size_t c_stride = Opt_arg(stride, Int_val ,1);
  const size_t n = Double_array_length(hc);
  gsl_fft_halfcomplex_radix2_unpack(Double_array_val(hc), Double_array_val(c),
				    c_stride, n) ;
  return Val_unit;
}



/* REAL AND HALFCOMPLEX MIXED-RADIX FFT */

CAMLprim value ml_gsl_fft_real_transform(value stride, value fft_arr, value wt, value ws)
{
  value data = Field(fft_arr, 1);
  const size_t c_stride = Opt_arg(stride, Int_val, 1);
  const size_t n = Double_array_length(data);

  check_layout(fft_arr, LAYOUT_REAL);
  gsl_fft_real_transform(Double_array_val(data), c_stride, n,
			 GSL_REAL_WT(wt), GSL_REAL_WS(ws)) ;
  update_layout(fft_arr, LAYOUT_HC);

  return Val_unit;
}

CAMLprim value ml_gsl_fft_halfcomplex_transform(value stride, value fft_arr, 
				       value wt, value ws)
{
  value data = Field(fft_arr, 1);
  const size_t c_stride = Opt_arg(stride, Int_val, 1);
  const size_t n = Double_array_length(data);

  check_layout(fft_arr, LAYOUT_HC);
  gsl_fft_halfcomplex_transform(Double_array_val(data), c_stride, n,
				GSL_HALFCOMPLEX_WT(wt), 
				GSL_REAL_WS(ws)) ;

  return Val_unit;
}

CAMLprim value ml_gsl_fft_halfcomplex_backward(value stride, value fft_arr,
				      value wt, value ws)
{
  value data = Field(fft_arr, 1);
  const size_t c_stride = Opt_arg(stride, Int_val, 1);
  const size_t n = Double_array_length(data);

  check_layout(fft_arr, LAYOUT_HC);
  gsl_fft_halfcomplex_backward(Double_array_val(data), c_stride, n,
			       GSL_HALFCOMPLEX_WT(wt), 
			       GSL_REAL_WS(ws)) ;
  update_layout(fft_arr, LAYOUT_REAL);

  return Val_unit;
}

CAMLprim value ml_gsl_fft_halfcomplex_inverse(value stride, value fft_arr,
				     value wt, value ws)
{
  value data = Field(fft_arr, 1);
  const size_t c_stride = Opt_arg(stride, Int_val, 1);
  const size_t n = Double_array_length(data);

  check_layout(fft_arr, LAYOUT_HC);
  gsl_fft_halfcomplex_inverse(Double_array_val(data), c_stride, n,
			      GSL_HALFCOMPLEX_WT(wt), 
			      GSL_REAL_WS(ws)) ;
  update_layout(fft_arr, LAYOUT_REAL);

  return Val_unit;
}



/* REAL AND HALFCOMPLEX RADIX2 FFT */

CAMLprim value ml_gsl_fft_real_radix2_transform(value stride, value fft_arr)
{
  value data = Field(fft_arr, 1);
  size_t N = Double_array_length(data);
  size_t c_stride = Opt_arg(stride, Int_val, 1);

  check_layout(fft_arr, LAYOUT_REAL);
  gsl_fft_real_radix2_transform(Double_array_val(data), c_stride, N);
  update_layout(fft_arr, LAYOUT_HC_RAD2);

  return Val_unit;
}

CAMLprim value ml_gsl_fft_halfcomplex_radix2_transform(value stride, value fft_arr)
{
  value data = Field(fft_arr, 1);
  size_t N = Double_array_length(data);
  size_t c_stride = Opt_arg(stride, Int_val, 1);

  check_layout(fft_arr, LAYOUT_HC_RAD2);
  gsl_fft_halfcomplex_radix2_transform(Double_array_val(data), c_stride, N);

  return Val_unit;
}

CAMLprim value ml_gsl_fft_halfcomplex_radix2_backward(value stride, value fft_arr)
{
  value data = Field(fft_arr, 1);
  size_t N = Double_array_length(data);
  size_t c_stride = Opt_arg(stride, Int_val, 1);

  check_layout(fft_arr, LAYOUT_HC_RAD2);
  gsl_fft_halfcomplex_radix2_backward(Double_array_val(data), 
				      c_stride, N);
  update_layout(fft_arr, LAYOUT_REAL);

  return Val_unit;
}

CAMLprim value ml_gsl_fft_halfcomplex_radix2_inverse(value stride, value fft_arr)
{
  value data = Field(fft_arr, 1);
  size_t N = Double_array_length(data);
  size_t c_stride = Opt_arg(stride, Int_val, 1);

  check_layout(fft_arr, LAYOUT_HC_RAD2);
  gsl_fft_halfcomplex_radix2_inverse(Double_array_val(data), c_stride, N);
  update_layout(fft_arr, LAYOUT_REAL);

  return Val_unit;
}



/* COMPLEX RADIX-2 FFT */

CAMLprim value ml_gsl_fft_complex_rad2_forward(value dif, value stride, value data)
{
  size_t N = Double_array_length(data);
  size_t c_stride = Opt_arg(stride, Int_val, 1);
  int c_dif = Opt_arg(dif, Bool_val, 0);

  if(c_dif)
    gsl_fft_complex_radix2_dif_forward(Double_array_val(data), c_stride, N);
  else
    gsl_fft_complex_radix2_forward(Double_array_val(data), c_stride, N);
  
  return Val_unit;
}

CAMLprim value ml_gsl_fft_complex_rad2_transform(value dif, value stride, 
					value data, value sign)
{
  size_t N = Double_array_length(data);
  size_t c_stride = Opt_arg(stride, Int_val, 1);
  int c_dif = Opt_arg(dif, Bool_val, 0);
  gsl_fft_direction c_sign =
    (Int_val(sign)==0) ? gsl_fft_forward : gsl_fft_backward;

  if(c_dif)
    gsl_fft_complex_radix2_dif_transform(Double_array_val(data), c_stride, 
					 N, c_sign);
  else
    gsl_fft_complex_radix2_transform(Double_array_val(data), c_stride, 
				     N, c_sign);
  
  return Val_unit;
}

CAMLprim value ml_gsl_fft_complex_rad2_backward(value dif, value stride, value data)
{
  size_t N = Double_array_length(data);
  size_t c_stride = Opt_arg(stride, Int_val, 1);
  int c_dif = Opt_arg(dif, Bool_val, 0);

  if(c_dif)
    gsl_fft_complex_radix2_dif_backward(Double_array_val(data), c_stride, N);
  else
    gsl_fft_complex_radix2_backward(Double_array_val(data), c_stride, N);
  
  return Val_unit;
}

CAMLprim value ml_gsl_fft_complex_rad2_inverse(value dif, value stride, value data)
{
  size_t N = Double_array_length(data);
  size_t c_stride = Opt_arg(stride, Int_val, 1);
  int c_dif = Opt_arg(dif, Bool_val, 0);

  if(c_dif)
    gsl_fft_complex_radix2_dif_inverse(Double_array_val(data), c_stride, N);
  else
    gsl_fft_complex_radix2_inverse(Double_array_val(data), c_stride, N);

  return Val_unit;
}




/* COMPLEX MIXED RADIX FFT */

CAMLprim value ml_gsl_fft_complex_forward(value stride, value data, value wt, value ws)
{
  const size_t c_stride = Opt_arg(stride, Int_val, 1);
  const size_t n = Double_array_length(data) / 2;

  gsl_fft_complex_forward(Double_array_val(data), c_stride, n,
			  GSL_COMPLEX_WT(wt), GSL_COMPLEX_WS(ws)) ;
  return Val_unit;
}

CAMLprim value ml_gsl_fft_complex_transform(value stride, value data, 
				   value wt, value ws, value sign)
{
  const size_t c_stride = Opt_arg(stride, Int_val, 1);
  const size_t n = Double_array_length(data) / 2;
  gsl_fft_direction c_sign = 
    (Int_val(sign)==0) ? gsl_fft_forward : gsl_fft_backward;

  gsl_fft_complex_transform(Double_array_val(data), c_stride, n,
			    GSL_COMPLEX_WT(wt), 
			    GSL_COMPLEX_WS(ws), c_sign) ;

  return Val_unit;
}

CAMLprim value ml_gsl_fft_complex_backward(value stride, value data, 
				  value wt, value ws)
{
  const size_t c_stride = Opt_arg(stride, Int_val, 1);
  const size_t n = Double_array_length(data) / 2;

  gsl_fft_complex_backward(Double_array_val(data), c_stride, n,
			   GSL_COMPLEX_WT(wt), 
			   GSL_COMPLEX_WS(ws)) ;

  return Val_unit;
}

CAMLprim value ml_gsl_fft_complex_inverse(value stride, value data,
				 value wt, value ws)
{
  const size_t c_stride = Opt_arg(stride, Int_val ,1);
  const size_t n = Double_array_length(data) / 2;

  gsl_fft_complex_inverse(Double_array_val(data), c_stride, n,
			  GSL_COMPLEX_WT(wt), 
			  GSL_COMPLEX_WS(ws)) ;

  return Val_unit;
}
