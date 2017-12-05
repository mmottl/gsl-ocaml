(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2012 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)

(** {1 Special functions} *)

open Fun

(** {2 Airy functions} *)

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

(** {2 Bessel functions} *)

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

(** {2 Clausen functions} *)

<< clausen float >>

(** {2 Coulomb functions} *)

<< hydrogenicR_1 float float >>
<< hydrogenicR int int float float >>

(* FIXME: COULOMB wave functions *)

<:ext< coulomb_CL_e@ml_gsl_sf_coulomb_CL_e,float,float,result >>
<:ext< coulomb_CL_array@ml_gsl_sf_coulomb_CL_array,float,float,float array,unit >>

(* FIXME: coupling coeffs *)

(** {2 Dawson functions} *)

<< dawson float >>

(** {2 Debye functions} *)

<< debye_1 float >>
<< debye_2 float >>
<< debye_3 float >>
<< debye_4 float >>
<< debye_5 float >>
<< debye_6 float >>

(** {2 Dilogarithm} *)

<< dilog float >>
<:ext< complex_dilog_xy_e@ml_gsl_sf_complex_dilog_xy_e,float,float,result * result >>
<:ext< complex_dilog_e@ml_gsl_sf_complex_dilog_e,float,float,result * result >>
<:ext< complex_spence_xy_e@ml_gsl_sf_complex_spence_xy_e,float,float,result * result >>

(** {2 Elementary operations} *)

<:ext< multiply_e@ml_gsl_sf_multiply_e,float,float,result >>
<:ext< multiply_err_e@ml_gsl_sf_multiply_err_e,x:float,dx:float,y:float,dy:float,result >>

(** {2 Elliptic integrals} *)

<< ellint_Kcomp float mode >>
<< ellint_Ecomp float mode >>
<< ellint_Pcomp float float mode >>
<< ellint_Dcomp float mode >>
<< ellint_F float float mode >>
<< ellint_E float float mode >>
<< ellint_P float float float mode >>
<< ellint_D float float mode >>
<< ellint_RC float float mode >>
<< ellint_RD float float float mode >>
<< ellint_RF float float float mode >>
<< ellint_RJ float float float float mode >>
(* FIXME: elljac_e *)

(** {2 Error function} *)

<< erf float @float >>
<< erfc float @float >>
<< log_erfc float @float >>
<< erf_Z float @float >>
<< erf_Q float @float >>

(** {2 Exponential functions} *)

<< exp float @float >>
(** [exp x] computes the exponential function eˣ using GSL semantics
    and error checking.  *)

<:ext< exp_e10@ml_gsl_sf_exp_e10_e,float,result_e10 >>
(** [exp_e10 x] computes the exponential eˣ and returns a result with
    extended range. This function may be useful if the value of eˣ
    would overflow the numeric range of double.  *)

<< exp_mult float float >>
(** [exp_mult x y] exponentiate [x] and multiply by the factor [y] to
    return the product y eˣ.  *)

<:ext< exp_mult_e10@ml_gsl_sf_exp_mult_e10_e,float,float,result_e10 >>
(** Same as {!exp_e10} but return a result with extended numeric range. *)

<< expm1 float >>
(** [expm1 x] compute the quantity eˣ-1 using an algorithm that is
    accurate for small [x].  *)

<< exprel float >>
(** [exprel x] compute the quantity (eˣ-1)/x using an algorithm that
    is accurate for small [x].  For small [x] the algorithm is based
    on the expansion (eˣ-1)/x = 1 + x/2 + x²/(2*3) + x³/(2*3*4) + ⋯  *)

<< exprel_2 float >>
(** [exprel_2 x] compute the quantity 2(eˣ-1-x)/x² using an algorithm
    that is accurate for small [x].  For small x the algorithm is
    based on the expansion 2(eˣ-1-x)/x^2 = 1 + x/3 + x²/(3*4) +
    x³/(3*4*5) + ⋯ *)

