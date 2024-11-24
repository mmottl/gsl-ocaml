open Gsl

let a = [| 0.11; 0.12; 0.13; 0.21; 0.22; 0.23 |]
let b = [| 1011.; 1012.; 1021.; 1022.; 1031.; 1032. |]
let mA = Matrix.of_array a 2 3
let mB = Matrix.of_array b 3 2
let mC = Matrix.create ~init:0. 2 2
let mfA = Matrix_flat.of_array a 2 3
let mfB = Matrix_flat.of_array b 3 2
let mfC = Matrix_flat.create ~init:0. 2 2

open Blas

let _ =
  Blas.gemm ~ta:NoTrans ~tb:NoTrans ~alpha:1.0 ~a:mA ~b:mB ~beta:0. ~c:mC;
  Printf.printf "[ %g, %g\n" mC.{0, 0} mC.{0, 1};
  Printf.printf "  %g, %g ]\n" mC.{1, 0} mC.{1, 1};

  print_newline ();

  Blas_flat.gemm ~ta:NoTrans ~tb:NoTrans ~alpha:1.0 ~a:mfA ~b:mfB ~beta:0.
    ~c:mfC;
  let mfC' = Matrix_flat.to_arrays mfC in
  Printf.printf "[ %g, %g\n" mfC'.(0).(0) mfC'.(0).(1);
  Printf.printf "  %g, %g ]\n" mfC'.(1).(0) mfC'.(1).(1)
