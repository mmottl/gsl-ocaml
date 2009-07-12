
let mA = [|
  0.18; 0.60; 0.57; 0.96; 
  0.41; 0.24; 0.99; 0.58; 
  0.14; 0.30; 0.97; 0.66; 
  0.51; 0.13; 0.19; 0.85; |]

let vB = [| 1.0; 2.0; 3.0; 4.0; |]

let test () =
  let x = Gsl_linalg.solve_LU ~protect:true
      (`A (mA, 4, 4)) (`A vB) in
  Printf.printf "x = \n" ;
  Array.iter (fun v -> Printf.printf " %g\n" v) x 

let _ = 
  Gsl_error.init () ;
  Gsl_error.handle_exn test ()
