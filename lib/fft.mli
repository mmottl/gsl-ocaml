(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2012 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)

(** Fast Fourier Transforms *)

open Gsl_complex

exception Wrong_layout

type layout = 
  | Real 
  | Halfcomplex 
  | Halfcomplex_rad2
  | Complex

type fft_array = {
    mutable layout : layout ;
    data : float array }

module Real :
  sig
    type workspace
    type wavetable

    val make_workspace : int -> workspace
    val make_wavetable : int -> wavetable

    external transform :
      ?stride:int -> fft_array -> wavetable -> workspace -> unit
      = "ml_gsl_fft_real_transform"

    external transform_rad2 : 
      ?stride:int -> fft_array -> unit
      = "ml_gsl_fft_real_radix2_transform"

    val unpack : ?stride:int -> fft_array -> fft_array
  end

module Halfcomplex :
  sig
    type wavetable

    val make_wavetable : int -> wavetable

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

    val unpack : ?stride:int -> fft_array -> fft_array
  end

module Complex :
  sig
    type workspace
    type wavetable
    type direction = Forward | Backward

    val make_workspace : int -> workspace
    val make_wavetable : int -> wavetable

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

val unpack : fft_array -> complex_array

val hc_mult      : fft_array -> fft_array -> unit
val hc_mult_rad2 : fft_array -> fft_array -> unit
