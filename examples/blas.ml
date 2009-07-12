
let a = [| 0.11; 0.12; 0.13; 0.21; 0.22; 0.23; |]
let b = [| 1011.; 1012.; 1021.; 1022.; 1031.; 1032.; |]

let mA = Gsl_matrix.of_array a 2 3
let mB = Gsl_matrix.of_array b 3 2
let mC = Gsl_matrix.create ~init:0. 2 2

let mfA = Gsl_matrix_flat.of_array a 2 3
let mfB = Gsl_matrix_flat.of_array b 3 2
let mfC = Gsl_matrix_flat.create ~init:0. 2 2

open Gsl_blas

let _ = 
  Gsl_blas.gemm NoTrans NoTrans 1.0 mA mB 0. mC ;
  Printf.printf "[ %g, %g\n"   mC.{0,0} mC.{0, 1} ;
  Printf.printf "  %g, %g ]\n" mC.{1,0} mC.{1, 1} ;

  print_newline () ;

  Gsl_blas_flat.gemm NoTrans NoTrans 1.0 mfA mfB 0. mfC ;
  let mfC' = Gsl_matrix_flat.to_arrays mfC in
  Printf.printf "[ %g, %g\n"   mfC'.(0).(0) mfC'.(0).(1) ;
  Printf.printf "  %g, %g ]\n" mfC'.(1).(0) mfC'.(1).(1)
