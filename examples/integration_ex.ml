open Gsl

let f alpha x =
  Gc.major ();
  log (alpha *. x) /. sqrt x

let compute f expected =
  let ws = Integration.make_ws 1000 in
  let gslfun = f in
  let { Fun.res; Fun.err } =
    Integration.qags gslfun ~a:0. ~b:1. ~epsabs:0. ~epsrel:1e-7 ws
  in
  Printf.printf "result          = % .18f\n" res;
  Printf.printf "exact result    = % .18f\n" expected;
  Printf.printf "estimated error = % .18f\n" err;
  Printf.printf "actual error    = % .18f\n" (res -. expected);
  Printf.printf "intervals = %d\n" (Integration.size ws)

let _ =
  Error.init ();
  compute (f 1.0) (-4.)
