open Gsl

let energ x = exp ~-.((x -. 1.) ** 2.) *. sin (8. *. x)

let step rng x step_size =
  let u = Rng.uniform rng in
  x +. (2. *. (u -. 0.5) *. step_size)

let print x = Printf.sprintf "%12g" x

let _ =
  Error.init ();
  Rng.env_setup ();
  let rng = Rng.make (Rng.default ()) in

  let params =
    {
      Siman.iters_fixed_T = 10;
      Siman.step_size = 10.;
      Siman.k = 1.;
      Siman.t_initial = 2e-3;
      Siman.mu_t = 1.005;
      Siman.t_min = 2e-6;
    }
  in

  let res =
    Siman.solve rng 15.5 ~energ_func:energ ~step_func:step
      (* ~print_func:print *)
      params
  in
  Printf.printf "result = %12g\n" res
