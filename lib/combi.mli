open Bigarray

type t = private {
  n : int;
  k : int;
  data : (int, int_elt, c_layout) Bigarray.Array1.t;
}

external _init_first : t -> unit = "ml_gsl_combination_init_first"
external _init_last : t -> unit = "ml_gsl_combination_init_last"
val make : int -> int -> t
val to_array : t -> int array
external prev : t -> unit = "ml_gsl_combination_prev"
external next : t -> unit = "ml_gsl_combination_next"
val valid : t -> bool
