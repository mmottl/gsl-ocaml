/* gsl-ocaml - OCaml interface to GSL                       */
/* Copyright (©) 2002-2005 - Olivier Andrieu                */
/* Distributed under the terms of the LGPL version 2.1      */


#include <gsl/gsl_errno.h>
#include <gsl/gsl_statistics_double.h>

#include <caml/mlvalues.h>
#include <caml/fail.h>

#include "wrappers.h"

static inline void check_array_size(value a, value b)
{
  if(Double_array_length(a) != Double_array_length(b))
    GSL_ERROR_VOID("array sizes differ", GSL_EBADLEN);
}

CAMLprim value ml_gsl_stats_mean(value ow, value data)
{
  size_t len = Double_array_length(data);
  double result;
  if(ow == Val_none)
    result = gsl_stats_mean(Double_array_val(data), 1, len);
  else {
    value w = Unoption(ow);
    check_array_size(data, w);
    result = gsl_stats_wmean(Double_array_val(w), 1, 
			     Double_array_val(data), 1, len);
  }
  return copy_double(result);
}

CAMLprim value ml_gsl_stats_variance(value ow, value omean, value data)
{
  size_t len = Double_array_length(data);
  double result;
  if(ow == Val_none)
    if(omean == Val_none)
      result = gsl_stats_variance(Double_array_val(data), 1, len);
    else
      result = gsl_stats_variance_m(Double_array_val(data), 1, len, 
				    Double_val(Unoption(omean)));
  else {
    value w = Unoption(ow);
    check_array_size(data, w);
    if(omean == Val_none)
      result = gsl_stats_wvariance(Double_array_val(w), 1, 
				   Double_array_val(data), 1, len);
    else
      result = gsl_stats_wvariance_m(Double_array_val(w), 1, 
				     Double_array_val(data), 1, len, 
				     Double_val(Unoption(omean)));
  }
  return copy_double(result);
}

CAMLprim value ml_gsl_stats_sd(value ow, value omean, value data)
{
  size_t len = Double_array_length(data);
  double result;
  if(ow == Val_none)
    if(omean == Val_none)
      result = gsl_stats_sd(Double_array_val(data), 1, len);
    else
      result = gsl_stats_sd_m(Double_array_val(data), 1, len, 
			      Double_val(Unoption(omean)));
  else {
    value w = Unoption(ow);
    check_array_size(data, w);
    if(omean == Val_none)
      result = gsl_stats_wsd(Double_array_val(w), 1, 
			     Double_array_val(data), 1, len);
    else
      result = gsl_stats_wsd_m(Double_array_val(w), 1, 
			       Double_array_val(data), 1, len, 
			       Double_val(Unoption(omean)));
  }
  return copy_double(result);
}

CAMLprim value ml_gsl_stats_variance_with_fixed_mean(value ow,
						     value mean, value data)
{
  size_t len = Double_array_length(data);
  double result;
  if(ow == Val_none)
    result = gsl_stats_variance_with_fixed_mean(Double_array_val(data), 
						1, len, Double_val(mean));
  else {
    value w = Unoption(ow);
    check_array_size(data, w);
    result = gsl_stats_wvariance_with_fixed_mean(Double_array_val(w), 1,
						 Double_array_val(data), 1,
						 len, Double_val(mean));
  }
  return copy_double(result);
}

CAMLprim value ml_gsl_stats_sd_with_fixed_mean(value ow,
						     value mean, value data)
{
  size_t len = Double_array_length(data);
  double result;
  if(ow == Val_none)
    result = gsl_stats_sd_with_fixed_mean(Double_array_val(data), 
					  1, len, Double_val(mean));
  else {
    value w = Unoption(ow);
    check_array_size(data, w);
    result = gsl_stats_wsd_with_fixed_mean(Double_array_val(w), 1, 
					   Double_array_val(data), 1,
					   len, Double_val(mean));
  }
  return copy_double(result);
}

CAMLprim value ml_gsl_stats_absdev(value ow, value omean, value data)
{
  size_t len = Double_array_length(data);
  double result;
  if(ow == Val_none)
    if(omean == Val_none)
      result = gsl_stats_absdev(Double_array_val(data), 1, len);
    else
      result = gsl_stats_absdev_m(Double_array_val(data), 1, len, 
				  Double_val(Unoption(omean)));
  else {
    value w = Unoption(ow);
    check_array_size(data, w);
    if(omean == Val_none)
      result = gsl_stats_wabsdev(Double_array_val(w), 1, 
				 Double_array_val(data), 1, len);
    else
      result = gsl_stats_wabsdev_m(Double_array_val(w), 1, 
				   Double_array_val(data), 1, len, 
				   Double_val(Unoption(omean)));
  }
  return copy_double(result);
}

CAMLprim value ml_gsl_stats_skew(value ow, value data)
{
  size_t len = Double_array_length(data);
  double result;
  if(ow == Val_none)
    result = gsl_stats_skew(Double_array_val(data), 1, len);
  else {
    value w = Unoption(ow);
    check_array_size(data, w);
    result = gsl_stats_wskew(Double_array_val(w), 1, 
			     Double_array_val(data), 1, len);
  }
  return copy_double(result);
}

