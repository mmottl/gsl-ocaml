open Printf
open Do_common

type arg_type = FLOAT | UINT

let parse_fun =
  let regexp_partial = Str.regexp "double gsl_cdf_" in
  let regexp_full = Str.regexp "double gsl_cdf_\\([^ ]+\\) (\\([^)]+\\));" in
  let regexp_arg =
    Str.regexp "const \\(double\\|unsigned int\\) \\([a-zA-Z0-9_]+\\)"
  in
  let rec loop ic s =
    if not (Str.string_match regexp_full s 0) then (
      if not (Str.string_match regexp_partial s 0) then parse_fun ic
      else
        match input_line ic with
        | line -> loop ic (s ^ " " ^ line)
        | exception End_of_file ->
            eprintf "partial line at EOF\n";
            raise End_of_file)
    else
      let fun_name = Str.matched_group 1 s in
      let args =
        let acc = ref [] in
        let i = ref (Str.group_beginning 2) in
        (try
           while true do
             ignore (Str.search_forward regexp_arg s !i);
             let ty =
               match Str.matched_group 1 s with
               | "double" -> FLOAT
               | "unsigned int" -> UINT
               | _ -> assert false
             in
             let n = Str.matched_group 2 s in
             acc := (ty, n) :: !acc;
             i := Str.match_end ()
           done
         with Not_found -> ());
        List.rev !acc
      in
      if List.length args <= 5 then (fun_name, args)
      else (
        eprintf
          "functions `%s' has more than 5 arguments, this is unsupported\n%!"
          fun_name;
        parse_fun ic)
  and parse_fun ic = loop ic (input_line ic) in
  parse_fun

let all_float args =
  List.for_all (function FLOAT, _ -> true | _ -> false) args

let print_all_float fun_name buf args =
  if all_float args then
    bprintf buf " \"gsl_cdf_%s\" [@@unboxed] [@@noalloc]" fun_name

let print_ml_args buf args =
  List.iter
    (fun (ty, a) ->
      let l = String.lowercase_ascii a in
      match ty with
      | FLOAT -> bprintf buf "%s:float -> " l
      | UINT -> bprintf buf "%s:int -> " l)
    args

let print_ml buf (fun_name, args) =
  bprintf buf "external %s : %afloat = \"ml_gsl_cdf_%s\"%a\n" fun_name
    print_ml_args args fun_name (print_all_float fun_name) args

let print_c_args buf args =
  List.iter
    (fun (ty, _) ->
      match ty with
      | FLOAT -> output_string buf " Double_val,"
      | UINT -> output_string buf " Unsigned_int_val,")
    args

let print_c oc (fun_name, args) =
  fprintf oc "ML%d(gsl_cdf_%s,%a caml_copy_double)\n" (List.length args)
    fun_name print_c_args args

let () =
  let gsl_header = Filename.concat gsl_include_dir "gsl_cdf.h" in
  In_channel.with_file gsl_header ~f:(fun ic ->
      Out_channel.with_file "cdf.mli" ~f:(fun cdfi_oc ->
          Out_channel.with_file "cdf.ml" ~f:(fun cdf_oc ->
              Out_channel.with_file "mlgsl_cdf.c" ~f:(fun cdfc_oc ->
                  let print_both str =
                    output_string cdfi_oc str;
                    output_string cdf_oc str
                  in
                  output_string cdfc_oc
                    "#include <gsl/gsl_cdf.h>\n#include \"wrappers.h\"\n\n";
                  print_both "(** Cumulative distribution functions *)\n\n";
                  try
                    while true do
                      let fn = parse_fun ic in
                      let buf = Buffer.create 256 in
                      print_ml buf fn;
                      Buffer.output_buffer cdfi_oc buf;
                      Buffer.output_buffer cdf_oc buf;
                      print_c cdfc_oc fn
                    done
                  with End_of_file -> ());
              output_string cdf_oc "\nlet () = Error.init ()\n")))
