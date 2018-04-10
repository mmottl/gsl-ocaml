open Base
open Stdio
open Do_common

module Printf = Caml.Printf
module Filename = Caml.Filename

open Printf

type arg_type = FLOAT | UINT

let parse_fun =
  let regexp_partial = Str.regexp "double gsl_cdf_" in
  let regexp_full = Str.regexp "double gsl_cdf_\\([^ ]+\\) (\\([^)]+\\));" in
  let regexp_arg =
    Str.regexp "const \\(double\\|unsigned int\\) \\([a-zA-Z0-9_]+\\)"
  in
  let rec loop ic s =
    if not (Str.string_match regexp_full s 0) then
      if not (Str.string_match regexp_partial s 0) then parse_fun ic
      else
        match In_channel.input_line ic with
        | Some line -> loop ic (s ^ " " ^ line)
        | None -> eprintf "partial line at EOF\n"; raise End_of_file
    else
      let fun_name = Str.matched_group 1 s in
      let args =
        let acc = ref [] in
        let i = ref (Str.group_beginning 2) in
        begin
          try
            while true do
              ignore (Str.search_forward regexp_arg s !i);
              let ty =
                match Str.matched_group 1 s with
                | "double" -> FLOAT
                | "unsigned int" -> UINT
                | _ -> assert false in
              let n = Str.matched_group 2 s in
              acc := (ty, n) :: !acc;
              i := Str.match_end ()
            done
          with Caml.Not_found -> ()
        end;
        List.rev !acc
      in
      if List.length args <= 5 then fun_name, args
      else begin
        eprintf
          "functions `%s' has more than 5 arguments, this is unsupported\n%!"
          fun_name;
        parse_fun ic
      end
  and parse_fun ic = loop ic (In_channel.input_line_exn ic) in
  parse_fun

let all_float args =
  List.for_all ~f:(function (FLOAT, _) -> true | _ -> false) args

let print_all_float fun_name buf args =
  if all_float args
  then bprintf buf " \"gsl_cdf_%s\" [@@unboxed] [@@noalloc]" fun_name

let print_ml_args buf args =
  List.iter ~f:(fun (ty, a) ->
    let l = String.lowercase a in
    match ty with
    | FLOAT -> bprintf buf "%s:float -> " l
    | UINT -> bprintf buf "%s:int -> " l)
    args

let print_ml buf (fun_name, args) =
  bprintf buf
    "external %s : %afloat = \"ml_gsl_cdf_%s\"%a\n"
    fun_name
    print_ml_args args
    fun_name
    (print_all_float fun_name) args

let print_c_args buf args =
  List.iter ~f:(fun (ty, _) ->
    match ty with
    | FLOAT -> Out_channel.output_string buf " Double_val,"
    | UINT -> Out_channel.output_string buf " Unsigned_int_val,")
    args

let print_c oc (fun_name, args) =
  fprintf oc
    "ML%d(gsl_cdf_%s,%a copy_double)\n"
    (List.length args)
    fun_name
    print_c_args args

let () =
  let gsl_header = Filename.concat gsl_include_dir "gsl_cdf.h" in
  In_channel.with_file gsl_header ~f:(fun ic ->
    Out_channel.with_file "cdf.mli" ~f:(fun cdfi_oc ->
      Out_channel.with_file "cdf.ml" ~f:(fun cdf_oc ->
        Out_channel.with_file "mlgsl_cdf.c" ~f:(fun cdfc_oc ->
          let print_both str =
            Out_channel.output_string cdfi_oc str;
            Out_channel.output_string cdf_oc str
          in
          Out_channel.output_string cdfc_oc
            "#include <gsl/gsl_cdf.h>\n#include \"wrappers.h\"\n\n";
          print_both "(** Cumulative distribution functions *)\n\n";
          try
            while true do
              let fn = parse_fun ic in
              let buf = Buffer.create 256 in
              print_ml buf fn;
              Out_channel.output_buffer cdfi_oc buf;
              Out_channel.output_buffer cdf_oc buf;
              print_c cdfc_oc fn
            done
          with End_of_file -> ());
        Out_channel.output_string cdf_oc "\nlet () = Error.init ()\n")))
