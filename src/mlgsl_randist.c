/* gsl-ocaml - OCaml interface to GSL                       */
/* Copyright (©) 2002-2012 - Olivier Andrieu                */
/* Distributed under the terms of the GPL version 3         */

#include <gsl/gsl_randist.h>

#include <caml/alloc.h>
#include <caml/memory.h>

#include "wrappers.h"
#include "mlgsl_rng.h"
#include "mlgsl_vector_double.h"
#include "mlgsl_matrix_double.h"

/* GAUSSIAN */
ML2(gsl_ran_gaussian, Rng_val, Double_val, copy_double)
ML2(gsl_ran_gaussian_ratio_method, Rng_val, Double_val, copy_double)
ML2(gsl_ran_gaussian_ziggurat, Rng_val, Double_val, copy_double)
ML2(gsl_ran_gaussian_pdf, Double_val, Double_val, copy_double)

ML1(gsl_ran_ugaussian, Rng_val, copy_double)
ML1(gsl_ran_ugaussian_ratio_method, Rng_val, copy_double)
ML1(gsl_ran_ugaussian_pdf, Double_val, copy_double)


/* GAUSSIAN TAIL */
ML3(gsl_ran_gaussian_tail, Rng_val, Double_val, Double_val, copy_double)
ML3(gsl_ran_gaussian_tail_pdf, Double_val, Double_val, Double_val ,copy_double)

ML2(gsl_ran_ugaussian_tail, Rng_val, Double_val, copy_double)
ML2(gsl_ran_ugaussian_tail_pdf, Double_val, Double_val, copy_double)


/* BIVARIATE */
CAMLprim value ml_gsl_ran_bivariate_gaussian(value rng, value sigma_x, value sigma_y,
					     value rho)
{
  double x,y;
  gsl_ran_bivariate_gaussian(Rng_val(rng), 
			     Double_val(sigma_x), Double_val(sigma_y),
			     Double_val(rho), &x, &y);
  return copy_two_double(x, y);
}
ML5(gsl_ran_bivariate_gaussian_pdf, Double_val, Double_val, Double_val, Double_val, Double_val, copy_double)

/* MULTIVARIATE */
CAMLprim value ml_gsl_ran_multivariate_gaussian(value rng, value mu, value l, value out)
{
  gsl_vector v_mu, v_out;
  gsl_matrix m_l;

  mlgsl_vec_of_value(&v_mu, mu);
  mlgsl_vec_of_value(&v_out, out);
  mlgsl_mat_of_value(&m_l, l);

  gsl_ran_multivariate_gaussian(Rng_val(rng), &v_mu, &m_l, &v_out);

  return Val_unit;
}

/* EXPONENTIAL */
ML2(gsl_ran_exponential, Rng_val, Double_val, copy_double)
ML2(gsl_ran_exponential_pdf, Double_val, Double_val, copy_double)

/* LAPLACE */
ML2(gsl_ran_laplace, Rng_val, Double_val, copy_double)
ML2(gsl_ran_laplace_pdf, Double_val, Double_val, copy_double)

/* EXPONENTIAL POWER */
ML3(gsl_ran_exppow, Rng_val, Double_val, Double_val, copy_double)
ML3(gsl_ran_exppow_pdf, Double_val, Double_val, Double_val, copy_double)

/* CAUCHY */
ML2(gsl_ran_cauchy, Rng_val, Double_val, copy_double)
ML2(gsl_ran_cauchy_pdf, Double_val, Double_val, copy_double)

/* RAYLEIGH */
ML2(gsl_ran_rayleigh, Rng_val, Double_val, copy_double)
ML2(gsl_ran_rayleigh_pdf, Double_val, Double_val, copy_double)

/* RAYLEIGH TAIL */
ML3(gsl_ran_rayleigh_tail, Rng_val, Double_val, Double_val, copy_double)
ML3(gsl_ran_rayleigh_tail_pdf, Double_val, Double_val, Double_val, copy_double)

/* LANDAU */
ML1(gsl_ran_landau, Rng_val, copy_double)
ML1(gsl_ran_landau_pdf, Double_val, copy_double)

/* LEVY ALPHA-STABLE */
ML3(gsl_ran_levy, Rng_val, Double_val, Double_val, copy_double)

/* LEVY SKEW ALPHA-STABLE */
ML4(gsl_ran_levy_skew, Rng_val, Double_val, Double_val, Double_val, copy_double)

/* GAMMA */
ML3(gsl_ran_gamma, Rng_val, Double_val, Double_val, copy_double)
ML2(gsl_ran_gamma_int, Rng_val, Unsigned_int_val, copy_double)
ML3(gsl_ran_gamma_pdf, Double_val, Double_val, Double_val, copy_double)
ML3(gsl_ran_gamma_mt, Rng_val, Double_val, Double_val, copy_double)
ML3(gsl_ran_gamma_knuth, Rng_val, Double_val, Double_val, copy_double)

/* FLAT */
ML3(gsl_ran_flat, Rng_val, Double_val, Double_val, copy_double)
ML3(gsl_ran_flat_pdf, Double_val, Double_val, Double_val, copy_double)