CAMLprim value ml_gsl_stats_skew_m_sd(value ow, value mean, 
				      value sd, value data)
{
  size_t len = Double_array_length(data);
  double result;
  if(ow == Val_none)
    result = gsl_stats_skew_m_sd(Double_array_val(data), 1, len,
				 Double_val(mean), Double_val(sd));
  else {
    value w = Unoption(ow);
    check_array_size(data, w);
    result = gsl_stats_wskew_m_sd(Double_array_val(w), 1,
				  Double_array_val(data), 1, len,
				  Double_val(mean), Double_val(sd));
  }
  return copy_double(result);
}

CAMLprim value ml_gsl_stats_kurtosis(value ow, value data)
{
  size_t len = Double_array_length(data);
  double result;
  if(ow == Val_none)
    result = gsl_stats_kurtosis(Double_array_val(data), 1, len);
  else {
    value w = Unoption(ow);
    check_array_size(data, w);
    result = gsl_stats_wkurtosis(Double_array_val(w), 1,
				 Double_array_val(data), 1, len);
  }
  return copy_double(result);
}

CAMLprim value ml_gsl_stats_kurtosis_m_sd(value ow, value mean, 
					  value sd, value data)
{
  size_t len = Double_array_length(data);
  double result;
  if(ow == Val_none)
    result = gsl_stats_kurtosis_m_sd(Double_array_val(data), 1, len,
				     Double_val(mean), Double_val(sd));
  else {
    value w = Unoption(ow);
    check_array_size(data, w);
    result = gsl_stats_wkurtosis_m_sd(Double_array_val(w), 1,
				      Double_array_val(data), 1, len,
				      Double_val(mean), Double_val(sd));
  }
  return copy_double(result);
}

CAMLprim value ml_gsl_stats_lag1_autocorrelation(value omean, value data)
{
  size_t len = Double_array_length(data);
  double result;
  if(omean == Val_none)
    result = gsl_stats_lag1_autocorrelation(Double_array_val(data), 1, len);
  else
    result = gsl_stats_lag1_autocorrelation_m(Double_array_val(data), 1, len, 
					      Double_val(Unoption(omean)));
  return copy_double(result);
}

CAMLprim value ml_gsl_stats_covariance(value data1, value data2)
{
  size_t len = Double_array_length(data1);
  double result;
  check_array_size(data1, data2);
  result = gsl_stats_covariance(Double_array_val(data1), 1,
				Double_array_val(data2), 1, len);
  return copy_double(result);
}

CAMLprim value ml_gsl_stats_covariance_m(value mean1, value data1,
					 value mean2, value data2)
{
  size_t len = Double_array_length(data1);
  double result;
  check_array_size(data1, data2);
  result = gsl_stats_covariance_m(Double_array_val(data1), 1, 
				  Double_array_val(data2), 1, len,
				  Double_val(mean1), Double_val(mean2));
  return copy_double(result);
}

CAMLprim value ml_gsl_stats_max(value data)
{
  size_t len = Double_array_length(data);
  double result = gsl_stats_max(Double_array_val(data), 1, len);
  return copy_double(result);
}

CAMLprim value ml_gsl_stats_min(value data)
{
  size_t len = Double_array_length(data);
  double result = gsl_stats_min(Double_array_val(data), 1, len);
  return copy_double(result);
}

CAMLprim value ml_gsl_stats_minmax(value data)
{
  size_t len = Double_array_length(data);
  double mi, ma;
  gsl_stats_minmax(&mi, &ma, Double_array_val(data), 1, len);
  return copy_two_double(mi, ma);
}

CAMLprim value ml_gsl_stats_max_index(value data)
{
  size_t len = Double_array_length(data);
  size_t result = gsl_stats_max_index(Double_array_val(data), 1, len);
  return Val_int(result);
}

CAMLprim value ml_gsl_stats_min_index(value data)
{
  size_t len = Double_array_length(data);
  size_t result = gsl_stats_min_index(Double_array_val(data), 1, len);
  return Val_int(result);
}

CAMLprim value ml_gsl_stats_minmax_index(value data)
{
  size_t len = Double_array_length(data);
  size_t mi, ma;
  value r;
  gsl_stats_minmax_index(&mi, &ma, Double_array_val(data), 1, len);
  r = alloc_small(2, 0);
  Field(r, 0) = Val_int(mi);
  Field(r, 1) = Val_int(ma);
  return r;
}

CAMLprim value ml_gsl_stats_quantile_from_sorted_data(value data, value f)
{
  size_t len = Double_array_length(data);
  double r = gsl_stats_quantile_from_sorted_data(Double_array_val(data),
						 1, len, Double_val(f));
  return copy_double(r);
}

CAMLprim value ml_gsl_stats_correlation(value data1, value data2)
{
  size_t len = Double_array_length(data1);
  check_array_size(data1, data2);
  double r = gsl_stats_correlation(Double_array_val(data1), 1,
                                   Double_array_val(data2), 1, len);
  return copy_double(r);
}
