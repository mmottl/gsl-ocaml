open Bigarray

let _ = 
  Gsl_error.init () ;
  Random.self_init ()

let print_arr arr = 
  Array.iter (fun i -> Printf.printf "% 4d " i) arr ;
  print_newline ()

let print_barr arr = 
  for i=0 to pred (Array1.dim arr) do
    Printf.printf "% 4d " arr.{i}
  done ;
  print_newline ()

let _ = 
  let p = Gsl_permut.make 5 in
  Gsl_permut.next p ;
  print_string "permut :" ; print_arr (Gsl_permut.to_array p) ;
  let a = Array.init 5 (fun _ -> Random.int 10) in
  print_string "arr :" ; print_arr a ;
  Gsl_permut.permute p a ;
  print_string "arr :" ; print_arr a ;
  
  let a1 = Array1.of_array int c_layout a in
  print_string "arr1 :" ; print_barr a1 ;
  Gsl_permut.permute_barr p a1 ;
  print_string "arr1 :" ; print_barr a1
  
    
