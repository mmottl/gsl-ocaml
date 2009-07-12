let x = [| 1970.; 1980.; 1990.; 2000. |];;
let y = [| 12.; 11.; 14.; 13. |];;
let w = [| 0.1; 0.2; 0.3; 0.4 |];;

open Gsl_fun
open Gsl_fit

let _ =
  let coefs = Gsl_fit.linear ~weight:w x y in
  Printf.printf "#best fit: Y = %g + %G X\n" coefs.c0 coefs.c1 ;
  Printf.printf "# covariance matrix:\n" ;
  Printf.printf "# [ %g, %g\n#   %g, %g]\n" 
    coefs.cov00 coefs.cov01 
    coefs.cov01 coefs.cov11 ;
  Printf.printf "# chisq = %g\n" coefs.sumsq ;
  for i=0 to 3 do
    Printf.printf "data: %g %g %g\n" x.(i) y.(i) (1. /. sqrt(w.(i)))
  done ;
  Printf.printf "\n" ;
  
  for i=(-30) to 129 do
    let xf = x.(0) +. (float i /. 100.) *. (x.(3) -. x.(0)) in
    let { res = yf; err = yf_err } = Gsl_fit.linear_est xf coefs in
    Printf.printf "fit: %g %g\n" xf yf ;
    Printf.printf "hi : %g %g\n" xf (yf +. yf_err) ;
    Printf.printf "lo : %g %g\n" xf (yf -. yf_err) ;
  done
