open Gsl

let data n =
  let d = Matrix.create n n in
  for i=0 to pred n do
    for j=0 to pred n do
      d.{i, j} <- 1. /. (float (i+j+1))
    done
  done ;
  d

let _ = 
  Printf.printf "Real Symmetric Matrices\n" ;
  let d = data 4 in
  let (eval, evec) as eigen = Eigen.symmv (`M d) in
  Eigen.symmv_sort eigen Eigen.ABS_ASC ;
  for i=0 to 3 do
    Printf.printf "eigenvalue = %g\n" eval.{i} ;
    Printf.printf "eigenvector = \n" ;
    for j=0 to 3 do
      Printf.printf "\t%g\n" evec.{j, i}
    done
  done ;
  print_newline ()




let _ =
  Printf.printf "Real Nonsymmetric Matrices\n" ;
  let data = [| -1. ;  1. ; -1. ; 1. ;
		-8. ;  4. ; -2. ; 1. ;
		27. ;  9. ;  3. ; 1. ;
		64. ; 16. ;  4. ; 1. |] in
  let (eval, evec) as eigen = Eigen.nonsymmv (`A (data, 4, 4)) in
  Eigen.nonsymmv_sort eigen Eigen.ABS_DESC ;
  for i=0 to 3 do
    let { Complex.re = re ; im = im} = eval.{i} in
    Printf.printf "eigenvalue = %g + %gi\n" re im ;
    Printf.printf "eigenvector = \n" ;
    for j=0 to 3 do
    let { Complex.re = re ; im = im} = evec.{j, i} in
      Printf.printf "\t%g + %gi\n" re im
    done
  done
