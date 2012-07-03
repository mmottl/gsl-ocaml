open Gsl

let _ = 
  Error.init () ;
  Rng.env_setup ()

let rng = Rng.make (Rng.default ())

let _ = 
  let x = ref 0.1 in
  while !x < 2. do
    let y0 = exp !x in
    let sigma = 0.1 *. y0 in
    let dy = Randist.gaussian rng ~sigma in
    Printf.printf "%.1f %g %g\n" !x (y0 +. dy) sigma ;
    x := !x +. 0.1
  done
