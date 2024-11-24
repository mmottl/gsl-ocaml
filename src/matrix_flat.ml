(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2012 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)

let () = Error.init ()

type double_mat_flat = {
  data : float array;
  off : int;
  dim1 : int;
  dim2 : int;
  tda : int;
}

type matrix = double_mat_flat

let create ?(init = 0.) dim1 dim2 =
  { data = Array.make (dim1 * dim2) init; off = 0; dim1; dim2; tda = dim2 }

let dims mat = (mat.dim1, mat.dim2)

let of_arrays arr =
  let dim1 = Array.length arr in
  if dim1 = 0 then invalid_arg "of_arrays";
  let dim2 = Array.length arr.(0) in
  let tab = Array.make (dim1 * dim2) 0. in
  Array.iteri
    (fun i a ->
      if Array.length a <> dim2 then invalid_arg "of_arrays";
      Array.blit a 0 tab (i * dim2) dim2)
    arr;
  { data = tab; off = 0; dim1; dim2; tda = dim2 }

let to_array mat =
  if mat.tda = mat.dim2 && mat.off = 0 then Array.copy mat.data
  else
    let arr = Array.make (mat.dim1 * mat.dim2) 0. in
    for i = 0 to pred mat.dim1 do
      Array.blit mat.data (mat.off + (i * mat.tda)) arr (i * mat.dim2) mat.dim2
    done;
    arr

let to_arrays mat =
  let arr = Array.make_matrix mat.dim1 mat.dim2 0. in
  for i = 0 to pred mat.dim1 do
    Array.blit mat.data (mat.off + (i * mat.tda)) arr.(i) 0 mat.dim2
  done;
  arr

let of_array arr dim1 dim2 =
  let len = Array.length arr in
  if dim1 * dim2 <> len then invalid_arg "of_array";
  { data = Array.copy arr; off = 0; dim1; dim2; tda = dim2 }

let get m i j = m.data.(m.off + (i * m.tda) + j)
let set m i j x = m.data.(m.off + (i * m.tda) + j) <- x

let set_all m x =
  for i = 0 to pred m.dim1 do
    Array.fill m.data (m.off + (i * m.tda)) m.dim2 x
  done

let set_zero m = set_all m 0.

let set_id m =
  set_zero m;
  for i = 0 to pred (min m.dim1 m.dim2) do
    set m i i 1.
  done

let memcpy ~src:m ~dst:m' =
  if m.dim1 <> m'.dim1 || m.dim2 <> m'.dim2 then invalid_arg "wrong dimensions";
  for i = 0 to pred m.dim1 do
    Array.blit m.data
      (m.off + (i * m.tda))
      m'.data
      (m'.off + (i * m'.tda))
      m.dim2
  done

let copy m =
  let m' = create m.dim1 m.dim2 in
  memcpy ~src:m ~dst:m';
  m'

let submatrix m ~k1 ~k2 ~n1 ~n2 =
  { m with off = m.off + (k1 * m.tda) + k2; dim1 = n1; dim2 = n2; tda = m.tda }

let row m i =
  Vector_flat.view_array ~off:(m.off + (i * m.tda)) ~len:m.dim2 m.data

let column m j =
  Vector_flat.view_array ~stride:m.tda ~off:(m.off + j) ~len:m.dim1 m.data

let diagonal m =
  Vector_flat.view_array ~stride:(m.tda + 1) ~off:m.off ~len:(min m.dim1 m.dim2)
    m.data

let subdiagonal m k =
  Vector_flat.view_array ~stride:(m.tda + 1)
    ~off:(m.off + (k * m.tda))
    ~len:(min (m.dim1 - k) m.dim2)
    m.data

let superdiagonal m k =
  Vector_flat.view_array ~stride:(m.tda + 1) ~off:(m.off + k)
    ~len:(min m.dim1 (m.dim2 - k))
    m.data

let view_array arr ?(off = 0) dim1 ?tda dim2 =
  let tda = match tda with None -> dim2 | Some v -> v in
  let len = Array.length arr in
  if dim1 * tda > len - off || dim2 > tda then invalid_arg "view_array";
  { data = arr; off; dim1; dim2; tda }

let view_vector v ?(off = 0) dim1 ?tda dim2 =
  let tda = match tda with None -> dim2 | Some v -> v in
  let len = Vector_flat.length v in
  if dim1 * tda > len - off || dim2 > tda then invalid_arg "view_vector";
  { data = v.Vector_flat.data; off = v.Vector_flat.off + off; dim1; dim2; tda }

external add : matrix -> matrix -> unit = "ml_gsl_matrix_add"
external sub : matrix -> matrix -> unit = "ml_gsl_matrix_sub"
external mul_elements : matrix -> matrix -> unit = "ml_gsl_matrix_mul"
external div_elements : matrix -> matrix -> unit = "ml_gsl_matrix_div"
external scale : matrix -> float -> unit = "ml_gsl_matrix_scale"
external add_constant : matrix -> float -> unit = "ml_gsl_matrix_add_constant"
external add_diagonal : matrix -> float -> unit = "ml_gsl_matrix_add_diagonal"
external is_null : matrix -> bool = "ml_gsl_matrix_isnull"
external swap_rows : matrix -> int -> int -> unit = "ml_gsl_matrix_swap_rows"

external swap_columns : matrix -> int -> int -> unit
  = "ml_gsl_matrix_swap_columns"

external swap_rowcol : matrix -> int -> int -> unit
  = "ml_gsl_matrix_swap_rowcol"

external transpose : matrix -> matrix -> unit = "ml_gsl_matrix_transpose_memcpy"
external transpose_in_place : matrix -> unit = "ml_gsl_matrix_transpose"
