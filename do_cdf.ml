#load "str.cma"

type arg_type =
  | FLOAT
  | UINT

let parse = 
  let regexp_full = Str.regexp "double gsl_cdf_\\([^ ]+\\) (\\([^)]+\\));" in
  let regexp_arg  = Str.regexp "const \\(double\\|unsigned int\\) \\([a-zA-Z0-9_]+\\)" in
  fun s ->
    if Str.string_match regexp_full s 0
    then
      let fun_name = Str.matched_group 1 s in
      let args = 
	begin 
	  let acc = ref [] in
	  let i = ref (Str.group_beginning 2) in
	  begin try while true do
	    let _ = Str.search_forward regexp_arg s !i in
	    let ty =
	      match Str.matched_group 1 s with
	      | "double" -> FLOAT
	      | "unsigned int" -> UINT 
	      | _ -> assert false in
	    let n = Str.matched_group 2 s in
	    acc := (ty, n) :: !acc ;
	    i := Str.match_end ()
	  done
	  with Not_found -> () end ;
	  List.rev !acc
	end in
      if List.length args > 5
      then (Printf.eprintf "functions `%s' has more than 5 arguments, this is unsupported\n%!" fun_name ; None)
      else Some (fun_name, args)
    else
      None

let may f = function
  | None -> ()
  | Some v -> f v

let all_float args =
  List.for_all (function (FLOAT, _) -> true | _ -> false) args
let print_all_float fun_name oc args =
  if all_float args
  then Printf.fprintf oc " \"gsl_cdf_%s\" \"float\"" fun_name
let print_ml_args oc args = 
  List.iter (fun (ty, a) ->
    let l = String.lowercase a in
    match ty with
    | FLOAT -> Printf.fprintf oc "%s:float -> " l
    | UINT  -> Printf.fprintf oc "%s:int -> "   l)
    args
let print_ml (fun_name, args) =
  Printf.printf 
    "external %s : %afloat = \"ml_gsl_cdf_%s\"%a\n"
    fun_name
    print_ml_args args
    fun_name
    (print_all_float fun_name) args

let print_c_args oc args =
  List.iter (fun (ty, _) ->
    match ty with
    | FLOAT -> output_string oc " Double_val,"
    | UINT  -> output_string oc " Unsigned_int_val,")
    args
let print_c (fun_name, args) =
  Printf.printf 
    "ML%d(gsl_cdf_%s,%a copy_double)\n\n"
    (List.length args) 
    fun_name 
    print_c_args args

let c_output = 
  Array.length Sys.argv > 1 && Sys.argv.(1) = "--c"

let _ =
  if c_output
  then Printf.printf "#include <gsl/gsl_cdf.h>\n#include \"wrappers.h\"\n\n" 
  else Printf.printf "(** Cumulative distribution functions *)\n\n" ;

  try while true do
    may 
      (if c_output then print_c else print_ml) 
      (parse (read_line ()))
  done with End_of_file -> ()
