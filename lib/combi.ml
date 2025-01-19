open Bigarray

let () = Error.init ()

type t = { n : int; k : int; data : (int, int_elt, c_layout) Bigarray.Array1.t }

external _init_first : t -> unit = "ml_gsl_combination_init_first"
external _init_last : t -> unit = "ml_gsl_combination_init_last"

let make n k =
  let c = { n; k; data = Array1.create int c_layout k } in
  _init_first c;
  c

let to_array { data; _ } =
  let len = Array1.dim data in
  Array.init len (Array1.get data)

external prev : t -> unit = "ml_gsl_combination_prev"
external next : t -> unit = "ml_gsl_combination_next"
external _valid : t -> bool = "ml_gsl_combination_valid"

let valid c = try _valid c with Error.Gsl_exn (Error.FAILURE, _) -> false
