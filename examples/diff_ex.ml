open Gsl
open Fun

let f x = 
  (* raise Exit ;*)
  x ** 1.5

let test () = 
  let gslfun = f in
  Printf.printf "f(x) = x^(3/2)\n" ;
  flush stdout ;

  begin
    let { res=result; err=abserr } = Diff.central gslfun 2.0 in
    Printf.printf "x = 2.0\n" ;
    Printf.printf "f'(x) = %.10f +/- %.5f\n" result abserr ;
    Printf.printf "exact = %.10f\n\n" (1.5 *. sqrt 2.0)
  end ;

  flush stdout ; 

  begin
    let { res=result; err=abserr } = Diff.forward gslfun 0.0 in
    Printf.printf "x = 0.0\n" ;
    Printf.printf "f'(x) = %.10f +/- %.5f\n" result abserr ;
    Printf.printf "exact = %.10f\n\n" 0.0
  end

let _ = 
  Error.init ();
  test ()
