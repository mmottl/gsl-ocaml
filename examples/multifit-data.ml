let _ = 
  Gsl_error.init () ;
  Gsl_rng.env_setup ()

let rng = Gsl_rng.make (Gsl_rng.default ())

let _ = 
  let x = ref 0.1 in
  while !x < 2. do
    let y0 = exp !x in
    let sigma = 0.1 *. y0 in
    let dy = Gsl_randist.gaussian rng ~sigma in
    Printf.printf "%.1f %g %g\n" !x (y0 +. dy) sigma ;
    x := !x +. 0.1
  done
