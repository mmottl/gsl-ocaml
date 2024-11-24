open Gsl
open Math

let _ = Error.init ()

let exact =
  let e = (Sf.gamma 0.25 ** 4.) /. (4. *. (pi ** 3.)) in
  Printf.printf "computing exact: %.9f\n" e;
  e

let g =
  let a = 1. /. (pi *. pi *. pi) in
  fun x -> a /. (1. -. (cos x.(0) *. cos x.(1) *. cos x.(2)))

let display_results title { Fun.res = result; Fun.err = error } =
  Printf.printf "%s ==================\n" title;
  Printf.printf "result = % .6f\n" result;
  Printf.printf "sigma  = % .6f\n" error;
  Printf.printf "exact  = % .6f\n" exact;
  Printf.printf "error  = % .6f = %.1g sigma\n" (result -. exact)
    (abs_float (result -. exact) /. error)

let compute rng =
  let lo = [| 0.; 0.; 0. |] in
  let up = [| pi; pi; pi |] in

  let gslfun = g in
  let calls = 500000 in

  (let res = Monte.integrate Monte.PLAIN gslfun ~lo ~up calls rng in
   display_results "PLAIN" res;
   print_newline ());

  (let res = Monte.integrate Monte.MISER gslfun ~lo ~up calls rng in
   display_results "MISER" res;
   print_newline ());

  let state = Monte.make_vegas_state 3 in
  let params = Monte.get_vegas_params state in
  let oc = open_out "truc" in
  Monte.set_vegas_params state
    { params with Monte.verbose = 0; Monte.ostream = Some oc };
  let res = Monte.integrate_vegas gslfun ~lo ~up 10000 rng state in
  display_results "VEGAS warm-up" res;
  Printf.printf "converging...\n";
  flush stdout;
  let rec proc () =
    let ({ Fun.res = result; Fun.err } as res) =
      Monte.integrate_vegas gslfun ~lo ~up (calls / 5) rng state
    in
    let { Monte.chisq } = Monte.get_vegas_info state in
    Printf.printf "result = % .6f sigma = % .6f chisq/dof = %.1f\n" result err
      chisq;
    flush stdout;
    if abs_float (chisq -. 1.) > 0.5 then proc () else res
  in
  let res_final = proc () in
  display_results "VEGAS final" res_final;
  close_out oc

let _ =
  Rng.env_setup ();
  let rng = Rng.make (Rng.default ()) in
  Printf.printf "using %s RNG\n" (Rng.name rng);
  print_newline ();
  compute rng
