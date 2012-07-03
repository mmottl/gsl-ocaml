open Gsl

let _ =
  Error.init ();;

let check_return_status = function
  | Unix.WEXITED 0 -> true
  | _ -> false

open Interp

let print_data oc i = 
  Printf.fprintf oc "#m=0,S=2\n" ;
  for j=0 to 9 do
    Printf.fprintf oc "%g %g\n" i.xa.(j) i.ya.(j) 
  done 

let print_interp oc i = 
  Printf.fprintf oc "#m=1,S=0\n" ;
  let xi = ref i.xa.(0) in
  let yi = ref 0. in
  while !xi < i.xa.(9) do
    yi := Interp.eval i !xi ;
    Printf.fprintf oc "%g %g\n" !xi !yi ;
    xi := !xi +. 0.1
  done

let x = Array.init 10 
    (fun i -> float i +. 0.5 *. sin (float i)) 
let y = Array.init 10
    (fun i -> float i +. cos (float (i*i)))

let _ = 
  let i = Interp.make_interp Interp.CSPLINE x y in
  let oc = Unix.open_process_out "graph -T X" in
  print_data oc i ;
  print_interp oc i ;
  flush oc ;
  if not (check_return_status (Unix.close_process_out oc))
  then prerr_endline "Oops !"
