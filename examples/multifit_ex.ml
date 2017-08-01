open Gsl

let () = Error.init ()

let read_lines () =
  let acc = ref [] in
  let cnt = ref 0 in
  begin
    try
      while true do
	acc := (read_line ()) :: !acc;
	incr cnt;
    done;
    with End_of_file -> ()
  end;
  Printf.printf "read %d points\n" !cnt;
  List.rev !acc

exception Wrong_format

let parse_input line = Scanf.sscanf line "%f %f %f" (fun a b c -> a, b, c)

let parse_data lines =
  let n = List.length lines in
  let x = Array.make n 0. in
  let y = Array.make n 0. in
  let w = Array.make n 0. in
  let _ = List.fold_left
      (fun i line ->
	let (xi, yi, ei) = parse_input line in
	Printf.printf "%3g %.5g +/- %g\n" xi yi ei;
	x.(i) <- xi;
	y.(i) <- yi;
	w.(i) <- (1. /. (ei *. ei));
	succ i) 0 lines in
  print_newline ();
  (x, y, w)

let setup (x, y, w) = 
  let n = Array.length x in
  let x' = Matrix.create n 3 in
  let y' = Vector.of_array y in
  let w' = Vector.of_array w in
  for i=0 to pred n do
    let xi = x.(i) in
    x'.{i, 0} <- 1.0;
    x'.{i, 1} <- xi;
    x'.{i, 2} <- xi *. xi;
  done;
  (x', y', w')

let fit (x, y, w) = 
  let (c, cov, chisq) = Multifit.linear ~weight:(`V w) (`M x) (`V y) in
  Printf.printf "# best fit: Y = %g + %g X + %g X^2\n"
    c.{0} c.{1} c.{2};
  Printf.printf "# covariance matrix:\n";
  Printf.printf "[ %+.5e, %+.5e, %+.5e  \n"
    cov.{0,0} cov.{0,1} cov.{0,2};
  Printf.printf "  %+.5e, %+.5e, %+.5e  \n"
    cov.{1,0} cov.{1,1} cov.{1,2};
  Printf.printf "  %+.5e, %+.5e, %+.5e ]\n"
    cov.{2,0} cov.{2,1} cov.{2,2};
  Printf.printf "# chisq = %g\n" chisq

let fit_alt (x, y, w) =
  let (c, _cov, chisq) = Multifit.fit_poly ~weight:w ~x ~y 3 in
  assert(Array.length c = 4);
  Printf.printf "# best fit: Y = %g + %g X + %g X^2 + %g X^3\n"
    c.(0) c.(1) c.(2) c.(3);
  Printf.printf "# chisq = %g\n" chisq
  

let () = 
  let data = parse_data (read_lines ()) in
  fit (setup data);
  print_newline ();
  fit_alt data
