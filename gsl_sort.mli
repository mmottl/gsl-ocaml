(** Sorting *)

val vector                : Gsl_vector.vector -> unit
val vector_index          : Gsl_vector.vector -> Gsl_permut.permut
val vector_smallest       : int -> Gsl_vector.vector -> float array
val vector_largest        : int -> Gsl_vector.vector -> float array
val vector_smallest_index : int -> Gsl_vector.vector -> Gsl_permut.permut
val vector_largest_index  : int -> Gsl_vector.vector -> Gsl_permut.permut

val vector_flat                : Gsl_vector_flat.vector -> unit
val vector_flat_index          : Gsl_vector_flat.vector -> Gsl_permut.permut
val vector_flat_smallest       : int -> Gsl_vector_flat.vector -> float array
val vector_flat_largest        : int -> Gsl_vector_flat.vector -> float array
val vector_flat_smallest_index : int -> Gsl_vector_flat.vector -> Gsl_permut.permut
val vector_flat_largest_index  : int -> Gsl_vector_flat.vector -> Gsl_permut.permut

