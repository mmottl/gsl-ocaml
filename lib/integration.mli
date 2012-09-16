(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2012 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)

(** Numerical Integration *)

open Fun

external qng :
  gsl_fun -> a:float -> b:float -> 
    epsabs:float -> epsrel:float -> float * float * int
  = "ml_gsl_integration_qng"

type workspace
val make_ws : int -> workspace
external size : workspace -> int
    = "ml_gsl_integration_ws_size"

type key = 
  | GAUSS15
  | GAUSS21 
  | GAUSS31
  | GAUSS41
  | GAUSS51
  | GAUSS61

external qag :
    gsl_fun -> a:float -> b:float -> epsabs:float -> epsrel:float ->
      ?limit:int -> key -> workspace -> result
    = "ml_gsl_integration_qag_bc" "ml_gsl_integration_qag"

external qags :
    gsl_fun -> a:float -> b:float -> epsabs:float -> epsrel:float ->
      ?limit:int -> workspace -> result
    = "ml_gsl_integration_qags_bc" "ml_gsl_integration_qags"

external qagp :
    gsl_fun -> pts:float array -> epsabs:float -> epsrel:float ->
      ?limit:int -> workspace -> result
    = "ml_gsl_integration_qagp_bc" "ml_gsl_integration_qagp"

external qagi :
    gsl_fun -> epsabs:float -> epsrel:float ->
      ?limit:int -> workspace -> result
    = "ml_gsl_integration_qagi"

external qagiu :
    gsl_fun -> a:float -> epsabs:float -> epsrel:float ->
      ?limit:int -> workspace -> result
    = "ml_gsl_integration_qagiu_bc" "ml_gsl_integration_qagiu"

external qagil :
    gsl_fun -> b:float -> epsabs:float -> epsrel:float ->
      ?limit:int -> workspace -> result
    = "ml_gsl_integration_qagil_bc" "ml_gsl_integration_qagil"

val qag_sing : gsl_fun -> a:float -> b:float -> ?pts:float array ->
  ?limit:int ->  epsabs:float -> epsrel:float -> unit -> result

external qawc :
    gsl_fun -> a:float -> b:float -> c:float ->
      epsabs:float -> epsrel:float ->
	?limit:int -> workspace -> result
    = "ml_gsl_integration_qawc_bc" "ml_gsl_integration_qawc"

type qaws_table
external alloc_qaws : alpha:float -> beta:float -> 
  mu:int -> nu:int -> qaws_table
    = "ml_gsl_integration_qaws_table_alloc"
external set_qaws : qaws_table -> alpha:float -> beta:float -> 
  mu:int -> nu:int -> unit
    = "ml_gsl_integration_qaws_table_set"
external free_qaws : qaws_table -> unit
    = "ml_gsl_integration_qaws_table_free"
external qaws :
    gsl_fun -> a:float -> b:float -> qaws_table ->
      epsabs:float -> epsrel:float ->
	?limit:int -> workspace -> result
    = "ml_gsl_integration_qaws_bc" "ml_gsl_integration_qaws"

type qawo_table
type qawo_sine =
  | QAWO_COSINE
  | QAWO_SINE
external alloc_qawo : omega:float -> l:float -> 
  qawo_sine -> n:int -> qawo_table
    = "ml_gsl_integration_qawo_table_alloc"
external set_qawo : qawo_table -> omega:float -> l:float -> 
  qawo_sine -> unit
    = "ml_gsl_integration_qawo_table_set"
external free_qawo : qawo_table -> unit
    = "ml_gsl_integration_qawo_table_free"

external qawo :
    gsl_fun -> a:float -> epsabs:float -> epsrel:float ->
	?limit:int -> workspace -> qawo_table -> result
    = "ml_gsl_integration_qawo_bc" "ml_gsl_integration_qawo"
	    
external qawf :
    gsl_fun -> a:float -> epsabs:float ->
      ?limit:int -> workspace -> workspace -> qawo_table -> result
    = "ml_gsl_integration_qawf_bc" "ml_gsl_integration_qawf"
