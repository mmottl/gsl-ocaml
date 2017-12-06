(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2012 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)


let () = Error.init ()

type t
type accel
type interp_type =
  | LINEAR
  | POLYNOMIAL
  | CSPLINE
  | CSPLINE_PERIODIC
  | AKIMA
  | AKIMA_PERIODIC

external _alloc : interp_type -> int -> t 
    = "ml_gsl_interp_alloc"
external _free : t -> unit
    = "ml_gsl_interp_free"
let make t s =
  let i = _alloc t s in
  Gc.finalise _free i ;
  i
external _init : t -> float array -> float array -> int -> unit
    = "ml_gsl_interp_init"

let init i x y = 
  let lx = Array.length x in
  let ly = Array.length y in
  if lx <> ly
  then invalid_arg "Interp: init" ;
  _init i x y lx

external name : t -> string 
    = "ml_gsl_interp_name"

external min_size : t -> int
    = "ml_gsl_interp_min_size"

external _accel_alloc : unit -> accel
    = "ml_gsl_interp_accel_alloc"
external _accel_free : accel -> unit
    = "ml_gsl_interp_accel_free"
let make_accel () =
  let a = _accel_alloc () in
  Gc.finalise _accel_free a ;
  a
external i_eval : t -> float array -> float array 
  -> float -> accel -> float
      = "ml_gsl_interp_eval"

external i_eval_deriv : t -> float array -> float array 
  -> float -> accel -> float
      = "ml_gsl_interp_eval_deriv"

external i_eval_deriv2 : t -> float array -> float array 
  -> float -> accel -> float
      = "ml_gsl_interp_eval_deriv2"

external i_eval_integ : t -> float array -> float array 
  -> float -> float -> accel -> float
      = "ml_gsl_interp_eval_integ_bc" "ml_gsl_interp_eval_integ"


(* Higher level functions *)
type interp = {
    interp : t ;
    accel  : accel ;
    xa     : float array ;
    ya     : float array ;
    size   : int ;
    i_type : interp_type ;
  }

let make_interp i_type x y =
  let len = Array.length x in
  let ly = Array.length y in
  if len <> ly
  then invalid_arg "Interp.make" ;
  let t = _alloc i_type len in
  let a = _accel_alloc () in
  let v = { interp=t; accel = a ;
    xa=x; ya=y; size=len; i_type=i_type } in
  Gc.finalise (fun v -> _free v.interp ; _accel_free v.accel) v ;
  init t x y ;
  v

let eval interp x =
  i_eval interp.interp interp.xa interp.ya x interp.accel

external eval_array : interp -> float array -> float array -> unit
    = "ml_gsl_interp_eval_array"

let eval_deriv interp x =
  i_eval_deriv interp.interp interp.xa interp.ya x interp.accel

let eval_deriv2 interp x =
  i_eval_deriv2 interp.interp interp.xa interp.ya x interp.accel

let eval_integ interp a b  =
  i_eval_integ interp.interp interp.xa interp.ya a b interp.accel
