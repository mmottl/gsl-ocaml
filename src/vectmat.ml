(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2012 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)

let () = Error.init ()

type vec = [ `V of Vector.vector | `VF of Vector_flat.vector ]

let vec_convert ?(protect = false) = function
  | `A arr when protect -> `VF (Vector_flat.of_array arr)
  | `A arr -> `VF (Vector_flat.view_array arr)
  | `VF vec when protect -> `VF (Vector_flat.copy vec)
  | `VF _ as v -> v
  | `V vec when protect -> `V (Vector.copy vec)
  | `V _ as v -> v

type mat = [ `M of Matrix.matrix | `MF of Matrix_flat.matrix ]

let mat_convert ?(protect = false) = function
  | `M mat when protect -> `M (Matrix.copy mat)
  | `M _ as m -> m
  | `MF mat when protect -> `MF (Matrix_flat.copy mat)
  | `MF _ as m -> m
  | `A (arr, d1, d2) when protect -> `MF (Matrix_flat.of_array arr d1 d2)
  | `A (arr, d1, d2) -> `MF (Matrix_flat.view_array arr d1 d2)
  | `AA arr -> `MF (Matrix_flat.of_arrays arr)

let mat_flat ?(protect = false) = function
  | `M mat ->
      let d1, d2 = Matrix.dims mat in
      let arr = Matrix.to_array mat in
      Matrix_flat.view_array arr d1 d2
  | `MF mat when protect -> Matrix_flat.copy mat
  | `MF mat -> mat
  | `A (arr, d1, d2) when protect -> Matrix_flat.of_array arr d1 d2
  | `A (arr, d1, d2) -> Matrix_flat.view_array arr d1 d2
  | `AA arr -> Matrix_flat.of_arrays arr

(* Complex values *)

type cvec = [ `CV of Vector_complex.vector | `CVF of Vector_complex_flat.vector ]
type cmat = [ `CM of Matrix_complex.matrix | `CMF of Matrix_complex_flat.matrix ]

let cmat_convert ?(protect = false) = function
  | `CM mat when protect -> `CM (Matrix_complex.copy mat)
  | `CM _ as m -> m
  | `CMF mat when protect -> `CMF (Matrix_complex_flat.copy mat)
  | `CMF _ as m -> m
  | `CA (arr, d1, d2) when protect ->
      `CMF (Matrix_complex_flat.of_complex_array arr d1 d2)
  | `CA (arr, d1, d2) -> `CMF (Matrix_complex_flat.view_complex_array arr d1 d2)

(* Generic vector operations *)

let length = function
  | `VF v -> Vector_flat.length v
  | `V v -> Vector.length v
  | `CV v -> Vector_complex.length v
  | `CVF v -> Vector_complex_flat.length v

let to_array = function
  | `VF v -> Vector_flat.to_array v
  | `V v -> Vector.to_array v

let v_copy = function
  | `VF v -> `VF (Vector_flat.copy v)
  | `V v -> `V (Vector.copy v)

let subvector v ~off ~len =
  match v with
  | `VF v -> `VF (Vector_flat.subvector v ~off ~len)
  | `V v -> `V (Vector.subvector v ~off ~len)

external v_memcpy : [< vec ] -> [< vec ] -> unit = "ml_gsl_vector_memcpy"
external v_add : [< vec ] -> [< vec ] -> unit = "ml_gsl_vector_add"
external v_sub : [< vec ] -> [< vec ] -> unit = "ml_gsl_vector_sub"
external v_mul : [< vec ] -> [< vec ] -> unit = "ml_gsl_vector_mul"
external v_div : [< vec ] -> [< vec ] -> unit = "ml_gsl_vector_div"
external v_scale : [< vec ] -> float -> unit = "ml_gsl_vector_scale"

external v_add_constant : [< vec ] -> float -> unit
  = "ml_gsl_vector_add_constant"

external v_is_null : [< vec ] -> bool = "ml_gsl_vector_isnull"
external v_max : [< vec ] -> float = "ml_gsl_vector_max"
external v_min : [< vec ] -> float = "ml_gsl_vector_min"
external v_minmax : [< vec ] -> float * float = "ml_gsl_vector_minmax"
external v_max_index : [< vec ] -> int = "ml_gsl_vector_maxindex"
external v_min_index : [< vec ] -> int = "ml_gsl_vector_minindex"
external v_minmax_index : [< vec ] -> int * int = "ml_gsl_vector_minmaxindex"

(* Generic matrix operations *)

let dims = function
  | `MF v -> Matrix_flat.dims v
  | `M v -> Matrix.dims v
  | `CM m -> Matrix_complex.dims m
  | `CMF m -> Matrix_complex_flat.dims m

let to_arrays = function
  | `M mat -> Matrix.to_arrays mat
  | `MF mat -> Matrix_flat.to_arrays mat

let tmp mat =
  let d1, d2 = dims mat in
  `M (Matrix.create d1 d2)

let m_copy = function
  | `MF v -> `MF (Matrix_flat.copy v)
  | `M v -> `M (Matrix.copy v)

external m_memcpy : [< mat ] -> [< mat ] -> unit = "ml_gsl_matrix_memcpy"
external m_add : [< mat ] -> [< mat ] -> unit = "ml_gsl_matrix_add"
external m_sub : [< mat ] -> [< mat ] -> unit = "ml_gsl_matrix_sub"
external m_mul : [< mat ] -> [< mat ] -> unit = "ml_gsl_matrix_mul"
external m_div : [< mat ] -> [< mat ] -> unit = "ml_gsl_matrix_div"
external m_scale : [< mat ] -> float -> unit = "ml_gsl_matrix_scale"

external m_add_constant : [< mat ] -> float -> unit
  = "ml_gsl_matrix_add_constant"

external m_add_diagonal : [< mat ] -> float -> unit
  = "ml_gsl_matrix_add_diagonal"

external m_is_null : [< mat ] -> bool = "ml_gsl_matrix_isnull"
external swap_rows : [< mat ] -> int -> int -> unit = "ml_gsl_matrix_swap_rows"

external swap_columns : [< mat ] -> int -> int -> unit
  = "ml_gsl_matrix_swap_columns"

external swap_rowcol : [< mat ] -> int -> int -> unit
  = "ml_gsl_matrix_swap_rowcol"

external transpose : [< mat ] -> [< mat ] -> unit
  = "ml_gsl_matrix_transpose_memcpy"

external transpose_in_place : [< mat ] -> unit = "ml_gsl_matrix_transpose"

let is_null x =
  match x with
  | (`VF _ | `V _) as v -> v_is_null v
  | (`MF _ | `M _) as m -> m_is_null m

let scale x c =
  match x with
  | (`VF _ | `V _) as v -> v_scale v c
  | (`MF _ | `M _) as m -> m_scale m c

let add_constant x c =
  match x with
  | (`VF _ | `V _) as v -> v_add_constant v c
  | (`MF _ | `M _) as m -> m_add_constant m c
