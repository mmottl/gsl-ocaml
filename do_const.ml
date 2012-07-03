#load "str.cma"
#load "unix.cma"

open Printf

let () =
  let n_args = Array.length Sys.argv in
  printf "(** Values of physical constants *)\n\n";
  let rex = Str.regexp "^#define GSL_CONST_\\(.*\\)\\b.*(\\(.*\\))" in
  let emit, n_drop =
    let get_name line = String.lowercase (Str.matched_group 1 line) in
    let get_data line = String.lowercase (Str.matched_group 2 line) in
    if n_args > 1 && Sys.argv.(1) = "--mli" then
      let emit line =
        let name = get_name line in
        printf "val %s : float\n" name
      in
      emit, 2
    else
      let emit line =
        let name = get_name line in
        let data = get_data line in
        printf "let %s = %s\n" name data
      in
      emit, 1
  in
  let act file =
    let ic = open_in file in
    try
      let rec loop () =
        match try Some (input_line ic) with End_of_file -> None with
        | Some line ->
            if Str.string_match rex line 0 then emit line;
            loop ()
        | None -> close_in ic

      in
      loop ()
    with exc -> close_in ic; raise exc
  in
  let gsl_prefix =
    let ic = Unix.open_process_in "gsl-config --prefix" in
    try input_line ic
    with exc -> close_in ic; raise exc
  in
  let gsl_consts = [| "cgsm"; "mksa"; "num" |] in
  let mk_file const =
    sprintf "%s/include/gsl/gsl_const_%s.h" gsl_prefix const
  in
  let gsl_paths = Array.map mk_file gsl_consts in
  Array.iter act gsl_paths
