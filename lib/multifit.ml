(* gsl-ocaml - OCaml interface to GSL                        *)
(* Copyright (©) 2002-2005 - Olivier Andrieu                *)
(* distributed under the terms of the GPL version 2         *)

open Vectmat

type ws
external alloc_ws : int -> int -> ws
    = "ml_gsl_multifit_linear_alloc"

external free_ws : ws -> unit
    = "ml_gsl_multifit_linear_free"

let make ~n ~p =
  let ws = alloc_ws n p in
  Gc.finalise free_ws ws ;
  ws

external _linear : ?weight:vec -> x:mat -> y:vec -> c:vec -> cov:mat -> 
      ws -> float
	  = "ml_gsl_multifit_linear_bc" "ml_gsl_multifit_linear"

external _linear_svd : 
  ?weight:vec -> x:mat -> y:vec -> 
  tol:float -> c:vec -> cov:mat -> 
  ws -> int * float
    = "ml_gsl_multifit_linear_svd_bc" "ml_gsl_multifit_linear_svd"

let linear ?weight x y =
  let (n,p) = Vectmat.dims x in
  let dy = Vectmat.length y in
  if dy <> n
  then invalid_arg "Multifit.linear: wrong dimensions" ;
  Misc.may weight 
    (fun w -> 
      if Vectmat.length w <> n
      then invalid_arg "Multifit.linear: wrong dimensions") ;
  let c = Vector.create p in
  let cov = Matrix.create p p in
  let ws = alloc_ws n p in
  try
    let chisq = _linear ?weight ~x ~y ~c:(`V c) ~cov:(`M cov) ws in
    free_ws ws ;
    (c, cov, chisq)
  with exn ->
    free_ws ws ; raise exn

external linear_est : x:vec -> c:vec -> cov:mat -> Fun.result
    = "ml_gsl_multifit_linear_est"

let fit_poly ?weight ~x ~y order =
  let n = Array.length y in
  let x_mat = Matrix.create n (succ order) in
  for i=0 to pred n do
    let xi = x.(i) in
    for j=0 to order do
      x_mat.{i, j} <- Math.pow_int xi j
    done
  done ;
  let weight = match weight with
  | None -> None
  | Some a -> Some (vec_convert (`A a)) in
  let (c, cov, chisq) = 
    linear ?weight (`M x_mat) (vec_convert (`A y)) in
  (Vector.to_array c,
   Matrix.to_arrays cov,
   chisq)
