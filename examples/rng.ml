
let _ = 
  Gsl_error.init () ;
  Gsl_rng.env_setup ()

let rng = Gsl_rng.make (Gsl_rng.default ())

let _ = 
  Printf.printf "# generator type: %s\n" 
    (Gsl_rng.name rng) ;
  Printf.printf "# seed = %nu\n" 
    (Gsl_rng.default_seed ()) ;
  Printf.printf "# min value   = %nu\n"  
    (Gsl_rng.min rng) ;
  Printf.printf "# max value   = %nu\n"  
    (Gsl_rng.max rng) ;
  Printf.printf "# first value = %nu\n"  
    (Gsl_rng.get rng)

let sigma = 3.

let _ = 
  Printf.printf "# gaussian with sigma=%g\n" sigma ;
  for i=1 to 10 do
    let x = Gsl_randist.gaussian rng ~sigma in
    Printf.printf "%+.7f\n" x
  done


(* Local Variables: *)
(* compile-command: "ocamlopt -o rng -I .. gsl.cmxa rng.ml" *)
(* End: *)