<< exprel_n int float >>
(** [exprel_n x] compute the [n]-relative exponential, which is the
    n-th generalization of the functions {!exprel} and
    {!exprel_2}. The N-relative exponential is given by,
    {[
                             n-1
    exprel_n x = n!/xⁿ (aˣ -  ∑ xᵏ/k!)
                             k=0
               = 1 + x/(N+1) + x²/((N+1)(N+2)) + ⋯
    ]}*)

<:ext< exp_err_e@ml_gsl_sf_exp_err_e,x:float,dx:float,result >>
<:ext< exp_err_e10@ml_gsl_sf_exp_err_e10_e,x:float,dx:float,result_e10 >>
<:ext< exp_mult_err_e@ml_gsl_sf_exp_mult_err_e,x:float,dx:float,y:float,dy:float,result >>
<:ext< exp_mult_err_e10_e@ml_gsl_sf_exp_mult_err_e10_e,x:float,dx:float,y:float,dy:float,result_e10 >>

(** {2 Exponential integrals} *)

<< expint_E1 float >>
<< expint_E2 float >>
<< expint_E1_scaled float >>
<< expint_E2_scaled float >>
<< expint_Ei float >>
<< expint_Ei_scaled float >>
<:ext< shi@ml_gsl_sf_Shi,float,float >>
<:ext< chi@ml_gsl_sf_Chi,float,float >>
<< expint_3 float >>
<:ext< si@ml_gsl_sf_Si,float,float >>
<:ext< ci@ml_gsl_sf_Ci,float,float >>
<< atanint float >>

(** {2 Fermi-Dirac function} *)

<< fermi_dirac_m1 float >>
<< fermi_dirac_0 float >>
<< fermi_dirac_1 float >>
<< fermi_dirac_2 float >>
<< fermi_dirac_int int float >>
<< fermi_dirac_mhalf float >>
<< fermi_dirac_half float >>
<< fermi_dirac_3half float >>
<< fermi_dirac_inc_0 float float >>

(** {2 Gamma function} *)

<:ext< gamma@ml_gsl_sf_gamma,float,float >>
<:ext< gamma_e@ml_gsl_sf_gamma_e,float,result >>
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

