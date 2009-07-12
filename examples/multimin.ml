open Gsl_fun

let _ = 
  Gsl_error.init () 

let parab a b = 
  let f ~x =
    let xa = x.{0} -. a in
    let yb = x.{1} -. b in
    10. *. xa *. xa +. 20. *. yb *. yb +. 30.
  in
  let df ~x ~g =
    g.{0} <- 20. *. (x.{0} -. a) ;
    g.{1} <- 40. *. (x.{1} -. b)
  in
  let fdf ~x ~g = 
    let xa = x.{0} -. a in
    let yb = x.{1} -. b in
    g.{0} <- 20. *. xa ;
    g.{1} <- 40. *. yb ;
    10. *. xa *. xa +. 20. *. yb *. yb +. 30.
  in
  { multim_f   = f;
    multim_df  = df ;
    multim_fdf = fdf ; 
  } 


let epsabs = 1e-3
let maxiter = 50

let print_state n =
  let x = Gsl_vector.create n in
  let g = Gsl_vector.create n in
  fun mini iter ->
    let f = Gsl_multimin.Deriv.minimum ~x ~g mini in
    Printf.printf "%5d x=%.5f y=%.5f f=%10.5f g0=%.5g g1=%.5g\n"
      iter x.{0} x.{1} f g.{0} g.{1}

let mini kind gf start ~step ~tol=
  let minim = Gsl_multimin.Deriv.make kind 2 gf 
      ~x:(Gsl_vector.of_array start) ~step ~tol in
  let print_state = print_state 2 in
  let rec proc iter = 
    Gsl_multimin.Deriv.iterate minim ;
    let status = Gsl_multimin.Deriv.test_gradient minim epsabs in
    match status with
    | true -> 
	Printf.printf "Minimum found at:\n" ;
	print_state minim iter
    | false when iter >= maxiter -> 
	print_state minim iter ;
	Printf.printf "Too many iterations\n" ;
    | false ->
	print_state minim iter ;
	proc (succ iter)
  in
  Printf.printf "minimizer: %s\n" (Gsl_multimin.Deriv.name minim) ;
  proc 1

let print_state_simplex n =
  let x = Gsl_vector.create n in
  fun mini iter ->
    let f = Gsl_multimin.NoDeriv.minimum ~x mini in
    let ssval = Gsl_multimin.NoDeriv.size mini in
    Printf.printf "%5d x=%10.3f y=%10.3f f()=%-10.3f ssize=%.3f\n"
      iter x.{0} x.{1} f ssval
      
let mini_simplex kind gf ~start ~step_size =
  let minim = Gsl_multimin.NoDeriv.make kind 2 gf 
      ~x:(Gsl_vector.of_array start)
      ~step_size:(Gsl_vector.of_array step_size) in
  let print_state = print_state_simplex 2 in
  let rec proc iter = 
    Gsl_multimin.NoDeriv.iterate minim ;
    let status = Gsl_multimin.NoDeriv.test_size minim epsabs in
    match status with
    | true -> 
	Printf.printf "Minimum found at:\n" ;
	print_state minim iter
    | false when iter >= maxiter -> 
	print_state minim iter ;
	Printf.printf "Too many iterations\n" ;
    | false ->
	print_state minim iter ;
	proc (succ iter)
  in
  Printf.printf "minimizer: %s\n" (Gsl_multimin.NoDeriv.name minim) ;
  proc 1


open Gsl_multimin.Deriv
let _ = 
  List.iter
    (fun kind ->
      mini kind (parab 1. 2.) [| 5. ; 7. |] 0.01 1e-4 ;
      print_newline () ;
      flush stdout)
    [ CONJUGATE_FR ;
      CONJUGATE_PR ;
      VECTOR_BFGS ;
      STEEPEST_DESCENT ; ] ;

  mini_simplex Gsl_multimin.NoDeriv.NM_SIMPLEX
    (parab 1. 2.).multim_f
    ~start:[| 5. ; 7. |]
    ~step_size:[| 1. ; 1. |]
