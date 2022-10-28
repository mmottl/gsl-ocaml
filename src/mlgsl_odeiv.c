/* gsl-ocaml - OCaml interface to GSL                       */
/* Copyright (©) 2002-2012 - Olivier Andrieu                */
/* Distributed under the terms of the GPL version 3         */


#include <string.h>

#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/memory.h>
#include <caml/callback.h>
#include <caml/bigarray.h>

#include <gsl/gsl_errno.h>
#include <gsl/gsl_odeiv.h>

#include "wrappers.h"

struct mlgsl_odeiv_params {
  value closure;
  value jac_closure;
  value arr1;
  value arr2;
  value mat;
  size_t dim;
};  

static int ml_gsl_odeiv_func(double t, const double y[], 
			     double dydt[], void *params)
{
  struct mlgsl_odeiv_params *p = params;
  value vt, res;
  vt  = caml_copy_double(t);
  memcpy(Double_array_val(p->arr1), y, p->dim * sizeof(double));
  res = callback3_exn(p->closure, vt, p->arr1, p->arr2);
  if(Is_exception_result(res))
    return GSL_FAILURE;
  memcpy(dydt, Double_array_val(p->arr2), p->dim * sizeof(double));
  return GSL_SUCCESS;
}

static int ml_gsl_odeiv_jacobian(double t, const double y[],
				double *dfdy, double dfdt[],
				void *params)
{
  struct mlgsl_odeiv_params *p = params;
  value res, args[4];
  args[0] = caml_copy_double(t);
  memcpy(Double_array_val(p->arr1), y, p->dim * sizeof(double));
  args[1] = p->arr1;
  Caml_ba_data_val(p->mat) = dfdy;
  args[2] = p->mat;
  args[3] = p->arr2;
  res = callbackN_exn(p->jac_closure, 4, args);
  if(Is_exception_result(res))
    return GSL_FAILURE;
  memcpy(dfdt, Double_array_val(p->arr2), p->dim * sizeof(double));
  return GSL_SUCCESS;
}

CAMLprim value ml_gsl_odeiv_alloc_system(value func, value ojac, value dim)
{
  const int barr_flags = BIGARRAY_FLOAT64 | BIGARRAY_C_LAYOUT | BIGARRAY_EXTERNAL;
  struct mlgsl_odeiv_params *p;
  gsl_odeiv_system *syst;
  value res;
  p=stat_alloc(sizeof (*p));
  p->dim = Int_val(dim);
  p->closure = func;
  register_global_root(&(p->closure));
  p->jac_closure = (Is_none(ojac) ? Val_unit : Unoption(ojac));
  register_global_root(&(p->jac_closure));
  p->arr1 = alloc(Int_val(dim) * Double_wosize, Double_array_tag);
  register_global_root(&(p->arr1));
  p->arr2 = alloc(Int_val(dim) * Double_wosize, Double_array_tag);
  register_global_root(&(p->arr2));
  p->mat =
    Is_none(ojac)
    ? Val_unit
    : alloc_bigarray_dims(barr_flags, 2, NULL, Int_val(dim), Int_val(dim));
  register_global_root(&(p->mat));

  syst=stat_alloc(sizeof (*syst));
  syst->function = ml_gsl_odeiv_func;
  syst->jacobian = ml_gsl_odeiv_jacobian;
  syst->dimension = Int_val(dim);
  syst->params = p;
  Abstract_ptr(res, syst);
  return res;
}

#define ODEIV_SYSTEM_VAL(v) ((gsl_odeiv_system *)Field((v), 0))

CAMLprim value ml_gsl_odeiv_free_system(value vsyst)
{
  gsl_odeiv_system *syst = ODEIV_SYSTEM_VAL(vsyst);
  struct mlgsl_odeiv_params *p = syst->params;
  remove_global_root(&(p->closure));
  remove_global_root(&(p->jac_closure));
  remove_global_root(&(p->arr1));
  remove_global_root(&(p->arr2));
  remove_global_root(&(p->mat));
  stat_free(p);
  stat_free(syst);
  return Val_unit;
}


