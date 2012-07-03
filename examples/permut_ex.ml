open Bigarray
open Gsl

let _ = 
  Error.init () ;
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
  let p = Permut.make 5 in
  Permut.next p ;
  print_string "permut :" ; print_arr (Permut.to_array p) ;
  let a = Array.init 5 (fun _ -> Random.int 10) in
  print_string "arr :" ; print_arr a ;
  Permut.permute p a ;
  print_string "arr :" ; print_arr a ;
  
  let a1 = Array1.of_array int c_layout a in
  print_string "arr1 :" ; print_barr a1 ;
  Permut.permute_barr p a1 ;
  print_string "arr1 :" ; print_barr a1
  
    
