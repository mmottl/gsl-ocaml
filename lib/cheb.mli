(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2012 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)

(** Chebyshev Approximations *)

type t

val make : int -> t

external order : t -> int
    = "ml_gsl_cheb_order"

external coefs : t -> float array = "ml_gsl_cheb_coefs"

external init : t -> Fun.gsl_fun -> a:float -> b:float -> unit
    = "ml_gsl_cheb_init"

val eval     : t -> ?order:int -> float -> float
val eval_err : t -> ?order:int -> float -> Fun.result

val deriv : t -> t
val integ : t -> t
