open Gsl

let () =
  Error.init ()

let print_arr arr =
  Array.iter (fun i -> Printf.printf "% 4d " i) arr ;
  print_newline ()

let () =
  let c = Combi.make 4 2 in
  for _i = 0 to int_of_float (Sf.choose 4 2) do
    print_arr (Combi.to_array c);
    Combi.next c
  done
