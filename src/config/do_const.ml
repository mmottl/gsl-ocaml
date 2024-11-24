open Printf
open Do_common

let () =
  let rex = Str.regexp "^#define GSL_CONST_[^_]+_\\(.*\\)\\b.*(\\(.*\\))" in
  let get_name line = String.lowercase_ascii (Str.matched_group 1 line) in
  let get_data line = String.lowercase_ascii (Str.matched_group 2 line) in
  Out_channel.with_file "const.mli" ~f:(fun mli_oc ->
      Out_channel.with_file "const.ml" ~f:(fun ml_oc ->
          let act const =
            let print_both str =
              output_string mli_oc str;
              output_string ml_oc str
            in
            print_both "(** Values of physical constants *)\n";
            let upper_const = String.uppercase_ascii const in
            fprintf mli_oc "\nmodule %s : sig\n" (String.uppercase_ascii const);
            fprintf ml_oc "\nmodule %s = struct\n" upper_const;
            let gsl_path =
              Filename.concat gsl_include_dir (sprintf "gsl_const_%s.h" const)
            in
            In_channel.with_file gsl_path ~f:(fun ic ->
                let rec loop () =
                  match input_line ic with
                  | line ->
                      if Str.string_match rex line 0 then (
                        let name = get_name line in
                        let data = get_data line in
                        fprintf mli_oc "  val %s : float\n" name;
                        fprintf ml_oc " let %s = %s\n" name data);
                      loop ()
                  | exception End_of_file -> print_both "end\n"
                in
                loop ())
          in
          let gsl_consts = [| "cgs"; "cgsm"; "mks"; "mksa"; "num" |] in
          Array.iter act gsl_consts;
          output_string ml_oc "\nlet () = Error.init ()\n"))
