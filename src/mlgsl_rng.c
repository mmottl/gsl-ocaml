/* gsl-ocaml - OCaml interface to GSL                       */
/* Copyright (©) 2002-2012 - Olivier Andrieu                */
/* Distributed under the terms of the GPL version 3         */

#include <string.h>

#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/fail.h>

#include <gsl/gsl_rng.h>

#include "wrappers.h"
#include "mlgsl_rng.h"

#define NB_RNG 62

const gsl_rng_type *rngtype_of_int(int i)
{
  const gsl_rng_type *rngtypes[ NB_RNG ] = {
  gsl_rng_borosh13,
  gsl_rng_coveyou,
  gsl_rng_cmrg,
  gsl_rng_fishman18,
  gsl_rng_fishman20,
  gsl_rng_fishman2x,
  gsl_rng_gfsr4,
  gsl_rng_knuthran,
  gsl_rng_knuthran2,
  gsl_rng_knuthran2002,
  gsl_rng_lecuyer21,
  gsl_rng_minstd,
  gsl_rng_mrg,
  gsl_rng_mt19937,
  gsl_rng_mt19937_1999,
  gsl_rng_mt19937_1998,
  gsl_rng_r250,
  gsl_rng_ran0,
  gsl_rng_ran1,
  gsl_rng_ran2,
  gsl_rng_ran3,
  gsl_rng_rand,
  gsl_rng_rand48,
  gsl_rng_random128_bsd,
  gsl_rng_random128_glibc2,
  gsl_rng_random128_libc5,
  gsl_rng_random256_bsd,
  gsl_rng_random256_glibc2,
  gsl_rng_random256_libc5,
  gsl_rng_random32_bsd,
  gsl_rng_random32_glibc2,
  gsl_rng_random32_libc5,
  gsl_rng_random64_bsd,
  gsl_rng_random64_glibc2,
  gsl_rng_random64_libc5,
  gsl_rng_random8_bsd,
  gsl_rng_random8_glibc2,
  gsl_rng_random8_libc5,
  gsl_rng_random_bsd,
  gsl_rng_random_glibc2,
  gsl_rng_random_libc5,
  gsl_rng_randu,
  gsl_rng_ranf,
  gsl_rng_ranlux,
  gsl_rng_ranlux389,
  gsl_rng_ranlxd1,
  gsl_rng_ranlxd2,
  gsl_rng_ranlxs0,
  gsl_rng_ranlxs1,
  gsl_rng_ranlxs2,
  gsl_rng_ranmar,
  gsl_rng_slatec,
  gsl_rng_taus,
  gsl_rng_taus2,
  gsl_rng_taus113,
  gsl_rng_transputer,
  gsl_rng_tt800,
  gsl_rng_uni,
  gsl_rng_uni32,
  gsl_rng_vax,
  gsl_rng_waterman14,
  gsl_rng_zuf } ;
  return rngtypes[i];
}

#define Rngtype_val(v) (rngtype_of_int(Int_val(v)))

value ml_gsl_rng_env_setup(value unit)
{
  gsl_rng_env_setup() ;
  return Val_unit;
}

static int int_of_rngtype(const gsl_rng_type *rngt)
{
  unsigned int i, len = NB_RNG;
  for(i=0; i<len; i++)
    if(rngtype_of_int(i) == rngt) break ;
  if(i < len)
    return i;
  else
    caml_failwith("should not happen") ;
}

value ml_gsl_rng_get_default(value unit)
{
  return Val_int(int_of_rngtype(gsl_rng_default));
}

value ml_gsl_rng_get_default_seed(value unit)
{
  return caml_copy_nativeint(gsl_rng_default_seed);
}

value ml_gsl_rng_set_default(value type)
{
  gsl_rng_default = Rngtype_val(type);
  return Val_unit;
}

value ml_gsl_rng_set_default_seed(value seed)
{
  gsl_rng_default_seed=Nativeint_val(seed);
  return Val_unit;
}