/* LOGNORMAL */
ML3(gsl_ran_lognormal, Rng_val, Double_val, Double_val, copy_double)
ML3(gsl_ran_lognormal_pdf, Double_val, Double_val, Double_val, copy_double)

/* CHISQ */
ML2(gsl_ran_chisq, Rng_val, Double_val, copy_double)
ML2(gsl_ran_chisq_pdf, Double_val, Double_val, copy_double)

/* DIRICHLET */
CAMLprim value ml_gsl_ran_dirichlet(value rng, value alpha, value theta)
{
  const size_t K = Double_array_length(alpha);
  if(Double_array_length(theta) != K)
    GSL_ERROR("alpha and theta must have same size", GSL_EBADLEN);
  gsl_ran_dirichlet(Rng_val(rng), K, Double_array_val(alpha), 
		    Double_array_val(theta));
  return Val_unit;
}

CAMLprim value ml_gsl_ran_dirichlet_pdf(value alpha, value theta)
{
  const size_t K = Double_array_length(alpha);
  double r ;
  if(Double_array_length(theta) != K)
    GSL_ERROR("alpha and theta must have same size", GSL_EBADLEN);
  r = gsl_ran_dirichlet_pdf(K, Double_array_val(alpha), 
			    Double_array_val(theta));
  return copy_double(r);
}

CAMLprim value ml_gsl_ran_dirichlet_lnpdf(value alpha, value theta)
{
  const size_t K = Double_array_length(alpha);
  double r ;
  if(Double_array_length(theta) != K)
    GSL_ERROR("alpha and theta must have same size", GSL_EBADLEN);
  r = gsl_ran_dirichlet_lnpdf(K, Double_array_val(alpha), 
			      Double_array_val(theta));
  return copy_double(r);
}

/* FDIST */
ML3(gsl_ran_fdist, Rng_val, Double_val, Double_val, copy_double)
ML3(gsl_ran_fdist_pdf, Double_val, Double_val, Double_val, copy_double)

/* TDIST */
ML2(gsl_ran_tdist, Rng_val, Double_val, copy_double)
ML2(gsl_ran_tdist_pdf, Double_val, Double_val, copy_double)

/* BETA */
ML3(gsl_ran_beta, Rng_val, Double_val, Double_val, copy_double)
ML3(gsl_ran_beta_pdf, Double_val, Double_val, Double_val, copy_double)

/* LOGISTIC */
ML2(gsl_ran_logistic, Rng_val, Double_val, copy_double)
ML2(gsl_ran_logistic_pdf, Double_val, Double_val, copy_double)

/* PARETO */
ML3(gsl_ran_pareto, Rng_val, Double_val, Double_val, copy_double)
ML3(gsl_ran_pareto_pdf, Double_val, Double_val, Double_val, copy_double)

/* SPHERICAL */
CAMLprim value ml_gsl_ran_dir_2d(value rng)
{
  double x,y;
  gsl_ran_dir_2d(Rng_val(rng), &x, &y);
  return copy_two_double(x, y);
}

CAMLprim value ml_gsl_ran_dir_2d_trig_method(value rng)
{
  double x,y;
  gsl_ran_dir_2d_trig_method(Rng_val(rng), &x, &y);
  return copy_two_double(x, y);
}

CAMLprim value ml_gsl_ran_dir_3d(value rng)
{
  double x,y,z;
  gsl_ran_dir_3d(Rng_val(rng), &x, &y, &z);
  {
    CAMLparam0();
    CAMLlocal1(r);
    r=alloc_tuple(3);
    Store_field(r, 0, copy_double(x));
    Store_field(r, 1, copy_double(y));
    Store_field(r, 2, copy_double(z));
    CAMLreturn(r);
  }
}

CAMLprim value ml_gsl_ran_dir_nd(value rng, value x)
{
  gsl_ran_dir_nd(Rng_val(rng), Double_array_length(x), Double_array_val(x));
  return Val_unit;
}

/* WEIBULL */
ML3(gsl_ran_weibull, Rng_val, Double_val, Double_val, copy_double)
ML3(gsl_ran_weibull_pdf, Double_val, Double_val, Double_val, copy_double)

/* GUMBEL1 */
ML3(gsl_ran_gumbel1, Rng_val, Double_val, Double_val, copy_double)
ML3(gsl_ran_gumbel1_pdf, Double_val, Double_val, Double_val, copy_double)

/* GUMBEL2 */
ML3(gsl_ran_gumbel2, Rng_val, Double_val, Double_val, copy_double)
ML3(gsl_ran_gumbel2_pdf, Double_val, Double_val, Double_val, copy_double)

/* POISSON */
ML2(gsl_ran_poisson, Rng_val, Double_val, Val_int)
ML2(gsl_ran_poisson_pdf, Int_val, Double_val, copy_double)

/* BERNOULLI */
ML2(gsl_ran_bernoulli, Rng_val, Double_val, Val_int)
ML2(gsl_ran_bernoulli_pdf, Int_val, Double_val, copy_double)

