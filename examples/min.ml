
let f x =
  Gc.major ();
  cos x +. 1.

let max_iter = 25

let find_min s m_expected = 
  Printf.printf "using %s method\n" 
    (Gsl_min.name s) ;
  Printf.printf "%5s [%9s, %9s] %9s %10s %9s\n"
    "iter" "lower" "upper" "min" "err" "err(est)" ;
  flush stdout;
  let rec proc i = function
    | true -> ()
    | false when i > max_iter -> 
	Printf.printf "Did not converge after %d iterations.\n" max_iter
    | _ ->
	let (a, b) = Gsl_min.interval s in
	let m = Gsl_min.minimum s in
	let status = Gsl_min.test_interval a b 1e-3 0. in
	if i=3
	then Gc.full_major () ;
	if status
	then Printf.printf "Converged:\n" ;
	Printf.printf "%5d [%.7f, %.7f] %.7f %+.7f %.7f\n"
	  i a b m (m -. m_expected) (b -. a) ;
	flush stdout;
	Gsl_min.iterate s ;
	proc (succ i) status
  in
  proc 0 false

let _ = 
  let gslfun = f in
  List.iter
    (fun k ->
      let s = Gsl_min.make k gslfun ~min:2. ~lo:0. ~up:6. in
      find_min s Gsl_math.pi ;
      print_newline ())
    [ Gsl_min.GOLDENSECTION ;
      Gsl_min.BRENT ]
