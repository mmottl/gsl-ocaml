
let energ x = 
  (exp (~-. ((x -. 1.) ** 2.))) *. sin (8. *. x)

let step rng x step_size =
  let u = Gsl_rng.uniform rng in
  x +. 2. *. (u -. 0.5) *. step_size

let print x = 
  Printf.sprintf "%12g" x


let _ = 
  Gsl_error.init () ;
  Gsl_rng.env_setup () ;
  let rng = Gsl_rng.make (Gsl_rng.default ()) in
  
  let params = {
    Gsl_siman.iters_fixed_T = 10 ;
    Gsl_siman.step_size = 10. ;
    Gsl_siman.k = 1. ;
    Gsl_siman.t_initial = 2e-3 ;
    Gsl_siman.mu_t = 1.005 ;
    Gsl_siman.t_min = 2e-6 ;
  } in

  let res =
    Gsl_siman.solve rng 15.5
      ~energ_func:energ ~step_func:step
      (* ~print_func:print  *)
      params 
  in
  Printf.printf "result = %12g\n" res
