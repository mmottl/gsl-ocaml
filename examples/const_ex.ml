open Gsl

let () =
  let au  = Const.MKSA.astronomical_unit in
  let c   = Const.MKSA.speed_of_light in
  let min = Const.MKSA.minute in

  let r_earth = 1.00 *. au in
  let r_mars  = 1.52 *. au in

  Printf.printf "light travel time from Earth to Mars:\n" ;
  Printf.printf "minimum = %.1f minutes\n" ((r_mars -. r_earth) /. c /. min) ;
  Printf.printf "maximum = %.1f minutes\n" ((r_mars +. r_earth) /. c /. min)
