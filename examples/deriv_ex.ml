open Gsl
open Fun

let f x =
  (* raise Exit ;*)
  x ** 1.5

let test () =
  let gslfun = f in
  Printf.printf "f(x) = x^(3/2)\n";
  flush stdout;

  (let { res = result; err = abserr } =
     Deriv.central ~f:gslfun ~x:2.0 ~h:1e-3
   in
   Printf.printf "x = 2.0\n";
   Printf.printf "f'(x) = %.10f +/- %.5f\n" result abserr;
   Printf.printf "exact = %.10f\n\n" (1.5 *. sqrt 2.0));

  flush stdout;

  let { res = result; err = abserr } = Deriv.forward ~f:gslfun ~x:0.0 ~h:1e-3 in
  Printf.printf "x = 0.0\n";
  Printf.printf "f'(x) = %.10f +/- %.5f\n" result abserr;
  Printf.printf "exact = %.10f\n\n" 0.0

let _ =
  Error.init ();
  test ()
