open Gsl_fun

let expb y sigma =
  let expb_f ~x ~f =
    let n = Gsl_vector.length f in
    assert(Array.length y = n);
    assert(Array.length sigma = n);
    let a = x.{0} in
    let lambda = x.{1} in
    let b = x.{2} in
    for i=0 to pred n do
      (* model Yi = A * exp(-lambda * i) + b *)
      let yi = a *. exp (-. lambda *. (float i)) +. b in
      f.{i} <- (yi -. y.(i)) /. sigma.(i)
    done
  in
  let expb_df ~x ~j =
    let (n,p) = Gsl_matrix.dims j in
    assert(Gsl_vector.length x = p);
    assert(Array.length sigma = n);
    let a = x.{0} in
    let lambda = x.{1} in
    for i=0 to pred n do
    (* Jacobian matrix J(i,j) = dfi / dxj, *)
    (* where fi = (Yi - yi)/sigma[i],      *)
    (*       Yi = A * exp(-lambda * i) + b  *)
    (* and the xj are the parameters (A,lambda,b) *)
      let e = exp (-. lambda *. float i) in
      let s = sigma.(i) in
      j.{i, 0} <- e /. s ;
      j.{i, 1} <- float (-i) *. a *. e /. s ;
      j.{i, 2} <- 1. /. s
    done
  in
  let expb_fdf ~x ~f ~j =
    expb_f x f ;
    expb_df x j
  in
  { multi_f = expb_f ;
    multi_df = expb_df ;
    multi_fdf = expb_fdf ;
  } 

let n = 40
let p = 3
let maxiter = 500
let epsabs = 1e-4
let epsrel = 1e-4

let data () = 
  Gsl_rng.env_setup () ;
  let r = Gsl_rng.make (Gsl_rng.default ()) in
  let sigma = Array.make n 0.1 in
  let y = Array.init n
      (fun t ->
	let yt = 1. +. 5. *. exp (-0.1 *. float t) +.
	    (Gsl_randist.gaussian r ~sigma:sigma.(t)) in
	Printf.printf "data: %d %g %g\n" t yt sigma.(t) ;
	yt) in
  (y, sigma)

let print_state n p =
  let x = Gsl_vector.create p in
  let f = Gsl_vector.create n in
  fun iter s ->
    Gsl_multifit_nlin.get_state s ~x ~f () ;
    Printf.printf "iter: %3u x = %15.8f % 15.8f % 15.8f |f(x)| = %g\n"
      iter x.{0} x.{1} x.{2} (Gsl_blas.nrm2 f)

let solv (y, sigma) xinit = 
  let n = Array.length y in
  assert(Array.length sigma = n) ;
  let print_state = print_state n p in
  let s = 
    Gsl_multifit_nlin.make 
      Gsl_multifit_nlin.LMSDER ~n ~p (expb y sigma) 
      (Gsl_vector.of_array xinit)
  in
  Printf.printf "\nsolver: %s\n" 
    (Gsl_multifit_nlin.name s) ;
  print_state 0 s ;
  let rec proc iter = 
    Gsl_multifit_nlin.iterate s ;
    print_state iter s ;
    let status = Gsl_multifit_nlin.test_delta s ~epsabs ~epsrel in
    match status with
    | true ->
	Printf.printf "\nstatus = converged\n"
    | false when iter >= maxiter ->
	Printf.printf "\nstatus = too many iterations\n"
    | false ->
	proc (succ iter)
  in
  proc 1 ;
  let pos = Gsl_vector.create 3 in
  Gsl_multifit_nlin.position s pos ;
  let covar = Gsl_matrix.create p p in
  Gsl_multifit_nlin.covar s 0. covar ;
  Printf.printf
    "A      = %.5f +/- %.5f\n" pos.{0} (sqrt covar.{0, 0}) ;
  Printf.printf
    "lambda = %.5f +/- %.5f\n" pos.{1} (sqrt covar.{1, 1}) ;
  Printf.printf
    "b      = %.5f +/- %.5f\n" pos.{2} (sqrt covar.{2, 2})

let _ = 
  solv (data ()) [| 1.0;  0.;  0.; |]