(** {2 Gegenbauer functions aka Ultraspherical polynomials}

    Gegenbauer functions are defined in {{:http://dlmf.nist.gov/18.3} DLMF}. *)

<< gegenpoly_1 float float >>
(** [gegenpoly_1 l x] = C₁⁽ˡ⁾(x). *)

<< gegenpoly_2 float float >>
(** [gegenpoly_2 l x] = C₂⁽ˡ⁾(x). *)

<< gegenpoly_3 float float >>
(** [gegenpoly_3 l x] = C₃⁽ˡ⁾(x). *)

<< gegenpoly_n int float float >>
(** [gegenpoly_n n l x] = Cₙ⁽ˡ⁾(x).  Constraints: l > -1/2, n ≥ 0. *)

<:ext< gegenpoly_array@ml_gsl_sf_gegenpoly_array,float,float,float array,unit >>
(** [gegenpoly_array l x c] computes an array of Gegenbauer
    polynomials c.(n) = Cₙ⁽ˡ⁾(x) for n = 0, 1, 2,̣..., [Array.length c - 1].
    Constraints: l > -1/2. *)


(** {2 Hypergeometric functions} *)

<< hyperg_0F1 float float >>
(** [hyperg_0F1 c x] computes the hypergeometric function ₀F₁(c; x).*)

<< hyperg_1F1_int int int float >>
(** [hyperg_1F1_int m n x] computes the confluent hypergeometric
   function ₁F₁(m;n;x) = M(m,n,x) for integer parameters [m], [n].  *)

<< hyperg_1F1 float float float >>
(** [hyperg_1F1 a b x] computes the confluent hypergeometric function
   ₁F₁(a;b;x) = M(a,b,x) for general parameters [a], [b]. *)

<< hyperg_U_int int int float >>
(** [hyperg_U_int m n x] computes the confluent hypergeometric function
   U(m,n,x) for integer parameters [m], [n]. *)

<:ext< hyperg_U_int_e10@ml_gsl_sf_hyperg_U_int_e10_e,int,int,float,result_e10 >>
(** [hyperg_U_int_e10] computes the confluent hypergeometric function
   U(m,n,x) for integer parameters [m], [n] with extended range. *)

<< hyperg_U float float float >>
(** [hyperg_U a b x] computes the confluent hypergeometric function U(a,b,x). *)

<:ext< hyperg_U_e10@ml_gsl_sf_hyperg_U_e10_e,float,float,float,result_e10 >>
(** [hyperg_U_e10 a b x] computes the confluent hypergeometric function
   U(a,b,x) with extended range. *)

<< hyperg_2F1 float float float float >>
(** [hyperg_2F1 a b c x] computes the Gauss hypergeometric function
   ₂F₁(a,b,c,x) = F(a,b,c,x) for |x| < 1.

   If the arguments (a,b,c,x) are too close to a singularity then the
   function can raise the exception [Error.Gsl_exn(Error.EMAXITER, _)]
   when the series approximation converges too slowly.  This occurs in
   the region of [x]=1, [c - a - b] ∈ ℤ. *)

<< hyperg_2F1_conj float float float float >>
(** [hyperg_2F1_conj aR aI c x] computes the Gauss hypergeometric
   function ₂F₁(aR + i aI, aR - i aI, c, x) with complex parameters
   for |x| < 1. *)

<< hyperg_2F1_renorm float float float float >>
(** [hyperg_2F1_renorm a b c x] computes the renormalized Gauss
   hypergeometric function ₂F₁(a,b,c,x) / Γ(c) for |x| < 1. *)

<< hyperg_2F1_conj_renorm float float float float >>
(** [hyperg_2F1_conj_renorm aR aI c x] computes the renormalized Gauss
   hypergeometric function ₂F₁(aR + i aI, aR - i aI, c, x) / Γ(c) for
   |x| < 1. *)

<< hyperg_2F0 float float float >>
(** [hyperg_2F0 a b x] computes the hypergeometric function ₂F₀(a,b,x).
   The series representation is a divergent hypergeometric series.
   However, for x < 0 we have ₂F₀(a,b,x) = (-1/x)ᵃ U(a,1+a-b,-1/x) *)


(** {2 Laguerre functions} *)

<< laguerre_1 float float >>
<< laguerre_2 float float >>
<< laguerre_3 float float >>
<< laguerre_n int float float >>

(** {2 Lambert W functions} *)

<< lambert_W0 float >>
<< lambert_Wm1 float >>

(** {2 Legendre functions} *)

<< legendre_P1 float >>
<< legendre_P2 float >>
<< legendre_P3 float >>
<< legendre_Pl int float >>
<:ext< legendre_Pl_array@ml_gsl_sf_legendre_Pl_array,float,float array,unit >>
<< legendre_Q0 float >>
<< legendre_Q1 float >>
<< legendre_Ql int float >>

(** {2 Associated Legendre functions and Spherical Harmonics} *)

(** Normalization of Legendre functions.
    See {{:https://www.gnu.org/software/gsl/manual/html_node/Associated-Legendre-Polynomials-and-Spherical-Harmonics.html#Associated-Legendre-Polynomials-and-Spherical-Harmonics}
    the GSL documentation}. *)
type legendre_t =
  | Schmidt (** Specifies the computation of the Schmidt semi-normalized
                associated Legendre polynomials Sₗᵐ(x). *)
  | Spharm (** Specifies the computation of the spherical harmonic
               associated Legendre polynomials Yₗᵐ(x). *)
  | Full (** Specifies the computation of the fully normalized associated
             Legendre polynomials Nₗᵐ(x). *)
  | None (** Specifies the computation of the unnormalized associated
             Legendre polynomials Pₗᵐ(x). *)
(* FIXME: keep in the same order as the C definition in gsl_sf_legendre.h *)

(* FIXME: to avoid repetitive checks on the length of the array,
   it would be better to structure the code in a more abstract way. *)
<:ext< legendre_array@ml_gsl_sf_legendre_array,legendre_t,int,float,float array,unit >>
(** [legendre_array norm lmax x result] calculate all normalized
    associated Legendre polynomials for 0 ≤ [l] ≤ [lmax] and
    [0 ≤ m ≤ l] for [|x| ≤ 1].  The [norm] parameter specifies which
    normalization is used.  The normalized Pₗᵐ(x) values are stored in
    [result], whose minimum size can be obtained from calling
    {!legendre_array_n}.  The array index of Pₗᵐ(x) is obtained from
    calling {!legendre_array_index}[(l, m)].  To include or exclude
    the Condon-Shortley phase factor of (-1)ᵐ, set the parameter
    csphase to either -1 or 1 respectively in the _e function. This
    factor is included by default.  *)

(* FIXME: more associated Legendre functions to bind. *)

<:ext< legendre_array_n@ml_gsl_sf_legendre_array_n,int,int >>
(** [legendre_array_n lmax] returns the minimum array size for maximum
    degree lmax needed for the array versions of the associated
    Legendre functions.  Size is calculated as the total number of
    Pₗᵐ(x) functions, plus extra space for precomputing multiplicative
    factors used in the recurrence relations.  *)

<:ext< legendre_array_index@ml_gsl_sf_legendre_array_index,int,int,int >>
(** [legendre_array_index l m] returns the index into the [result]
    array of {!legendre_array}, {!legendre_deriv_array},
    {!legendre_deriv_alt_array}, {!legendre_deriv2_array}, and
    {!legendre_deriv2_alt_array} corresponding to Pₗᵐ(x), ∂ₓPₗᵐ(x),
    or ∂ₓ²Pₗₗᵐ(x).  The index is given by l(l+1)/2 + m.  *)
(* FIXME: it would likely be more efficient to implement this function
   directly in OCaml. *)

<< legendre_Plm int int float >>
(** [legendre_Plm l m x] and [legendre_Plm_e l m x] compute the
    associated Legendre polynomial Pₗᵐ(x) for [m ≥ 0], [l ≥ m],
    [|x| ≤ 1].  *)

<< legendre_sphPlm int int float >>
(** [legendre_sphPlm l m x] and [legendre_Plm_e] compute the
    normalized associated Legendre polynomial √((2l+1)/(4\pi))
    √((l-m)!/(l+m)!) Pₗᵐ(x) suitable for use in spherical harmonics.
    The parameters must satisfy [m ≥ 0], [l ≥ m], [|x| ≤ 1].  Theses
    routines avoid the overflows that occur for the standard
    normalization of Pₗᵐ(x).  *)


(** {2 Logarithm and related functions} *)

<< log float >>
<< log_abs float >>
<:ext< log_complex_e@ml_gsl_sf_complex_log_e,float,float,result * result >>
<< log_1plusx float >>
<< log_1plusx_mx float >>

(** {2 Power function} *)

<< pow_int float int >>

(** {2 Psi (Digamma) function} *)

<< psi_int int >>
<< psi float >>
<< psi_1piy float >>
<:ext< psi_complex_e@ml_gsl_sf_complex_psi_e,float,float,result * result >>
<< psi_1_int int >>
<< psi_1 float >>
<< psi_n int float >>

(** {2 Synchrotron functions} *)

<< synchrotron_1 float >>
<< synchrotron_2 float >>

(** {2 Transport functions} *)

<< transport_2 float >>
<< transport_3 float >>
<< transport_4 float >>
<< transport_5 float >>

(** {2 Trigonometric functions} *)

<< sin float @float >>
<< cos float @float >>
<< hypot float float >>
<< sinc float @float >>
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

(** {2 Zeta functions} *)

<< zeta_int int >>
<< zeta float >>
<< hzeta float float >>
<< eta_int int >>
<< eta float >>
