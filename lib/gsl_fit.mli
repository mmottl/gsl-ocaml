(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2012 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)

(** Least-Squares Fitting *)

type linear_fit_coeffs = {
    c0 : float; c1 : float;
    cov00 : float ; cov01 : float ; cov11 : float;
    sumsq : float ;
  } 
external linear :
  ?weight:float array -> float array -> float array -> linear_fit_coeffs
  = "ml_gsl_fit_linear"
external linear_est : float -> coeffs:linear_fit_coeffs -> Fun.result
  = "ml_gsl_fit_linear_est"


type mul_fit_coeffs = {
    m_c1    : float ;
    m_cov11 : float ;
    m_sumsq : float ;
  } 
external mul :
  ?weight:float array -> float array -> float array -> mul_fit_coeffs
  = "ml_gsl_fit_mul"
external mul_est : float -> coeffs:mul_fit_coeffs -> Fun.result
  = "ml_gsl_fit_mul_est"
