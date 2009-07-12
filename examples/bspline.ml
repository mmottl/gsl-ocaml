let n       = 200
let ncoeffs = 8
let nbreak  = ncoeffs -2

open Printf

let _ =
  let rng = Gsl_rng.make (Gsl_rng.default ()) in

  (* allocate a cubic bspline workspace (k = 4) *)
  let bw = Gsl_bspline.make ~k:4 ~nbreak in
  
  let x = Gsl_vector.create n
  and y = Gsl_vector.create n
  and w = Gsl_vector.create n
  and mX = Gsl_matrix.create n ncoeffs 
  and vB = Gsl_vector.create ncoeffs in

  begin
    (* this is the data to be fitted *)
    printf "#m=0,S=0\n" ;
    let sigma = 0.1 in
    for i = 0 to n - 1 do
      let xi = 15. /. float (n-1) *. float i in
      let yi = cos xi *. exp (-0.1 *. xi) in
      let dy = Gsl_randist.gaussian rng ~sigma in
      x.{i} <- xi ;
      y.{i} <- yi +. dy ;
      w.{i} <- 1. /. (sigma *. sigma) ;
      printf "%f %f\n" xi yi
    done
  end ;

  (* use uniform breakpoints on [0, 15] *)
  Gsl_bspline.knots_uniform 0. 15. bw ;

  (* construct the fit matrix X *)
  for i = 0 to n -1 do 
    (* compute B_j(xi) for all j *)
    Gsl_bspline._eval x.{i} (`V vB) bw ;
    (* fill in row i of X *)
    for j = 0 to ncoeffs - 1 do
      mX.{i,j} <- vB.{j}
    done
  done ;

  (* do the fit *)
  let c, cov, chisq = Gsl_multifit.linear ~weight:(`V w) (`M mX) (`V y) in

  (* output the smoothed curve *)
  begin
    printf "#m=1,S=0\n" ;
    let xi =  ref 0. in
    while !xi < 15. do
      Gsl_bspline._eval !xi (`V vB) bw ;
      let yi = Gsl_multifit.linear_est ~x:(`V vB) ~c:(`V c) ~cov:(`M cov) in
      printf "%f %f\n" !xi yi.Gsl_fun.res ;
      xi := !xi +. 0.1
    done
  end
