/* gsl-ocaml - OCaml interface to GSL                       */
/* Copyright (©) 2002-2012 - Olivier Andrieu                */
/* Distributed under the terms of the GPL version 3         */

#include <gsl/gsl_errno.h>
#include <gsl/gsl_integration.h>

#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/callback.h>
#include <caml/fail.h>
#include <caml/memory.h>

#include "mlgsl_fun.h"
#include "wrappers.h"


/* QNG integration */
CAMLprim value ml_gsl_integration_qng(value fun, value a, value b, 
				      value epsabs, value epsrel)
{
  CAMLparam1(fun);
  CAMLlocal3(res, r, e);
  GSLFUN_CLOSURE(gf, fun);
  double result, abserr;
  size_t neval;
  
  gsl_integration_qng(&gf, Double_val(a), Double_val(b),
		      Double_val(epsabs), Double_val(epsrel),
		      &result, &abserr, &neval);
  r = caml_copy_double(result);
  e = caml_copy_double(abserr);
  res = caml_alloc_small(3, 0);
  Field(res, 0) = r;
  Field(res, 1) = e;
  Field(res, 2) = Val_int(neval);
  CAMLreturn(res);
}




/* WORKSPACE */
#define GSL_WS(v) (gsl_integration_workspace *)(Field((v), 0))

ML1_alloc(gsl_integration_workspace_alloc, Int_val, Abstract_ptr)
ML1(gsl_integration_workspace_free, GSL_WS, Unit)

CAMLprim value ml_gsl_integration_ws_size(value ws)
{
  return Val_int((GSL_WS(ws))->size);
}


/* QAG Integration */
CAMLprim value ml_gsl_integration_qag(value fun, value a, value b,
				      value epsabs, value epsrel,
				      value limit, value key, value ws)
{
  CAMLparam2(fun, ws);
  GSLFUN_CLOSURE(gf, fun);
  double result, abserr;
  size_t c_limit;
  static const int key_conv [] = { GSL_INTEG_GAUSS15, GSL_INTEG_GAUSS21, 
				   GSL_INTEG_GAUSS31, GSL_INTEG_GAUSS41, 
				   GSL_INTEG_GAUSS51, GSL_INTEG_GAUSS61 };
  int c_key = key_conv [ Int_val(key) ];
  gsl_integration_workspace *gslws = GSL_WS(ws);

  c_limit = Opt_arg(limit, (size_t)Int_val, gslws->limit);
  gsl_integration_qag(&gf, 
		      Double_val(a), Double_val(b), 
		      Double_val(epsabs), Double_val(epsrel),
		      c_limit, c_key, gslws, &result, &abserr);
  CAMLreturn(copy_two_double_arr(result, abserr));
}

CAMLprim value ml_gsl_integration_qag_bc(value *args, int nb)
{
  return ml_gsl_integration_qag(args[0], args[1], args[2], args[3], args[4],
				args[5], args[6], args[7]);
}

CAMLprim value ml_gsl_integration_qags(value fun, value a, value b,
				       value epsabs, value epsrel,
				       value limit, value ws)
{
  CAMLparam2(fun, ws);
  GSLFUN_CLOSURE(gf, fun);
  double result, abserr;
  size_t c_limit;
  gsl_integration_workspace *gslws = GSL_WS(ws);

  c_limit = Opt_arg(limit, (size_t)Int_val, gslws->limit);
  gsl_integration_qags(&gf,
		       Double_val(a), Double_val(b), 
		       Double_val(epsabs), Double_val(epsrel),
		       c_limit, gslws, &result, &abserr);
  CAMLreturn(copy_two_double_arr(result, abserr));
}

CAMLprim value ml_gsl_integration_qags_bc(value *args, int nb)
{
  return ml_gsl_integration_qags(args[0], args[1], args[2], args[3], args[4],
				 args[5], args[6]);
}


CAMLprim value ml_gsl_integration_qagp(value fun, value pts, 
				       value epsabs, value epsrel,
				       value limit, value ws)
{
  CAMLparam2(fun, ws);
  GSLFUN_CLOSURE(gf, fun);
  double result, abserr;
  size_t c_limit;
  gsl_integration_workspace *gslws = GSL_WS(ws);
  
  c_limit = Opt_arg(limit, (size_t)Int_val, gslws->limit);
  gsl_integration_qagp(&gf, 
		       Double_array_val(pts), Double_array_length(pts),
		       Double_val(epsabs), Double_val(epsrel),
		       c_limit, gslws, &result, &abserr);
  CAMLreturn(copy_two_double_arr(result, abserr));
}  