/* BINOMIAL */
ML3(gsl_ran_binomial, Rng_val, Double_val, Int_val, Val_int)
ML3(gsl_ran_binomial_knuth, Rng_val, Double_val, Int_val, Val_int)
ML3(gsl_ran_binomial_tpe, Rng_val, Double_val, Int_val, Val_int)
ML3(gsl_ran_binomial_pdf, Int_val, Double_val, Int_val, copy_double)

/* MULTINOMIAL */
CAMLprim value ml_gsl_ran_multinomial(value rng, value n, value p)
{
  mlsize_t K = Double_array_length(p);
  LOCALARRAY(unsigned int, N, K); 
  value r;
  gsl_ran_multinomial(Rng_val(rng), K, Int_val(n), Double_array_val(p), N);
  {
    mlsize_t i;
    r = alloc(K, 0);
    for(i=0; i<K; i++)
      Store_field(r, i, Val_int(N[i]));
  }
  return r;
}

CAMLprim value ml_gsl_ran_multinomial_pdf(value p, value n)
{
  mlsize_t K = Double_array_length(p);
  LOCALARRAY(unsigned int, N, K); 
  double r;
  mlsize_t i;
  for(i=0; i<K; i++)
    N[i] = Int_val(Field(n, i));
  r = gsl_ran_multinomial_pdf(K, Double_array_val(p), N);
  return copy_double(r);
}

CAMLprim value ml_gsl_ran_multinomial_lnpdf(value p, value n)
{
  mlsize_t K = Double_array_length(p);
  LOCALARRAY(unsigned int, N, K); 
  double r;
  mlsize_t i;
  for(i=0; i<K; i++)
    N[i] = Int_val(Field(n, i));
  r = gsl_ran_multinomial_lnpdf(K, Double_array_val(p), N);
  return copy_double(r);
}


/* NEGATIVE BINOMIAL */
ML3(gsl_ran_negative_binomial, Rng_val, Double_val, Double_val, Val_int)
ML3(gsl_ran_negative_binomial_pdf, Int_val, Double_val, Double_val, copy_double)

/* PASCAL */
ML3(gsl_ran_pascal, Rng_val, Double_val, Int_val, Val_int)
ML3(gsl_ran_pascal_pdf, Int_val, Double_val, Int_val, copy_double)

/* GEOMETRIC */
ML2(gsl_ran_geometric, Rng_val, Double_val, Val_int)
ML2(gsl_ran_geometric_pdf, Int_val, Double_val, copy_double)

/* HYPERGEOMETRIC */
ML4(gsl_ran_hypergeometric, Rng_val, Int_val, Int_val, Int_val, Val_int)
ML4(gsl_ran_hypergeometric_pdf, Int_val, Int_val, Int_val, Int_val, copy_double)

/* LOGARITHMIC */
ML2(gsl_ran_logarithmic, Rng_val, Double_val, Val_int)
ML2(gsl_ran_logarithmic_pdf, Int_val, Double_val, copy_double)


/* SHUFFLING */
CAMLprim value ml_gsl_ran_shuffle(value rng, value arr)
{
  if(Tag_val(arr) == Double_array_tag)
    gsl_ran_shuffle(Rng_val(rng), Double_array_val(arr),
		    Double_array_length(arr), sizeof(double));
  else
    gsl_ran_shuffle(Rng_val(rng), (value *)arr, 
		    Array_length(arr), sizeof(value));
  return Val_unit;
}

CAMLprim value ml_gsl_ran_choose(value rng, value src, value dest)
{
  if(Tag_val(src) == Double_array_tag)
    gsl_ran_choose(Rng_val(rng), 
		   Double_array_val(dest), Double_array_length(dest),
		   Double_array_val(src), Double_array_length(src),
		   sizeof(double));
  else
    gsl_ran_choose(Rng_val(rng), 
		   (value *)dest, Array_length(dest),
		   (value *)src,  Array_length(src),
		   sizeof(value));
  return Val_unit;
}

CAMLprim value ml_gsl_ran_sample(value rng, value src, value dest)
{
  if(Tag_val(src) == Double_array_tag)
    gsl_ran_sample(Rng_val(rng), 
		   Double_array_val(dest), Double_array_length(dest),
		   Double_array_val(src), Double_array_length(src),
		   sizeof(double));
  else
    gsl_ran_sample(Rng_val(rng), 
		   (value *)dest, Array_length(dest),
		   (value *)src,  Array_length(src),
		   sizeof(value));
  return Val_unit;
}


/* DISCRETE */
CAMLprim value ml_gsl_ran_discrete_preproc(value p)
{
  gsl_ran_discrete_t *G;
  value r;
  G = gsl_ran_discrete_preproc(Double_array_length(p), Double_array_val(p));
  Abstract_ptr(r, G);
  return r;
}

#define Discrete_val(v) ((gsl_ran_discrete_t *)(Field(v, 0)))
ML2(gsl_ran_discrete, Rng_val, Discrete_val, Val_int)
ML2(gsl_ran_discrete_pdf, Int_val, Discrete_val, copy_double)
ML1(gsl_ran_discrete_free, Discrete_val, Unit)
