let f alpha x =
  Gc.major ();
  (log (alpha *. x)) /. (sqrt x)

let compute f expected =
  let ws = Gsl_integration.make_ws 1000 in
  let gslfun = f in
  let {Gsl_fun.res = res ;
       Gsl_fun.err = err } = Gsl_integration.qags gslfun 
      ~a:0. ~b:1. ~epsabs:0. ~epsrel:1e-7 ws in
  Printf.printf "result          = % .18f\n" res ;
  Printf.printf "exact result    = % .18f\n" expected ;
  Printf.printf "estimated error = % .18f\n" err ;
  Printf.printf "actual error    = % .18f\n" (res -. expected) ;
  Printf.printf "intervals = %d\n" (Gsl_integration.size ws)

let _ = 
  Gsl_error.init ();
  compute (f 1.0) (-4.)
