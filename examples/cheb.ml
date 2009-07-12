let f x = 
  if x < 0.5
  then 0.25
  else 0.75

let test n = 
  let cs = Gsl_cheb.make 40 in
  Gsl_cheb.init cs f 0. 1. ;
  begin
    let coefs = Gsl_cheb.coefs cs in
    Printf.printf "coefs = [" ;
    for i=0 to 40 do
      Printf.printf " %f;" coefs.(i)
    done ;
    Printf.printf " ]\n"
  end ;
  for i=0 to pred n do
    let x = float i /. float n in
    let r10 = Gsl_cheb.eval cs ~order:10 x in
    let r40 = Gsl_cheb.eval cs x in
    Printf.printf "%g %g %g %g\n"
      x (f x) r10 r40 
  done

let _ = 
  Gsl_error.init ();
  test 1000
