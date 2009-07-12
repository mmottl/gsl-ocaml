
let _ = 
  Gsl_error.init ()

let quad a b c x =
  (* Gc.major () ; *)
  (a *. x +. b) *. x +. c
let quad_deriv a b x =
  2. *. a *. x +. b
let quad_fdf a b c x =
  let y = (a *. x +. b) *. x +. c in
  let dy = 2. *. a *. x +. b in
  (y, dy)

let (a, b, c) = (1., 0., -5.0)
let r_expected = sqrt 5.0 

open Gsl_root.Bracket
let find_f ?(max_iter=100) s =
  Printf.printf "\nusing %s method\n" (name s) ;
  Printf.printf "%5s [%9s, %9s] %9s %10s %9s\n"
    "iter" "lower" "upper" "root" "err" "err(est)" ;
  let rec proc i = function
    | true -> ()
    | _ when i >= max_iter -> ()
    | _ ->
	iterate s ;
	let r = root s in
	let (x_lo, x_hi) = interval s in
	let status = Gsl_root.test_interval x_lo x_hi 0. 0.001 in
	if status
	then Printf.printf "Converged:\n" ;
	Printf.printf "%5d [%.7f, %.7f] %.7f %+.7f %.7f\n"
	  i x_lo x_hi r (r -. r_expected) (x_hi -. x_lo) ;
	proc (succ i) status
  in
  proc 1 false

open Gsl_root.Polish
let find_fdf ?(max_iter=100) s x_init =
  Printf.printf "\nusing %s method\n" (name s) ;
  Printf.printf "%-5s %10s %10s %10s\n"
    "iter" "root" "err" "err(est)" ;
  let rec proc i x0 = function
    | true -> ()
    | _ when i >= max_iter -> ()
    | _ ->
	iterate s ;
	let x = root s in
	let status = Gsl_root.test_delta x x0 0. 1e-3 in
	if status
	then Printf.printf "Converged:\n" ;
	Printf.printf "%5d %10.7f %+10.7f %10.7f\n"
	  i x (x -. r_expected) (x -. x0) ;
	proc (succ i) x status
  in
  proc 1 x_init false


let _ =
  let gslfun = quad a b c in
  List.iter
    (fun t ->
      let s = Gsl_root.Bracket.make t gslfun 0. 5. in
      find_f s)
    [ Gsl_root.Bracket.BISECTION ;
      Gsl_root.Bracket.FALSEPOS ;
      Gsl_root.Bracket.BRENT ]

let _ =
  print_newline () ;
  flush stdout 

let _ =
  let gslfun_fdf = {
    Gsl_fun.f = quad a b c ;
    Gsl_fun.df = quad_deriv a b ;
    Gsl_fun.fdf = quad_fdf a b c ; } in
  List.iter
    (fun t ->
      let s = Gsl_root.Polish.make t gslfun_fdf 5. in
      find_fdf s 5.)
    [ Gsl_root.Polish.NEWTON ;
      Gsl_root.Polish.SECANT ;
      Gsl_root.Polish.STEFFENSON ]
