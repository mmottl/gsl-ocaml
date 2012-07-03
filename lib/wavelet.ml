type t
type ws

type kind =
  | DAUBECHIES
  | DAUBECHIES_CENTERED
  | HAAR
  | HAAR_CENTERED
  | BSPLINE
  | BSPLINE_CENTERED

type direction =
  | FORWARD
  | BACKWARD

external _alloc : kind -> int -> t = "ml_gsl_wavelet_alloc"
external _free : t -> unit = "ml_gsl_wavelet_free"
let make kind size =
  let w = _alloc kind size in
  Gc.finalise _free w ;
  w

external name : t -> string = "ml_gsl_wavelet_name"

external _workspace_alloc : int -> ws = "ml_gsl_wavelet_workspace_alloc"
external _workspace_free  : ws -> unit = "ml_gsl_wavelet_workspace_free"
let workspace_make size =
  let ws = _workspace_alloc size in
  Gc.finalise _workspace_free ws ;
  ws
external workspace_size : ws -> int = "ml_gsl_wavelet_workspace_size"

external _transform : 
  t -> direction -> Vector_flat.vector -> ws -> unit 
  = "ml_gsl_wavelet_transform"
external _transform_bigarray : 
  t -> direction -> Vector.vector -> ws -> unit 
  = "ml_gsl_wavelet_transform_bigarray"

let with_workspace ws length f arg =
  let workspace = 
    match ws with 
    | Some ws -> ws
    | None -> _workspace_alloc (length arg) in
  try 
    f arg workspace ;
    if ws = None then _workspace_free workspace
  with exn ->
    if ws = None then _workspace_free workspace ;
    raise exn

let transform_vector_flat w dir ?ws =
  with_workspace ws 
    Vector_flat.length
    (_transform w dir)

let transform_vector w dir ?ws =
  with_workspace ws 
    Vector.length
    (_transform_bigarray w dir)

let transform_gen w dir ?ws = function
  | `V v  -> transform_vector      w dir ?ws v
  | `VF v -> transform_vector_flat w dir ?ws v

let transform_array w dir ?ws ?stride ?off ?len arr =
  transform_vector_flat w dir ?ws
    (Vector_flat.view_array ?stride ?off ?len arr)

let transform_forward w = transform_array w FORWARD
let transform_inverse w = transform_array w BACKWARD

type ordering =
  | STANDARD
  | NON_STANDARD

external _transform_2d :
  t -> ordering -> direction -> Matrix_flat.matrix -> ws -> unit
  = "ml_gsl_wavelet2d_transform_matrix"
external _transform_2d_bigarray :
  t -> ordering -> direction -> Matrix.matrix -> ws -> unit
  = "ml_gsl_wavelet2d_transform_matrix"
external _transform_2d_gen :
  t -> ordering -> direction -> [< Vectmat.mat] -> ws -> unit
  = "ml_gsl_wavelet2d_transform_matrix"

let transform_matrix_flat w order dir ?ws =
  with_workspace ws
    (fun m -> fst (Matrix_flat.dims m))
    (_transform_2d w order dir)

let transform_matrix w order dir ?ws =
  with_workspace ws
    (fun m -> fst (Matrix.dims m))
    (_transform_2d_bigarray w order dir)

let transform_matrix_gen w order dir ?ws =
  with_workspace ws
    (fun m -> fst (Vectmat.dims m))
    (_transform_2d_gen w order dir)
