open Gsl

let _ = 
  let qrng = Qrng.make Qrng.SOBOL 2 in
  let tmp = Array.make 2 0. in
  for _i = 0 to 1023 do
    Qrng.get qrng tmp ;
    Printf.printf "%.5f %.5f\n" tmp.(0) tmp.(1)
  done
