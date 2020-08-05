let channel_with_file open_ch close_ch name ~f =
  let ch = open_ch name in
  Fun.protect ~finally:(fun () -> close_ch ch) (fun () -> f ch)

module In_channel = struct
  let with_file file = channel_with_file open_in close_in file

  let rec iter_lines ic ~f =
    match input_line ic with
    | line -> f line; iter_lines ic ~f
    | exception End_of_file -> ()
end  (* In_channel *)

module Out_channel = struct
  let with_file file = channel_with_file open_out close_out file
end  (* Out_channel *)

let gsl_include_dir =
  let gsl_include =
    let ic = open_in "gsl_include.sexp"in
    Fun.protect ~finally:(fun () -> close_in ic) (fun () -> input_line ic)
  in
  Filename.concat gsl_include "gsl"
