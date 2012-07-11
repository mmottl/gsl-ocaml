open Gsl

let print_data a r =
  let n = Array.length a / 2 in
  for i = 0 to n - 1 do
    let c = Gsl_complex.get a i in
    Printf.printf "%d %e %e\n"
      i
      (c.Gsl_complex.re *. r)
      (c.Gsl_complex.im *. r)
  done ;
  Printf.printf "\n"


let init_data n =
  let data = Array.make (n * 2) 0. in
  let one = Complex.one in
  Gsl_complex.set data 0 one ;
  for i = 1 to 10 do
    Gsl_complex.set data i       one ;
    Gsl_complex.set data (n - i) one
  done ;
  data


let main n =
  let data = init_data n in
  print_data data 1. ;
  Fft.Complex.forward_rad2 data ;
  print_data data (1. /. sqrt (float n))

let _ =
  main 128
