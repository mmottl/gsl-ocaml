open Gsl

let n       = 200
let ncoeffs = 8
let nbreak  = ncoeffs -2

open Printf

let _ =
  let rng = Rng.make (Rng.default ()) in

  (* allocate a cubic bspline workspace (k = 4) *)
  let bw = Bspline.make ~k:4 ~nbreak in
  
  let x = Vector.create n
  and y = Vector.create n
  and w = Vector.create n
  and mX = Matrix.create n ncoeffs 
  and vB = Vector.create ncoeffs in

  begin
    (* this is the data to be fitted *)
    printf "#m=0,S=0\n" ;
    let sigma = 0.1 in
    for i = 0 to n - 1 do
      let xi = 15. /. float (n-1) *. float i in
      let yi = cos xi *. exp (-0.1 *. xi) in
      let dy = Randist.gaussian rng ~sigma in
      x.{i} <- xi ;
      y.{i} <- yi +. dy ;
      w.{i} <- 1. /. (sigma *. sigma) ;
      printf "%f %f\n" xi yi
    done
  end ;

  (* use uniform breakpoints on [0, 15] *)
  Bspline.knots_uniform ~a:0. ~b:15. bw ;

  (* construct the fit matrix X *)
  for i = 0 to n -1 do 
    (* compute B_j(xi) for all j *)
    Bspline._eval x.{i} (`V vB) bw ;
    (* fill in row i of X *)
    for j = 0 to ncoeffs - 1 do
      mX.{i,j} <- vB.{j}
    done
  done ;

  (* do the fit *)
  let c, cov, _chisq = Multifit.linear ~weight:(`V w) (`M mX) (`V y) in

  (* output the smoothed curve *)
  begin
    printf "#m=1,S=0\n" ;
    let xi =  ref 0. in
    while !xi < 15. do
      Bspline._eval !xi (`V vB) bw ;
      let yi = Multifit.linear_est ~x:(`V vB) ~c:(`V c) ~cov:(`M cov) in
      printf "%f %f\n" !xi yi.Fun.res ;
      xi := !xi +. 0.1
    done
  end