CAMLprim value ml_gsl_odeiv_step_alloc(value step_type, value dim)
{
  const gsl_odeiv_step_type *steppers[] = {
    gsl_odeiv_step_rk2, gsl_odeiv_step_rk4,
    gsl_odeiv_step_rkf45, gsl_odeiv_step_rkck,
    gsl_odeiv_step_rk8pd, gsl_odeiv_step_rk2imp,
    gsl_odeiv_step_rk2simp,
    gsl_odeiv_step_rk4imp, gsl_odeiv_step_bsimp,
    gsl_odeiv_step_gear1, gsl_odeiv_step_gear2, };
  gsl_odeiv_step *step = gsl_odeiv_step_alloc(steppers[ Int_val(step_type) ],
					      Int_val(dim));
  value res;
  Abstract_ptr(res, step);
  return res;
}

#define ODEIV_STEP_VAL(v) ((gsl_odeiv_step *)Field((v), 0))

ML1(gsl_odeiv_step_free, ODEIV_STEP_VAL, Unit)
ML1(gsl_odeiv_step_reset, ODEIV_STEP_VAL, Unit)
ML1(gsl_odeiv_step_name, ODEIV_STEP_VAL, copy_string)
ML1(gsl_odeiv_step_order, ODEIV_STEP_VAL, Val_int)

CAMLprim value ml_gsl_odeiv_step_apply(value step, value t, value h, value y,
			      value yerr, value odydt_in, value odydt_out, 
			      value syst)
{
  CAMLparam5(step, syst, y, yerr, odydt_out);
  LOCALARRAY(double, y_copy,  Double_array_length(y)); 
  LOCALARRAY(double, yerr_copy, Double_array_length(yerr)); 
  size_t len_dydt_in = 
    Is_none(odydt_in) ? 0 : Double_array_length(Unoption(odydt_in)) ;
  size_t len_dydt_out = 
    Is_none(odydt_out) ? 0 : Double_array_length(Unoption(odydt_out)) ;
  LOCALARRAY(double, dydt_in, len_dydt_in); 
  LOCALARRAY(double, dydt_out, len_dydt_out); 
  int status;

  if(len_dydt_in)
    memcpy(dydt_in, Double_array_val(Unoption(odydt_in)), Bosize_val(Unoption(odydt_in)));
  memcpy(y_copy, Double_array_val(y), Bosize_val(y));
  memcpy(yerr_copy, Double_array_val(yerr), Bosize_val(yerr));

  status = gsl_odeiv_step_apply(ODEIV_STEP_VAL(step), 
				Double_val(t), Double_val(h),
				y_copy, yerr_copy, 
				len_dydt_in  ? dydt_in : NULL,
				len_dydt_out ? dydt_out : NULL,
				ODEIV_SYSTEM_VAL(syst));
  /* GSL does not call the error handler for this function */
  if (status)
    GSL_ERROR_VAL ("gsl_odeiv_step_apply", status, Val_unit);

  memcpy(Double_array_val(y), y_copy, sizeof(y_copy));
  memcpy(Double_array_val(yerr), yerr_copy, sizeof(yerr_copy));
  if(len_dydt_out)
    memcpy(Double_array_val(Unoption(odydt_out)), dydt_out, Bosize_val(Unoption(odydt_out)));

  CAMLreturn(Val_unit);
}

CAMLprim value ml_gsl_odeiv_step_apply_bc(value argv[], int argc)
{
  return ml_gsl_odeiv_step_apply(argv[0], argv[1], argv[2], argv[3],
				 argv[4], argv[5], argv[6], argv[7]);
}

CAMLprim value ml_gsl_odeiv_control_standard_new(value eps_abs, value eps_rel,
					value a_y, value a_dydt)
{
  gsl_odeiv_control *c = 
    gsl_odeiv_control_standard_new(Double_val(eps_abs), Double_val(eps_rel),
				   Double_val(a_y), Double_val(a_dydt));
  value res;
  Abstract_ptr(res, c);
  return res;
}

CAMLprim value ml_gsl_odeiv_control_y_new(value eps_abs, value eps_rel)
{
  gsl_odeiv_control *c = 
    gsl_odeiv_control_y_new(Double_val(eps_abs), Double_val(eps_rel));
  value res;
  Abstract_ptr(res, c);
  return res;
}