CAMLprim value ml_gsl_integration_qagp_bc(value *args, int nb)
{
  return ml_gsl_integration_qagp(args[0], args[1], args[2],
				 args[3], args[4], args[5]);
}

CAMLprim value ml_gsl_integration_qagi(value fun, 
				       value epsabs, value epsrel,
				       value limit, value ws)
{
  CAMLparam2(fun, ws);
  GSLFUN_CLOSURE(gf, fun);
  double result, abserr;
  size_t c_limit;
  gsl_integration_workspace *gslws = GSL_WS(ws);
  
  c_limit = Opt_arg(limit, (size_t)Int_val,gslws->limit);
  gsl_integration_qagi(&gf,
		       Double_val(epsabs), Double_val(epsrel),
		       c_limit, gslws, &result, &abserr);
  CAMLreturn(copy_two_double_arr(result, abserr));
}  

CAMLprim value ml_gsl_integration_qagiu(value fun, value a, 
					value epsabs, value epsrel,
					value limit, value ws)
{
  CAMLparam2(fun, ws);
  GSLFUN_CLOSURE(gf, fun);
  double result, abserr;
  size_t c_limit;
  gsl_integration_workspace *gslws = GSL_WS(ws);
  
  c_limit = Opt_arg(limit, (size_t)Int_val, gslws->limit);
  gsl_integration_qagiu(&gf, Double_val(a),
			Double_val(epsabs), Double_val(epsrel),
			c_limit, gslws, &result, &abserr);
  CAMLreturn(copy_two_double_arr(result, abserr));
}  

CAMLprim value ml_gsl_integration_qagiu_bc(value *args, int nb)
{
  return ml_gsl_integration_qagiu(args[0], args[1], args[2],
				  args[3], args[4], args[5]);
}


CAMLprim value ml_gsl_integration_qagil(value fun, value b, 
					value epsabs, value epsrel,
					value limit, value ws)
{
  CAMLparam2(fun, ws);
  GSLFUN_CLOSURE(gf, fun);
  double result, abserr;
  size_t c_limit;
  gsl_integration_workspace *gslws = GSL_WS(ws);
  
  c_limit = Opt_arg(limit, (size_t)Int_val, gslws->limit);
  gsl_integration_qagil(&gf, Double_val(b),
			Double_val(epsabs), Double_val(epsrel),
			c_limit, gslws, &result, &abserr);
  CAMLreturn(copy_two_double_arr(result, abserr));
}  

CAMLprim value ml_gsl_integration_qagil_bc(value *args, int nb)
{
  return ml_gsl_integration_qagil(args[0], args[1], args[2],
				  args[3], args[4], args[5]);
}



/* QAWC integration */

CAMLprim value ml_gsl_integration_qawc(value fun, value a, value b, value c,
				       value epsabs, value epsrel,
				       value limit, value ws)
{
  CAMLparam2(fun, ws);
  GSLFUN_CLOSURE(gf, fun);
  double result, abserr;
  size_t c_limit;
  gsl_integration_workspace *gslws = GSL_WS(ws);
  
  c_limit = Opt_arg(limit, (size_t)Int_val, gslws->limit);
  gsl_integration_qawc(&gf,
		       Double_val(a), Double_val(b), Double_val(c),
		       Double_val(epsabs), Double_val(epsrel),
		       c_limit, gslws, &result, &abserr);
  CAMLreturn(copy_two_double_arr(result, abserr));
}  

CAMLprim value ml_gsl_integration_qawc_bc(value *args, int nb)
{
  return ml_gsl_integration_qawc(args[0], args[1], args[2], args[3], 
				 args[4], args[5], args[6], args[7]);
}



/* QAWS integration */
CAMLprim value ml_gsl_integration_qaws_table_alloc(value alpha, value beta,
						   value mu, value nu)
{
  value res;
  Abstract_ptr(res, gsl_integration_qaws_table_alloc(Double_val(alpha),
                                                     Double_val(beta),
                                                     Int_val(mu),
                                                     Int_val(nu)));
  return res;
}
#define QAWSTABLE_VAL(v) (gsl_integration_qaws_table *)Field((v), 0)

