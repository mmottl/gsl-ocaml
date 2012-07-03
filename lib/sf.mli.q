(* gsl-ocaml - OCaml interface to GSL                        *)
(* Copyright (©) 2002-2005 - Olivier Andrieu                *)
(* Distributed under the terms of the LGPL version 2.1      *)

(** Special functions *)

open Fun

(* AIRY functions *)
<< airy_Ai float mode >>
<< airy_Bi float mode >>
<< airy_Ai_scaled float mode >>
<< airy_Bi_scaled float mode >>
<< airy_Ai_deriv float mode >>
<< airy_Bi_deriv float mode >>
<< airy_Ai_deriv_scaled float mode >>
<< airy_Bi_deriv_scaled float mode >>

<< airy_zero_Ai int >>
<< airy_zero_Bi int >>

(* BESSEL functions *)
<:bessel< cyl J >>
<:bessel< cyl Y >>
<:bessel< cyl I >>
<:bessel< cyl K >>
<:bessel< cyl_scaled I >>
<:bessel< cyl_scaled K >>

<:bessel< sph j >>
<:ext< bessel_jl_steed_array@ml_gsl_sf_bessel_jl_steed_array,float,float array,unit >>
<:bessel< sph y >>
<:bessel< sph_scaled i >>
<:bessel< sph_scaled k >>

<< bessel_Jnu float float >>
<:ext< bessel_sequence_Jnu_e@ml_gsl_sf_bessel_sequence_Jnu_e,float,mode,float array,unit>>
<< bessel_Ynu float float >>
<< bessel_Inu float float >>
<< bessel_Inu_scaled float float >>
<< bessel_Knu float float >>
<< bessel_lnKnu float float >>
<< bessel_Knu_scaled float float >>

<< bessel_zero_J0 int >>
<< bessel_zero_J1 int >>
<< bessel_zero_Jnu float int >>

(* CLAUSEN functions *)
<< clausen float >>

(* COULOMB functions *)
<< hydrogenicR_1 float float >>
<< hydrogenicR int int float float >>
(* FIXME: COULOMB wave functions *)
<:ext< coulomb_CL_e@ml_gsl_sf_coulomb_CL_e,float,float,result >>
<:ext< coulomb_CL_array@ml_gsl_sf_coulomb_CL_array,float,float,float array,unit >>

(* FIXME: coupling coeffs *)

(* DAWSON functions *)
<< dawson float >>

(* DEBYE functions *)
<< debye_1 float >>
<< debye_2 float >>
<< debye_3 float >>
<< debye_4 float >>
<< debye_5 float >>
<< debye_6 float >>

(* DILOGARITHM *)
<< dilog float >>
<:ext< complex_dilog_xy_e@ml_gsl_sf_complex_dilog_xy_e,float,float,result * result >>
<:ext< complex_dilog_e@ml_gsl_sf_complex_dilog_e,float,float,result * result >>
<:ext< complex_spence_xy_e@ml_gsl_sf_complex_spence_xy_e,float,float,result * result >>

(* ELEMENTARY operations *)
<:ext< multiply_e@ml_gsl_sf_multiply_e,float,float,result >>
<:ext< multiply_err_e@ml_gsl_sf_multiply_err_e,x:float,dx:float,y:float,dy:float,result >>

(* ELLIPTIC integrals *)
<< ellint_Kcomp float mode >>
<< ellint_Ecomp float mode >>
<< ellint_Pcomp float float mode >>
<< ellint_Dcomp float mode >>
<< ellint_F float float mode >>
<< ellint_E float float mode >>
<< ellint_P float float float mode >>
<< ellint_D float float float mode >>
<< ellint_RC float float mode >>
<< ellint_RD float float float mode >>
<< ellint_RF float float float mode >>
<< ellint_RJ float float float float mode >>
(* FIXME: elljac_e *)

(* ERROR function *)
<< erf float >>
<< erfc float >>
<< log_erfc float >>
<< erf_Z float >>
<< erf_Q float >>

(* EXPONENTIAL functions *)
<< exp float >>
<:ext< exp_e10@ml_gsl_sf_exp_e10_e,float,result_e10 >>
<< exp_mult float float >>
<:ext< exp_mult_e10@ml_gsl_sf_exp_mult_e10_e,float,float,result_e10 >>

<< expm1 float >>
<< exprel float >>
<< exprel_2 float >>
<< exprel_n int float >>
<:ext< exp_err_e@ml_gsl_sf_exp_err_e,x:float,dx:float,result >>
<:ext< exp_err_e10@ml_gsl_sf_exp_err_e10_e,x:float,dx:float,result_e10 >>
<:ext< exp_mult_err_e@ml_gsl_sf_exp_mult_err_e,x:float,dx:float,y:float,dy:float,result >>
<:ext< exp_mult_err_e10_e@ml_gsl_sf_exp_mult_err_e10_e,x:float,dx:float,y:float,dy:float,result_e10 >>

(* EXPONENTIAL integrals *)
<< expint_E1 float >>
<< expint_E2 float >>
<< expint_E1_scaled float >>
<< expint_E2_scaled float >>
<< expint_Ei float >>
<< expint_Ei_scaled float >>
<:ext< shi@ml_gsl_sf_Shi@gsl_sf_Shi,float,float >>
<:ext< chi@ml_gsl_sf_Chi@gsl_sf_Chi,float,float >>
<< expint_3 float >>
<:ext< si@ml_gsl_sf_Si@gsl_sf_Si,float,float >>
<:ext< ci@ml_gsl_sf_Ci@gsl_sf_Ci,float,float >>
<< atanint float >>

