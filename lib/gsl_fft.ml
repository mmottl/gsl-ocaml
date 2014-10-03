(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2012 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)

open Gsl_complex

exception Wrong_layout

let _ = 
  Callback.register_exception "mlgsl_layout_exn" Wrong_layout

type layout = 
  | Real 
  | Halfcomplex 
  | Halfcomplex_rad2
  | Complex

type fft_array = {
    mutable layout : layout ;
    data : float array }

let check_layout layout a = 
  if a.layout <> layout
  then raise Wrong_layout

module Real =
struct
  type workspace
  type wavetable

  external alloc_workspace : int -> workspace
      = "ml_gsl_fft_real_workspace_alloc"

  external alloc_wavetable : int -> wavetable
      = "ml_gsl_fft_real_wavetable_alloc"

  external free_workspace : workspace -> unit
      = "ml_gsl_fft_real_workspace_free"

  external free_wavetable : wavetable -> unit
      = "ml_gsl_fft_real_wavetable_free"

  let make_workspace size = 
    let ws = alloc_workspace size in
    Gc.finalise free_workspace ws ;
    ws

  let make_wavetable size =
    let wt = alloc_wavetable size in
    Gc.finalise free_wavetable wt ;
    wt

  external transform : 
      ?stride:int -> fft_array -> wavetable -> workspace -> unit
      = "ml_gsl_fft_real_transform"

  external transform_rad2 : 
      ?stride:int -> fft_array -> unit
      = "ml_gsl_fft_real_radix2_transform"

  external ex_unpack :
      ?stride:int -> float array -> float array -> unit
      = "ml_gsl_fft_real_unpack"

  let unpack ?(stride=1) r_arr = 
    if r_arr.layout <> Real
    then raise Wrong_layout ;
    let c_arr = Array.make (2 * (Array.length r_arr.data) / stride) 0. in
    ex_unpack ~stride r_arr.data c_arr ;
    { layout = Complex ; data = c_arr }

end

module Halfcomplex =
struct
  type wavetable

  external alloc_wavetable : int -> wavetable
      = "ml_gsl_fft_halfcomplex_wavetable_alloc"

  external free_wavetable : wavetable -> unit
      = "ml_gsl_fft_halfcomplex_wavetable_free"

  let make_wavetable size =
    let wt = alloc_wavetable size in
    Gc.finalise free_wavetable wt ;
    wt

  external transform : 
      ?stride:int -> fft_array -> wavetable -> Real.workspace -> unit
      = "ml_gsl_fft_halfcomplex_transform"

  external transform_rad2 : 
      ?stride:int -> fft_array -> unit
      = "ml_gsl_fft_halfcomplex_radix2_transform"

  external backward : 
      ?stride:int -> fft_array -> wavetable -> Real.workspace -> unit
      = "ml_gsl_fft_halfcomplex_backward"

  external backward_rad2 : 
      ?stride:int -> fft_array -> unit
      = "ml_gsl_fft_halfcomplex_radix2_backward"

  external inverse : 
      ?stride:int -> fft_array -> wavetable -> Real.workspace -> unit
      = "ml_gsl_fft_halfcomplex_inverse"

  external inverse_rad2 : 
      ?stride:int -> fft_array -> unit
      = "ml_gsl_fft_halfcomplex_radix2_inverse"

  external ex_unpack :
      ?stride:int -> float array -> float array -> unit
      = "ml_gsl_fft_halfcomplex_unpack"

  external ex_unpack_rad2 :
      ?stride:int -> float array -> float array -> unit
      = "ml_gsl_fft_halfcomplex_unpack_rad2"

  let unpack ?(stride=1) hc_arr = 
    match hc_arr.layout with
    | Halfcomplex ->
	let c_arr = Array.make (2 * (Array.length hc_arr.data) / stride) 0. in
	ex_unpack ~stride hc_arr.data c_arr ;
	{ layout = Complex ; data = c_arr }
    | Halfcomplex_rad2 ->
	let c_arr = Array.make (2 * (Array.length hc_arr.data) / stride) 0. in
	ex_unpack_rad2 ~stride hc_arr.data c_arr ;
	{ layout = Complex ; data = c_arr }
    | _ -> raise Wrong_layout
