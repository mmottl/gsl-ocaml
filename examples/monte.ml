open Gsl_math

let _ =
  Gsl_error.init ()

let exact =
  let e = Gsl_sf.gamma(0.25) ** 4. /. (4. *. pi ** 3.) in
  Printf.printf "computing exact: %.9f\n" e ;
  e

let g =
  let a = 1. /. (pi *. pi *. pi) in
  fun x ->
    a /. (1. -. cos x.(0) *. cos x.(1) *. cos x.(2))

let display_results title { Gsl_fun.res=result; Gsl_fun.err=error } =
  Printf.printf "%s ==================\n" title ;
  Printf.printf "result = % .6f\n" result ;
  Printf.printf "sigma  = % .6f\n" error ;
  Printf.printf "exact  = % .6f\n" exact ;
  Printf.printf "error  = % .6f = %.1g sigma\n" 
    (result -. exact)
    ((abs_float (result -. exact)) /. error)

let compute rng = 
  let lo = [| 0.; 0.; 0.; |] in
  let up = [| pi; pi; pi |] in

  let gslfun = g in
  let calls = 500000 in

  begin
    let res = Gsl_monte.integrate Gsl_monte.PLAIN gslfun ~lo ~up calls rng in
    display_results "PLAIN" res ;
    print_newline ()
  end ;

  begin
    let res = Gsl_monte.integrate Gsl_monte.MISER gslfun ~lo ~up calls rng in
    display_results "MISER" res ;
    print_newline ()
  end ;

  begin
    let state = Gsl_monte.make_vegas_state 3 in
    let params = Gsl_monte.get_vegas_params state in
    let oc = open_out "truc" in
    Gsl_monte.set_vegas_params state { params with 
				       Gsl_monte.verbose = 0 ;
				       Gsl_monte.ostream = Some oc } ;
    let res = Gsl_monte.integrate_vegas gslfun ~lo ~up 10000 rng state in
    display_results "VEGAS warm-up" res ;
    Printf.printf "converging...\n" ; flush stdout ;
    let rec proc () =
      let { Gsl_fun.res=result; Gsl_fun.err=err } as res = 
	Gsl_monte.integrate_vegas gslfun ~lo ~up (calls / 5) rng state in
      let { Gsl_monte.chisq = chisq } = Gsl_monte.get_vegas_info state in
      Printf.printf 
	"result = % .6f sigma = % .6f chisq/dof = %.1f\n"
	result err chisq ;
      flush stdout ;
      if (abs_float (chisq -. 1.)) > 0.5
      then proc ()
      else res in
    let res_final = proc () in
    display_results "VEGAS final" res_final ;
    close_out oc
  end

let _ =
  Gsl_rng.env_setup ();
  let rng = Gsl_rng.make (Gsl_rng.default ()) in
  Printf.printf "using %s RNG\n" (Gsl_rng.name rng) ;
  print_newline () ;
  compute rng
