open Base
open Stdio
open Do_common

module Sys = Caml.Sys
module Printf = Caml.Printf
module Filename = Caml.Filename

open Printf

let () =
  let rex = Str.regexp "^#define GSL_CONST_[^_]+_\\(.*\\)\\b.*(\\(.*\\))" in
  let get_name line = String.lowercase (Str.matched_group 1 line) in
  let get_data line = String.lowercase (Str.matched_group 2 line) in
  Out_channel.with_file "const.mli" ~f:(fun mli_oc ->
    Out_channel.with_file "const.ml" ~f:(fun ml_oc ->
      let act const =
        let print_both str =
          Out_channel.output_string mli_oc str;
          Out_channel.output_string ml_oc str
        in
        print_both "(** Values of physical constants *)\n";
        let upper_const = String.uppercase const in
        fprintf mli_oc "\nmodule %s : sig\n" (String.uppercase const);
        fprintf ml_oc "\nmodule %s = struct\n" upper_const;
        let gsl_path =
          Caml.Filename.concat gsl_include_dir
            (sprintf "gsl_const_%s.h" const)
        in
        In_channel.with_file gsl_path ~f:(fun ic ->
          let rec loop () =
            match In_channel.input_line ic with
            | Some line ->
                if Str.string_match rex line 0 then begin
                  let name = get_name line in
                  let data = get_data line in
                  fprintf mli_oc "  val %s : float\n" name;
                  fprintf ml_oc " let %s = %s\n" name data
                end;
                loop ()
            | None -> print_both "end\n"
          in
          loop ())
      in
      let gsl_consts = [| "cgs"; "cgsm"; "mks"; "mksa"; "num" |] in
      Array.iter ~f:act gsl_consts;
      Out_channel.output_string ml_oc "\nlet () = Error.init ()\n"))
