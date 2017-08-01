(** Sorting *)

val vector                : Vector.vector -> unit
val vector_index          : Vector.vector -> Permut.permut
val vector_smallest       : int -> Vector.vector -> float array
val vector_largest        : int -> Vector.vector -> float array
val vector_smallest_index : int -> Vector.vector -> Permut.permut
val vector_largest_index  : int -> Vector.vector -> Permut.permut

val vector_flat                : Vector_flat.vector -> unit
val vector_flat_index          : Vector_flat.vector -> Permut.permut
val vector_flat_smallest       : int -> Vector_flat.vector -> float array
val vector_flat_largest        : int -> Vector_flat.vector -> float array
val vector_flat_smallest_index : int -> Vector_flat.vector -> Permut.permut
val vector_flat_largest_index  : int -> Vector_flat.vector -> Permut.permut

