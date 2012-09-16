(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2012 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)

(** Polynomials *)

open Gsl_complex
type poly = float array

(** {3 Polynomial Evaluation} *)

external eval : poly -> float -> float 
    = "ml_gsl_poly_eval"

(** {3 Quadratic Equations} *)

type quad_sol = 
  | Quad_0 
  | Quad_2 of float * float
external solve_quadratic : a:float -> b:float -> c:float -> quad_sol
    = "ml_gsl_poly_solve_quadratic"

external complex_solve_quadratic : 
    a:float -> b:float -> c:float -> complex * complex
	= "ml_gsl_poly_complex_solve_quadratic"

(** {3 Cubic Equations} *)

type cubic_sol =
  | Cubic_0
  | Cubic_1 of float
  | Cubic_3 of float * float * float
external solve_cubic : a:float -> b:float -> c:float -> cubic_sol
    = "ml_gsl_poly_solve_cubic"

external complex_solve_cubic :
  a:float -> b:float -> c:float -> complex * complex * complex
      = "ml_gsl_poly_complex_solve_cubic"


(** {3 General Polynomial Equations} *)

val solve : poly -> complex_array
