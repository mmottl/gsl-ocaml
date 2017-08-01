(** Wavelet Transforms *)

type t
type ws

type kind =
  | DAUBECHIES
  | DAUBECHIES_CENTERED
  | HAAR
  | HAAR_CENTERED
  | BSPLINE
  | BSPLINE_CENTERED

type direction = FORWARD | BACKWARD

val make : kind -> int -> t
external name : t -> string = "ml_gsl_wavelet_name"
val workspace_make : int -> ws
external workspace_size : ws -> int = "ml_gsl_wavelet_workspace_size"

(** {3 1D transforms} *)

val transform_array :
  t -> direction -> ?ws:ws -> ?stride:int -> ?off:int -> ?len:int -> float array -> unit
val transform_forward :
  t -> ?ws:ws -> ?stride:int -> ?off:int -> ?len:int -> float array -> unit
val transform_inverse :
  t -> ?ws:ws -> ?stride:int -> ?off:int -> ?len:int -> float array -> unit

val transform_vector_flat :
  t -> direction -> ?ws:ws -> Vector_flat.vector -> unit
val transform_vector :
  t -> direction -> ?ws:ws -> Vector.vector -> unit
val transform_gen :
  t -> direction -> ?ws:ws -> [< Vectmat.vec] -> unit

(** {3 2D transforms} *)

type ordering =
  | STANDARD
  | NON_STANDARD

val transform_matrix_flat :
  t -> ordering -> direction -> ?ws:ws -> Matrix_flat.matrix -> unit
val transform_matrix :
  t -> ordering -> direction -> ?ws:ws -> Matrix.matrix -> unit
val transform_matrix_gen :
  t -> ordering -> direction -> ?ws:ws -> [< Vectmat.mat] -> unit
