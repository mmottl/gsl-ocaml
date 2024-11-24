open Gsl

let _ = Error.init ()
let zeta2 = Math.pi *. Math.pi /. 6.

let zeta_terms n =
  let t = Array.make n 0. in
  let sum = ref 0. in
  for i = 0 to pred n do
    let np1 = float (i + 1) in
    t.(i) <- 1. /. (np1 *. np1);
    sum := !sum +. t.(i)
  done;
  (t, !sum)

let print_res sum nbterms sum_accel sum_plain nbterms_accel =
  Printf.printf "term-by-term sum = % .16f using %d terms\n" sum nbterms;
  Printf.printf "term-by-term sum = % .16f using %d terms\n" sum_plain
    nbterms_accel;
  Printf.printf "exact value      = % .16f\n" zeta2;
  Printf.printf "accelerated sum  = % .16f using %d terms\n" sum_accel.Fun.res
    nbterms_accel;
  Printf.printf "estimated error  = % .16f\n" sum_accel.Fun.err;
  Printf.printf "actual error     = % .16f\n" (sum_accel.Fun.res -. zeta2)

let _ =
  let n = 20 in
  let t, sum = zeta_terms n in
  let ws = Sum.make n in
  let res = Sum.accel t ws in
  let { Sum.sum_plain; Sum.terms_used = nbterms_used } = Sum.get_info ws in
  print_res sum n res sum_plain nbterms_used;
  print_newline ();
  print_endline "\"truncated\" version:";
  let ws = Sum.Trunc.make n in
  let res = Sum.Trunc.accel t ws in
  let { Sum.Trunc.sum_plain; Sum.Trunc.terms_used = nbterms_used } =
    Sum.Trunc.get_info ws
  in
  print_res sum n res sum_plain nbterms_used