(* fermi-dirac *)
<< fermi_dirac_m1 float >>
<< fermi_dirac_0 float >>
<< fermi_dirac_1 float >>
<< fermi_dirac_2 float >>
<< fermi_dirac_int int float >>
<< fermi_dirac_mhalf float >>
<< fermi_dirac_half float >>
<< fermi_dirac_3half float >>
<< fermi_dirac_inc_0 float float >>

(* Gamma function *)
<< gamma float >>
<< lngamma float >>
<:ext< lngamma_sgn_e@ml_gsl_sf_lngamma_sgn_e,float,result * float >>
<< gammastar float >>
<< gammainv float >>
<:ext< lngamma_complex_e@ml_gsl_sf_lngamma_complex_e,float,float,result * result >>
<< taylorcoeff int float >>
<< fact int >>
<< doublefact int >>
<< lnfact int >>
<< lndoublefact int >>
<< choose int int >>
<< lnchoose int int >>
<< poch float float >>
<< lnpoch float float >>
<:ext< lnpoch_sgn_e@ml_gsl_sf_lngamma_sgn_e,float,float,result * float >>
<< pochrel float float >>
<< gamma_inc_Q float float >>
<< gamma_inc_P float float >>
<< gamma_inc float float >>
<< beta float float >>
<< lnbeta float float >>
<:ext< lnbeta_sgn_e@ml_gsl_sf_lnbeta_sgn_e,float,float,result * float >>
<< beta_inc float float float >>

(* GEGENBAUER functions *)
<< gegenpoly_1 float float >>
<< gegenpoly_2 float float >>
<< gegenpoly_3 float float >>
<< gegenpoly_n int float float >>
<:ext< gegenpoly_array@ml_gsl_sf_gegenpoly_array,float,float,float array,unit >>

(* HYPERGEOMETRIC functions *)
(* FIXME *)

(* LAGUERRE functions *)
<< laguerre_1 float float >>
<< laguerre_2 float float >>
<< laguerre_3 float float >>
<< laguerre_n int float float >>

(* LAMBERT W functions *)
<< lambert_W0 float >>
<< lambert_Wm1 float >>

(* LEGENDRE functions *)
<< legendre_P1 float >>
<< legendre_P2 float >>
<< legendre_P3 float >>
<< legendre_Pl int float >>
<:ext< legendre_Pl_array@ml_gsl_sf_legendre_Pl_array,float,float array,unit >>
<< legendre_Q0 float >>
<< legendre_Q1 float >>
<< legendre_Ql int float >>

(* Associated LEGENDRE functions *)
<< legendre_Plm int int float >>
<:ext< legendre_Plm_array@ml_gsl_sf_legendre_Plm_array,int,int,float,float array,unit >>
<< legendre_sphPlm int int float >>
<:ext< legendre_sphPlm_array@ml_gsl_sf_legendre_sphPlm_array,int,int,float,float array,unit >>
<:ext< legendre_array_size@ml_gsl_sf_legendre_array_size,int,int,int >>

(* LOGARITHM and related functions *)
<< log float >>
<< log_abs float >>
<:ext< log_complex_e@ml_gsl_sf_complex_log_e,float,float,result * result >>
<< log_1plusx float >>
<< log_1plusx_mx float >>

(* POWER function *)
<< pow_int float int >>

(* PSI function *)
<< psi_int int >>
<< psi float >>
<< psi_1piy float >>
<:ext< psi_complex_e@ml_gsl_sf_complex_psi_e,float,float,result * result >>
<< psi_1_int int >>
<< psi_1 float >>
<< psi_n int float >>

(* SYNCHROTRON functions *)
<< synchrotron_1 float >>
<< synchrotron_2 float >>

(* TRANSPORT functions *)
<< transport_2 float >>
<< transport_3 float >>
<< transport_4 float >>
<< transport_5 float >>

(* TRIGONOMETRIC functions *)
<< sin float >>
<< cos float >>
<< hypot float >>
<< sinc float >>
<:ext< complex_sin_e@ml_gsl_sf_complex_sin_e,float,float,result * result >>
<:ext< complex_cos_e@ml_gsl_sf_complex_cos_e,float,float,result * result >>
<:ext< complex_logsin_e@ml_gsl_sf_complex_logsin_e,float,float,result * result >>
<< lnsinh float >>
<< lncosh float >>
<:ext< rect_of_polar@ml_gsl_sf_polar_to_rect,r:float,theta:float,result * result >>
<:ext< polar_of_rect@ml_gsl_sf_rect_to_polar,x:float,y:float,result * result >>
<:ext< angle_restrict_symm@ml_gsl_sf_angle_restrict_symm,float,float >>
<:ext< angle_restrict_pos@ml_gsl_sf_angle_restrict_pos,float,float >>
<:ext< sin_err_e@ml_gsl_sf_sin_err_e,float,dx:float,result >>
<:ext< cos_err_e@ml_gsl_sf_cos_err_e,float,dx:float,result >>

(* ZETA functions *)
<< zeta_int int >>
<< zeta float >>
<< hzeta float float >>
<< eta_int int >>
<< eta float >>
