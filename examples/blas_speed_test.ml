open Gsl

let m = 1000
let n = 100
let p = 50
let a = Array.init (m * n) float
let b = Array.init (n * p) float
let mA = Matrix.of_array a m n
let mB = Matrix.of_array b n p
let mC = Matrix.create ~init:0. m p
let mfA = Matrix_flat.of_array a m n
let mfB = Matrix_flat.of_array b n p
let mfC = Matrix_flat.create ~init:0. m p

open Blas

let test f mA mB mC =
  let t1 = Unix.gettimeofday () in
  for _i = 1 to 10_000 do
    f ~ta:NoTrans ~tb:NoTrans ~alpha:1.0 ~a:mA ~b:mB ~beta:0. ~c:mC
  done;
  let t2 = Unix.gettimeofday () in
  Printf.printf "%.3f\n" (t2 -. t1)

let () =
  test Blas.gemm mA mB mC;
  test Blas_flat.gemm mfA mfB mfC