value ml_gsl_rng_alloc(value type)
{
  void* x = malloc(2 * 16);
  value r;
  Abstract_ptr(r,gsl_rng_alloc(Rngtype_val(type))); 
  return r;
}

value ml_gsl_rng_free(value rng)
{
  gsl_rng_free(Rng_val(rng)) ;
  return Val_unit;
}

value ml_gsl_rng_set(value rng, value seed)
{
  gsl_rng_set(Rng_val(rng), Nativeint_val(seed));
  return Val_unit;
}

value ml_gsl_rng_name(value rng)
{
  return caml_copy_string(gsl_rng_name(Rng_val(rng)));
}

value ml_gsl_rng_max(value rng)
{
  return caml_copy_nativeint(gsl_rng_max(Rng_val(rng)));
}

value ml_gsl_rng_min(value rng)
{
  return caml_copy_nativeint(gsl_rng_min(Rng_val(rng)));
}

value ml_gsl_rng_get_type(value rng)
{
  return Val_int(int_of_rngtype(Rng_val(rng)->type));
}

value ml_gsl_rng_memcpy(value src, value dst)
{
  gsl_rng_memcpy(Rng_val(dst), Rng_val(src));
  return Val_unit;
}

value ml_gsl_rng_clone(value rng)
{
  value r;
  Abstract_ptr(r, gsl_rng_clone(Rng_val(rng))); 
  return r;
}

value ml_gsl_rng_dump_state(value rng)
{
  CAMLparam0();
  CAMLlocal3(v, n, s);
  size_t len = gsl_rng_size(Rng_val(rng));
  void *state = gsl_rng_state(Rng_val(rng));
  const char *name = gsl_rng_name(Rng_val(rng));
  n = caml_copy_string(name);
  s = caml_alloc_initialized_string(len, state);
  v = caml_alloc_small(2, 0);
  Field(v, 0) = n;
  Field(v, 1) = s;
  CAMLreturn(v);
}

value ml_gsl_rng_set_state(value rng, value v)
{
  gsl_rng *r = Rng_val(rng);
  const char *name = String_val(Field(v, 0));
  value state = Field(v, 1);
  if(strcmp(name, gsl_rng_name(r)) != 0 ||
     gsl_rng_size(r) != caml_string_length(state) )
    caml_invalid_argument("Gsl.Rng.set_state : wrong rng type");
  memcpy(r->state, Bp_val(state), caml_string_length(state));
  return Val_unit;
}

/* sampling */
value ml_gsl_rng_get(value rng)
{
  return caml_copy_nativeint(gsl_rng_get(Rng_val(rng))) ;
}

value ml_gsl_rng_uniform(value rng)
{
  return caml_copy_double(gsl_rng_uniform(Rng_val(rng))) ;
}

value ml_gsl_rng_uniform_pos(value rng)
{
  return caml_copy_double(gsl_rng_uniform_pos(Rng_val(rng))) ;
}

value ml_gsl_rng_uniform_int(value rng, value n)
{
  return Val_int(gsl_rng_uniform_int(Rng_val(rng), Int_val(n))) ;
}

value ml_gsl_rng_uniform_arr(value rng, value arr)
{
  gsl_rng *c_rng = Rng_val(rng) ;
  mlsize_t len = Double_array_length(arr);
  mlsize_t i;
  for(i=0; i<len; i++)
    Store_double_field(arr, i, gsl_rng_uniform(c_rng)) ;
  return Val_unit;
}

value ml_gsl_rng_uniform_pos_arr(value rng, value arr)
{
  gsl_rng *c_rng = Rng_val(rng) ;
  mlsize_t len = Double_array_length(arr);
  mlsize_t i;
  for(i=0; i<len; i++)
    Store_double_field(arr, i, gsl_rng_uniform_pos(c_rng)) ;
  return Val_unit;
}
