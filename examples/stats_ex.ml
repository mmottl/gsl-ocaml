open Gsl

let _ = 
  let data = [| 17.2; 18.1; 16.5; 18.3; 12.6 |] in
  let mean = Stats.mean data in
  let variance = Stats.variance data in
  let largest  = Stats.max data in
  let smallest = Stats.min data in
  Printf.printf "The dataset is %g, %g, %g, %g, %g\n"
    data.(0) data.(1) data.(2) data.(3) data.(4) ;
  Printf.printf "The sample mean is %g\n" mean ;
  Printf.printf "The estimated variance is %g\n"  variance ;
  Printf.printf "The largest value is %g\n"  largest ;
  Printf.printf "The smallest value is %g\n"  smallest

let _ = 
  let data = [| 17.2; 18.1; 16.5; 18.3; 12.6 |] in
  Printf.printf "Original dataset is %g, %g, %g, %g, %g\n"
    data.(0) data.(1) data.(2) data.(3) data.(4) ;
  Array.sort compare data ;
  Printf.printf "Sorted dataset is %g, %g, %g, %g, %g\n"
    data.(0) data.(1) data.(2) data.(3) data.(4) ;
  let median = Stats.quantile_from_sorted_data data 0.5 in
  let upperq = Stats.quantile_from_sorted_data data 0.75 in
  let lowerq = Stats.quantile_from_sorted_data data 0.25 in
  Printf.printf "The median is %g\n" median ;
  Printf.printf "The upper quartile is %g\n" upperq ;
  Printf.printf "The lower quartile is %g\n" lowerq

