open Gsl

let pprint_histo { Histo.n = n ; 
		   Histo.range = r ; 
		   Histo.bin = b } =
  for i=0 to pred n do
    Printf.printf "%g %g %g\n"
      r.(i) r.(succ i) b.(i)
  done


let main xmin xmax n =
  let h = Histo.make n in
  Histo.set_ranges_uniform h ~xmin ~xmax ;
  
  begin try while true do
    Scanf.scanf "%g" 
      (fun x -> Histo.accumulate h x)
  done
  with End_of_file -> () 
  end ;

  pprint_histo h
    

let _ = 
  if Array.length Sys.argv <> 4
  then (
    Printf.printf "Usage: gsl-histogram xmin xmax n\n" ;
    Printf.printf "Computes a histogram of the data on \
                   stdin using n bins from xmin to xmax\n" ;
    exit 1 ) ;
  main 
    (float_of_string Sys.argv.(1))
    (float_of_string Sys.argv.(2))
    (int_of_string Sys.argv.(3))
