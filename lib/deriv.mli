(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2012 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)

(** Numerical Differentiation *)

external central : f:(float -> float) -> x:float -> h:float -> Fun.result
  = "ml_gsl_deriv_central"
(** [central f x h] computes the numerical derivative of the function [f] at the
    point [x] using an adaptive central difference algorithm with a step-size of
    [h]. The function returns a value [r] with the derivative being in [r.res]
    and an estimate of its absolute error in [r.err]. *)

external forward : f:(float -> float) -> x:float -> h:float -> Fun.result
  = "ml_gsl_deriv_forward"
(** [forward f x h] computes the numerical derivative of the function [f] at the
    point [x] using an adaptive forward difference algorithm with a step-size of
    [h]. The function is evaluated only at points greater than [x], and never at
    [x] itself. The function returns [r] with the derivative in [r.res] and an
    estimate of its absolute in [r.err]. This function should be used if f(x)
    has a discontinuity at [x], or is undefined for values less than [x]. *)

external backward : f:(float -> float) -> x:float -> h:float -> Fun.result
  = "ml_gsl_deriv_backward"
(** [forward f x h] computes the numerical derivative of the function [f] at the
    point [x] using an adaptive backward difference algorithm with a step-size
    of [h]. The function is evaluated only at points less than [x], and never at
    [x] itself. The function returns a value [r] with the derivative in [r.res]
    and an estimate of its absolute error in [r.err]. This function should be
    used if f(x) has a discontinuity at [x], or is undefined for values greater
    than [x]. *)