end

module Complex =
struct
  type workspace
  type wavetable
  type direction = Forward | Backward

  external alloc_workspace : int -> workspace
      = "ml_gsl_fft_complex_workspace_alloc"

  external alloc_wavetable : int -> wavetable
      = "ml_gsl_fft_complex_wavetable_alloc"

  external free_workspace : workspace -> unit
      = "ml_gsl_fft_complex_workspace_free"

  external free_wavetable : wavetable -> unit
      = "ml_gsl_fft_complex_wavetable_free"

  let make_workspace size = 
    let ws = alloc_workspace size in
    Gc.finalise free_workspace ws ;
    ws

  let make_wavetable size =
    let wt = alloc_wavetable size in
    Gc.finalise free_wavetable wt ;
    wt

  external forward :
      ?stride:int -> complex_array -> wavetable -> workspace -> unit
      = "ml_gsl_fft_complex_forward"

  external forward_rad2 : 
      ?dif:bool -> ?stride:int -> complex_array -> unit
      = "ml_gsl_fft_complex_rad2_forward"

  external transform : 
      ?stride:int -> complex_array -> wavetable -> workspace -> direction -> unit
      = "ml_gsl_fft_complex_transform"

  external transform_rad2 : 
      ?dif:bool -> ?stride:int -> complex_array -> direction -> unit
      = "ml_gsl_fft_complex_rad2_transform"

  external backward : 
      ?stride:int -> complex_array -> wavetable -> workspace -> unit
      = "ml_gsl_fft_complex_backward"

  external backward_rad2 : 
      ?dif:bool -> ?stride:int -> complex_array -> unit
      = "ml_gsl_fft_complex_rad2_backward"

  external inverse : 
      ?stride:int -> complex_array -> wavetable -> workspace -> unit
      = "ml_gsl_fft_complex_inverse"

  external inverse_rad2 : 
      ?dif:bool -> ?stride:int -> complex_array -> unit
      = "ml_gsl_fft_complex_rad2_inverse"

end

let unpack = function
  | { layout = Real } as f ->
      (Real.unpack f).data
  | { layout = Halfcomplex } | { layout = Halfcomplex_rad2 } as f ->
      (Halfcomplex.unpack f).data
  | { layout = Complex ; data = d } ->
      d

let hc_mult
    ({ data = a } as fa)
    ({ data = b } as fb) =
  check_layout Halfcomplex fa ;
  check_layout Halfcomplex fb ;
  let len = Array.length a in
  if Array.length b <> len
  then invalid_arg "hc_mult: array sizes differ" ;
  a.(0) <- a.(0) *. b.(0) ;
  for i=1 to (pred len) / 2 do
    let a_re = a.(2*i - 1) in
    let a_im = a.(2*i) in
    let b_re = b.(2*i - 1) in
    let b_im = b.(2*i) in
    a.(2* i-1) <- a_re *. b_re -. a_im *. b_im ;
    a.(2* i) <- a_re *. b_im +. a_im *. b_re ;
  done ;
  if len mod 2 = 0
  then a.(pred len) <- a.(pred len) *. b.(pred len)

let hc_mult_rad2 ({data = a } as fa) ({data = b } as fb) = 
  check_layout Halfcomplex_rad2 fa ;
  check_layout Halfcomplex_rad2 fb ;
  let len = Array.length a in
  if Array.length b <> len
  then invalid_arg "hc_mult_rad2: array sizes differ" ;
  a.(0) <- a.(0) *. b.(0) ;
  for i=1 to (pred len) / 2 do
    let a_re = a.(i) in
    let a_im = a.(len - i) in
    let b_re = b.(i) in
    let b_im = b.(len - i) in
    a.(i) <- a_re *. b_re -. a_im *. b_im ;
    a.(len - i) <- a_re *. b_im +. a_im *. b_re ;
  done ;
  a.(len/2) <- a.(len/2) *. b.(len/2)
