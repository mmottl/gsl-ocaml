let _ = 
  let qrng = Gsl_qrng.make Gsl_qrng.SOBOL 2 in
  let tmp = Array.make 2 0. in
  for i=0 to 1023 do
    Gsl_qrng.get qrng tmp ;
    Printf.printf "%.5f %.5f\n" tmp.(0) tmp.(1)
  done