ML5(gsl_integration_qaws_table_set, QAWSTABLE_VAL, Double_val, Double_val, Int_val, Int_val, Unit)
ML1(gsl_integration_qaws_table_free, QAWSTABLE_VAL, Unit)

CAMLprim value ml_gsl_integration_qaws(value fun, value a, value b, value table ,
				       value epsabs, value epsrel,
				       value limit, value ws)
{
  CAMLparam3(fun, ws, table);
  GSLFUN_CLOSURE(gf, fun);
  double result, abserr;
  size_t c_limit;
  gsl_integration_workspace *gslws = GSL_WS(ws);
  
  c_limit = Opt_arg(limit, (size_t)Int_val, gslws->limit);
  gsl_integration_qaws(&gf, 
		       Double_val(a), Double_val(b), QAWSTABLE_VAL(table),
		       Double_val(epsabs), Double_val(epsrel),
		       c_limit, gslws, &result, &abserr);
  CAMLreturn(copy_two_double_arr(result, abserr));
}  

CAMLprim value ml_gsl_integration_qaws_bc(value *args, int nb)
{
  return ml_gsl_integration_qaws(args[0], args[1], args[2], args[3], 
				 args[4], args[5], args[6], args[7]);
}



/* QAWO integration */
static inline enum gsl_integration_qawo_enum qawo_of_val(value sine)
{
  static const enum gsl_integration_qawo_enum qawo_sine[] = { 
    GSL_INTEG_COSINE, GSL_INTEG_SINE };
  return qawo_sine[Int_val(sine)];
}

CAMLprim value ml_gsl_integration_qawo_table_alloc(value omega, value l,
						   value sine, value n)
{
  value res;
  Abstract_ptr(res, gsl_integration_qawo_table_alloc(Double_val(omega),
                                                     Double_val(l),
                                                     qawo_of_val(sine),
                                                     Int_val(n)));
  return res;
}
#define QAWOTABLE_VAL(v) (gsl_integration_qawo_table *)Field((v), 0)

ML4(gsl_integration_qawo_table_set, QAWOTABLE_VAL, Double_val, Double_val, qawo_of_val, Unit)
ML1(gsl_integration_qawo_table_free, QAWOTABLE_VAL, Unit)

CAMLprim value ml_gsl_integration_qawo(value fun, value a,
				       value epsabs, value epsrel,
				       value limit, value ws, value table)
{
  CAMLparam3(fun, ws, table);
  GSLFUN_CLOSURE(gf, fun);
  double result, abserr;
  size_t c_limit;
  gsl_integration_workspace *gslws = GSL_WS(ws);
  
  c_limit = Opt_arg(limit, (size_t)Int_val, gslws->limit);
  gsl_integration_qawo(&gf, Double_val(a), 
		       Double_val(epsabs), Double_val(epsrel),
		       c_limit, gslws, 
		       QAWOTABLE_VAL(table),
		       &result, &abserr);
  CAMLreturn(copy_two_double_arr(result, abserr));
}  

CAMLprim value ml_gsl_integration_qawo_bc(value *args, int nb)
{
  return ml_gsl_integration_qawo(args[0], args[1], args[2], args[3], 
				 args[4], args[5], args[6]);
}

CAMLprim value ml_gsl_integration_qawf(value fun, value a, value epsabs, 
				       value limit, value ws, value cyclews,
				       value table)
{
  CAMLparam4(fun, ws, cyclews, table);
  GSLFUN_CLOSURE(gf, fun);
  double result, abserr;
  size_t c_limit;
  gsl_integration_workspace *gslws = GSL_WS(ws);
  
  c_limit = Opt_arg(limit, (size_t)Int_val, gslws->limit);
  gsl_integration_qawf(&gf, Double_val(a), 
		       Double_val(epsabs), c_limit, 
		       gslws, GSL_WS(cyclews),
		       QAWOTABLE_VAL(table),
		       &result, &abserr);
  CAMLreturn(copy_two_double_arr(result, abserr));
}  

CAMLprim value ml_gsl_integration_qawf_bc(value *args, int nb)
{
  return ml_gsl_integration_qawf(args[0], args[1], args[2], args[3], 
				 args[4], args[5], args[6]);
}