CAMLprim value ml_gsl_odeiv_control_yp_new(value eps_abs, value eps_rel)
{
  gsl_odeiv_control *c = 
    gsl_odeiv_control_yp_new(Double_val(eps_abs), Double_val(eps_rel));
  value res;
  Abstract_ptr(res, c);
  return res;
}

CAMLprim value ml_gsl_odeiv_control_scaled_new(value eps_abs, value eps_rel,
				      value a_y, value a_dydt, value scale_abs)
{
  gsl_odeiv_control *c = 
    gsl_odeiv_control_scaled_new(Double_val(eps_abs), Double_val(eps_rel),
				 Double_val(a_y), Double_val(a_dydt),
				 Double_array_val(scale_abs), 
				 Double_array_length(scale_abs));
  value res;
  Abstract_ptr(res, c);
  return res;
}

#define ODEIV_CONTROL_VAL(v) ((gsl_odeiv_control *)Field((v), 0))

ML1(gsl_odeiv_control_free, ODEIV_CONTROL_VAL, Unit)
ML1(gsl_odeiv_control_name, ODEIV_CONTROL_VAL, copy_string)

CAMLprim value ml_gsl_odeiv_control_hadjust(value c, value s, value y,
					    value yerr, value dydt, value h)
{
  double c_h = Double_val(h);
  int status = 
    gsl_odeiv_control_hadjust(ODEIV_CONTROL_VAL(c), ODEIV_STEP_VAL(s),
			      Double_array_val(y), Double_array_val(yerr),
			      Double_array_val(dydt), &c_h);
  {
    CAMLparam0();
    CAMLlocal2(vh, r);
    vh = caml_copy_double(c_h);
    r = caml_alloc_small(2, 0);
    Field(r, 0) = Val_int(status + 1);
    Field(r, 1) = vh;
    CAMLreturn(r);
  }
}

CAMLprim value ml_gsl_odeiv_control_hadjust_bc(value *argv, int argc)
{
  return ml_gsl_odeiv_control_hadjust(argv[0], argv[1], argv[2], 
				      argv[3], argv[4], argv[5]);
}

CAMLprim value ml_gsl_odeiv_evolve_alloc(value dim)
{
  gsl_odeiv_evolve *e = gsl_odeiv_evolve_alloc(Int_val(dim));
  value res;
  Abstract_ptr(res, e);
  return res;
}

#define ODEIV_EVOLVE_VAL(v) ((gsl_odeiv_evolve *)Field((v), 0))

ML1(gsl_odeiv_evolve_free, ODEIV_EVOLVE_VAL, Unit)
ML1(gsl_odeiv_evolve_reset, ODEIV_EVOLVE_VAL, Unit)
  
CAMLprim value ml_gsl_odeiv_evolve_apply(value e, value c, value s, 
				value syst, value t, value t1, 
				value h, value y)
{
  CAMLparam5(e, c, s, syst, y);
  double t_c = Double_val(t);
  double h_c = Double_val(h);
  LOCALARRAY(double, y_copy, Double_array_length(y)); 
  int status;
  memcpy(y_copy, Double_array_val(y), Bosize_val(y));

  status = gsl_odeiv_evolve_apply(ODEIV_EVOLVE_VAL(e), ODEIV_CONTROL_VAL(c),
				  ODEIV_STEP_VAL(s), ODEIV_SYSTEM_VAL(syst),
				  &t_c, Double_val(t1), &h_c, y_copy);
  /* GSL does not call the error handler for this function */
  if (status)
    GSL_ERROR_VAL ("gsl_odeiv_evolve_apply", status, Val_unit);

  memcpy(Double_array_val(y), y_copy, Bosize_val(y));
  CAMLreturn(copy_two_double(t_c, h_c));
}

CAMLprim value ml_gsl_odeiv_evolve_apply_bc(value *argv, int argc)
{
  return ml_gsl_odeiv_evolve_apply(argv[0], argv[1], argv[2], argv[3],
				   argv[4], argv[5], argv[6], argv[7]);
}
