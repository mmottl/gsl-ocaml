open Gsl

let print_data { Fft.data = a } =
  for i = 0 to Array.length a - 1 do
    Printf.printf "%d: %e\n" i a.(i)
  done;
  Printf.printf "\n"

let init_data n =
  let data = Array.make n 0. in
  Array.fill data (n / 3) (n / 3) 1.;
  { Fft.layout = Fft.Real; data }

let main n =
  let data = init_data n in
  print_data data;
  let ws = Fft.Real.make_workspace n and wt = Fft.Real.make_wavetable n in
  Fft.Real.transform data wt ws;
  Array.fill data.Fft.data 11 (n - 11) 0.;
  let wt_hc = Fft.Halfcomplex.make_wavetable n in
  Fft.Halfcomplex.inverse data wt_hc ws;
  print_data data

let _ = main 100
