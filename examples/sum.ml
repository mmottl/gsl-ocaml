
let _ = 
  Gsl_error.init ()

let zeta2 = Gsl_math.pi *. Gsl_math.pi /. 6.

let zeta_terms n =
  let t = Array.make n 0. in
  let sum = ref 0. in
  for i=0 to pred n do
    let np1 = float (i + 1) in
    t.(i) <- 1. /. (np1 *. np1) ;
    sum := !sum +. t.(i)
  done ;
  (t, !sum)

let print_res sum nbterms sum_accel sum_plain nbterms_accel =
  Printf.printf "term-by-term sum = % .16f using %d terms\n"
    sum nbterms ;
  Printf.printf "term-by-term sum = % .16f using %d terms\n"
    sum_plain nbterms_accel ;
  Printf.printf "exact value      = % .16f\n" zeta2 ;
  Printf.printf "accelerated sum  = % .16f using %d terms\n"
    sum_accel.Gsl_fun.res nbterms_accel ;
  Printf.printf "estimated error  = % .16f\n"
    sum_accel.Gsl_fun.err ;
  Printf.printf "actual error     = % .16f\n"
    (sum_accel.Gsl_fun.res -. zeta2)

let _ = 
  let n = 20 in
  let (t, sum) = zeta_terms n in
  let ws = Gsl_sum.make n in
  let res = Gsl_sum.accel t ws in
  let { Gsl_sum.sum_plain = sum_plain ;
	Gsl_sum.terms_used = nbterms_used } = Gsl_sum.get_info ws in
  print_res sum n res sum_plain nbterms_used ;
  print_newline ();
  print_endline "\"truncated\" version:" ;
  let ws = Gsl_sum.Trunc.make n in
  let res = Gsl_sum.Trunc.accel t ws in
  let { Gsl_sum.Trunc.sum_plain = sum_plain ;
	Gsl_sum.Trunc.terms_used = nbterms_used } = 
    Gsl_sum.Trunc.get_info ws in
  print_res sum n res sum_plain nbterms_used
