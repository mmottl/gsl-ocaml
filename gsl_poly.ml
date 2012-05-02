(* gsl-ocaml - OCaml interface to GSL                        *)
(* Copyright (©) 2002-2005 - Olivier Andrieu                *)
(* distributed under the terms of the GPL version 2         *)

open Gsl_complex

type poly = float array

external eval : poly -> float -> float 
    = "ml_gsl_poly_eval"

type quad_sol =
  | Quad_0
  | Quad_2 of float * float
external solve_quadratic : a:float -> b:float -> c:float -> quad_sol
    = "ml_gsl_poly_solve_quadratic"

external complex_solve_quadratic : a:float -> b:float -> c:float -> complex * complex
    = "ml_gsl_poly_complex_solve_quadratic"

type cubic_sol =
  | Cubic_0
  | Cubic_1 of float 
  | Cubic_3 of float * float * float
external solve_cubic : a:float -> b:float -> c:float -> cubic_sol
    = "ml_gsl_poly_solve_cubic"

external complex_solve_cubic : a:float -> b:float -> c:float -> complex * complex * complex
    = "ml_gsl_poly_complex_solve_cubic"

type ws
external _alloc_ws : int -> ws = "ml_gsl_poly_complex_workspace_alloc"
external _free_ws  : ws -> unit= "ml_gsl_poly_complex_workspace_free"

external _solve    : poly -> ws -> complex_array -> unit
    = "ml_gsl_poly_complex_solve"

let solve poly = 
  let n = Array.length poly in
  let ws = _alloc_ws n in
  try
    let sol = Array.make (2*(n-1)) 0. in
    _solve poly ws sol ;
    _free_ws ws ;
    sol
  with exn ->
    _free_ws ws ; raise exn

