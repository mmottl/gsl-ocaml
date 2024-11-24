open Gsl

let f x =
  Gc.major ();
  cos x +. 1.

let max_iter = 25

let find_min s m_expected =
  Printf.printf "using %s method\n" (Min.name s);
  Printf.printf "%5s [%9s, %9s] %9s %10s %9s\n" "iter" "lower" "upper" "min"
    "err" "err(est)";
  flush stdout;
  let rec proc i = function
    | true -> ()
    | false when i > max_iter ->
        Printf.printf "Did not converge after %d iterations.\n" max_iter
    | _ ->
        let a, b = Min.interval s in
        let m = Min.minimum s in
        let status =
          Min.test_interval ~x_lo:a ~x_up:b ~epsabs:1e-3 ~epsrel:0.
        in
        if i = 3 then Gc.full_major ();
        if status then Printf.printf "Converged:\n";
        Printf.printf "%5d [%.7f, %.7f] %.7f %+.7f %.7f\n" i a b m
          (m -. m_expected) (b -. a);
        flush stdout;
        Min.iterate s;
        proc (succ i) status
  in
  proc 0 false

let _ =
  let gslfun = f in
  List.iter
    (fun k ->
      let s = Min.make k gslfun ~min:2. ~lo:0. ~up:6. in
      find_min s Math.pi;
      print_newline ())
    [ Min.GOLDENSECTION; Min.BRENT ]
