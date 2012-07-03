open Gsl

let read_file init do_line finish f =
  let ic = open_in f in
  let acc = ref init in
  begin
    try
      while true do
	let l = input_line ic in
	acc := do_line !acc l
      done
    with 
    | End_of_file -> close_in ic
    | exn -> close_in ic ; raise exn
  end ;
  finish !acc

let read_data_file =
  read_file []
    (fun acc l -> float_of_string l :: acc)
    (fun acc -> Array.of_list (List.rev acc))

let main f =
  let data = read_data_file f in
  let n = Array.length data in
  Printf.eprintf "read %d values\n%!" n ;

  let w = Wavelet.make Wavelet.DAUBECHIES 4 in
  Wavelet.transform_forward w data ;
  let high = 
    Gsl_sort.vector_flat_largest_index 20 
      (Vector_flat.view_array (Array.map abs_float data)) in
  let high_coeff = Array.make n 0. in
  for i = 0 to 20 - 1 do
    let j = high.{i} in
    high_coeff.(j) <- data.(j)
  done ;
  Wavelet.transform_inverse w high_coeff ;
  
  Array.iter
    (fun f -> Printf.printf "%g\n" f)
    high_coeff

let _ = 
  Error.init () ;
  Error.handle_exn main "ecg.dat"
