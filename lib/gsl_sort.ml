let () = Error.init ()

external vector : Vector.vector -> unit = "ml_gsl_sort_vector"

external _vector_index : Permut.permut -> Vector.vector -> unit
  = "ml_gsl_sort_vector_index"

let vector_index v =
  let p = Permut.create (Vector.length v) in
  _vector_index p v;
  p

external _vector_smallest : float array -> Vector.vector -> unit
  = "ml_gsl_sort_vector_smallest"

external _vector_largest : float array -> Vector.vector -> unit
  = "ml_gsl_sort_vector_largest"

let vector_smallest k v =
  let dest = Array.make k 0. in
  _vector_smallest dest v;
  dest

let vector_largest k v =
  let dest = Array.make k 0. in
  _vector_largest dest v;
  dest

external _vector_smallest_index : Permut.permut -> Vector.vector -> unit
  = "ml_gsl_sort_vector_smallest_index"

external _vector_largest_index : Permut.permut -> Vector.vector -> unit
  = "ml_gsl_sort_vector_largest_index"

let vector_smallest_index k v =
  let p = Permut.create k in
  _vector_smallest_index p v;
  p

let vector_largest_index k v =
  let p = Permut.create k in
  _vector_largest_index p v;
  p

external vector_flat : Vector_flat.vector -> unit = "ml_gsl_sort_vector"

external _vector_flat_index : Permut.permut -> Vector_flat.vector -> unit
  = "ml_gsl_sort_vector_index"

let vector_flat_index v =
  let p = Permut.create (Vector_flat.length v) in
  _vector_flat_index p v;
  p

external _vector_flat_smallest : float array -> Vector_flat.vector -> unit
  = "ml_gsl_sort_vector_smallest"

external _vector_flat_largest : float array -> Vector_flat.vector -> unit
  = "ml_gsl_sort_vector_largest"

let vector_flat_smallest k v =
  let dest = Array.make k 0. in
  _vector_flat_smallest dest v;
  dest

let vector_flat_largest k v =
  let dest = Array.make k 0. in
  _vector_flat_largest dest v;
  dest

external _vector_flat_smallest_index :
  Permut.permut -> Vector_flat.vector -> unit
  = "ml_gsl_sort_vector_smallest_index"

external _vector_flat_largest_index :
  Permut.permut -> Vector_flat.vector -> unit
  = "ml_gsl_sort_vector_largest_index"

let vector_flat_smallest_index k v =
  let p = Permut.create k in
  _vector_flat_smallest_index p v;
  p

let vector_flat_largest_index k v =
  let p = Permut.create k in
  _vector_flat_largest_index p v;
  p
