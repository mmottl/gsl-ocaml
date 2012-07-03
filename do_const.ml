#load "str.cma"
#load "unix.cma"

open Printf

let () =
  let n_args = Array.length Sys.argv in
  printf "(** Values of physical constants *)\n";
  let rex = Str.regexp "^#define GSL_CONST_[^_]+_\\(.*\\)\\b.*(\\(.*\\))" in
  let is_mli = n_args > 1 && Sys.argv.(1) = "--mli" in
  let emit, n_drop =
    let get_name line = String.lowercase (Str.matched_group 1 line) in
    let get_data line = String.lowercase (Str.matched_group 2 line) in
    if is_mli then
      let emit line =
        let name = get_name line in
        printf "  val %s : float\n" name
      in
      emit, 2
    else
      let emit line =
        let name = get_name line in
        let data = get_data line in
        printf " let %s = %s\n" name data
      in
      emit, 1
  in
  let gsl_prefix =
    let ic = Unix.open_process_in "gsl-config --prefix" in
    try input_line ic
    with exc -> close_in ic; raise exc
  in
  let act const =
    let upper_const = String.uppercase const in
    if is_mli then printf "\nmodule %s : sig\n" (String.uppercase const)
    else printf "\nmodule %s = struct\n" upper_const;
    let gsl_path = sprintf "%s/include/gsl/gsl_const_%s.h" gsl_prefix const in
    let ic = open_in gsl_path in
    try
      let rec loop () =
        match try Some (input_line ic) with End_of_file -> None with
        | Some line ->
            if Str.string_match rex line 0 then emit line;
            loop ()
        | None -> close_in ic
      in
      loop ();
      printf "end\n"
    with exc -> close_in ic; raise exc
  in
  let gsl_consts = [| "cgs"; "cgsm"; "mks"; "mksa"; "num" |] in
  Array.iter act gsl_consts
