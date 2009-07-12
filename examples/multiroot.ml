open Gsl_fun

let _ = 
  Gsl_error.init ()

let f a b ~x ~f:y =
  let x0 = x.{0} in
  let x1 = x.{1} in
  y.{0} <- a *. (1. -. x0) ;
  y.{1} <- b *. (x1 -. x0 *. x0)

let df a b ~x ~j =
  let x0 = x.{0} in
  j.{0,0} <- ~-. a ;
  j.{0,1} <- 0. ;
  j.{1,0} <- -2. *. b *. x0 ;
  j.{1,1} <- b

let fdf a b ~x ~f:y ~j =
   f a b ~x ~f:y ;
  df a b ~x ~j

let print_state n = 
  let x = Gsl_vector.create n in
  let f = Gsl_vector.create n in
  fun iter solv ->
    Gsl_multiroot.NoDeriv.get_state solv ~x ~f () ;
    Printf.printf 
      "iter = %3u x = %+ .3f %+ .3f f(x) = %+ .3e %+ .3e\n"
      iter x.{0} x.{1} f.{0} f.{1} ;
    flush stdout

let epsabs = 1e-7
let maxiter = 1000

let solve kind n gf x_init =
  let solv = Gsl_multiroot.NoDeriv.make kind n gf 
      (Gsl_vector.of_array x_init) in
  Printf.printf "solver: %s\n" (Gsl_multiroot.NoDeriv.name solv) ;
  let print_state = print_state n in
  print_state 0 solv ;
  let rec proc iter = 
    Gsl_multiroot.NoDeriv.iterate solv ;
    print_state iter solv ;
    let status = Gsl_multiroot.NoDeriv.test_residual solv epsabs in
    match status with
    | true ->
	Printf.printf "status = converged\n"
    | false when iter >= maxiter ->
	Printf.printf "status = too many iterations\n"
    | false ->
	proc (succ iter)
  in
  proc 1

open Gsl_multiroot.NoDeriv

let _ = 
  List.iter 
    (fun kind ->
      solve kind 2 (f 1. 10.) [| -10.; -5. |] ;
      print_newline ())
    [ HYBRIDS ;
      HYBRID ;
      DNEWTON ;
      BROYDEN ; ]

let print_state_deriv n = 
  let x = Gsl_vector.create n in
  let f = Gsl_vector.create n in
  fun iter solv ->
    Gsl_multiroot.Deriv.get_state solv ~x ~f () ;
    Printf.printf 
      "iter = %3u x = %+ .3f %+ .3f f(x) = %+ .3e %+ .3e\n"
      iter x.{0} x.{1} f.{0} f.{1} ;
    flush stdout

let solve_deriv kind n gf x_init =
  let solv = Gsl_multiroot.Deriv.make kind n gf 
      (Gsl_vector.of_array x_init) in
  Printf.printf "solver: %s\n" (Gsl_multiroot.Deriv.name solv) ;
  let print_state = print_state_deriv n in
  print_state 0 solv ;
  let rec proc iter = 
    Gsl_multiroot.Deriv.iterate solv ;
    print_state iter solv ;
    let status = Gsl_multiroot.Deriv.test_residual solv epsabs in
    match status with
    | true ->
	Printf.printf "status = converged\n"
    | false when iter >= maxiter ->
	Printf.printf "status = too many iterations\n"
    | false ->
	proc (succ iter)
  in
  proc 1

open Gsl_multiroot.Deriv

let _ = 
  let gf = {
    multi_f = f 1. 10. ;
    multi_df = df 1. 10. ;
    multi_fdf = fdf 1. 10. ; } in
  List.iter 
    (fun kind ->
      solve_deriv kind 2 gf [| -10.; -5. |] ;
      print_newline ())
    [ HYBRIDSJ ;
      HYBRIDJ ;
      NEWTON ;
      GNEWTON ; ]


