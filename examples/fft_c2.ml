open Gsl

let print_data a =
  let n = Array.length a / 2 in
  for i = 0 to n - 1 do
    let c = Gsl_complex.get a i in
    Printf.printf "%d: %e %e\n" i c.Gsl_complex.re c.Gsl_complex.im
  done;
  Printf.printf "\n"

let init_data n =
  let data = Array.make (n * 2) 0. in
  let one = Complex.one in
  Gsl_complex.set data 0 one;
  for i = 1 to 10 do
    Gsl_complex.set data i one;
    Gsl_complex.set data (n - i) one
  done;
  data

let main n =
  let data = init_data n in
  print_data data;
  let wt = Fft.Complex.make_wavetable n and ws = Fft.Complex.make_workspace n in
  Fft.Complex.forward data wt ws;
  print_data data

let _ = main 630
