(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2017-     - Markus Mottl                   *)
(* Copyright (©) 2002-2005 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)

open Printf

open Do_common

let split ?(collapse=false) c s =
  let len = String.length s in
  let rec proc accu n =
    let n' =
      match String.index_from s n c with
      | i -> i
      | exception Not_found -> len
    in
    let accu' =
      if collapse && n' = n
      then accu
      else (String.sub s n (n' - n)) :: accu in
    if n' >= len - 1
    then List.rev accu'
    else proc accu' (n' + 1)
  in
  proc [] 0

let words_list s = split ~collapse:true ' ' s

(** Quotation for externals :
   << fun1,arg1,arg2 >> ->
      external fun1 : arg1 -> arg2 = "fun1"
   << fun1@fun_c,arg1,arg2 >> ->
      external fun1 : arg1 -> arg2 = "fun_c"
   << fun1@fun_c@fun_f,float,float >> ->
      external fun1 : float -> float = "fun_c" "fun_f" "float"
*)
let ext_quot =
  let b = Buffer.create 256 in
  let bh = Format.formatter_of_buffer b in
  fun str ->
    Buffer.clear b;
    match split ',' str with
    | [] -> failwith "ext_quot: empty quotation"
    | _ :: [] -> failwith "ext_quot: no arguments"
    | name_r :: (arg1 :: argr as args) ->
        let name, name_c, name_float =
          match String.split_on_char '@' name_r with
          | name :: [] -> name, name, ""
          | name :: name_c :: [] -> name, name_c, ""
          | name :: name_c :: name_f :: _ -> name, name_c, name_f
          | [] -> failwith "ext_quot: too many C function names"
        in
        Format.fprintf bh "@[<2>external %s : %s"
          (String.trim name) (String.trim arg1);
        List.iter (fun a -> Format.fprintf bh " -> %s" (String.trim a)) argr;
        Format.fprintf bh "@ = ";
        if List.length args > 6 then Format.fprintf bh "\"%s_bc\"" name_c;
        if
          (* List.for_all ~f:((=) "float") args && *)
          (name_float <> "")
        then begin
          if List.length args <= 6 then
            Format.fprintf bh "\"%s\"" name_c;
          Format.fprintf bh " \"%s\" [%@%@unboxed] [%@%@noalloc]" name_float
        end else Format.fprintf bh "\"%s\"" name_c;
        Format.fprintf bh "@]%!";
        Buffer.contents b

(** << fun1 arg1 arg2 >> → << fun1@ml_gsl_sf_fun1,arg1,arg2,float >>
                         → << fun1_e@ml_gsl_sf_fun1_e,arg1,arg2,result >> *)
let sf_quot =
  let b = Buffer.create 256 in
  fun str ->
    let wl = words_list str in
    let flt, wl = List.partition ((=) "@float") wl in
    let has_float = not (flt = []) in
    match wl with
    | [] -> failwith "sf_quot: empty quotation"
    | _ :: [] -> failwith "sf_quot: no arguments"
    | name :: args ->
        let quot =
          Buffer.clear b;
          bprintf b "%s@ml_gsl_sf_%s%s," name name
            (if has_float && List.for_all ((=) "float") args then
               "@" ^ "gsl_sf_" ^ name
             else "");
          List.iter (fun a -> bprintf b "%s," a) args;
          bprintf b "float";
          Buffer.contents b
        in
        let quot_res =
          Buffer.clear b;
          bprintf b "%s_e@ml_gsl_sf_%s_e," name name;
          List.iter (fun a -> bprintf b "%s," a) args;
          bprintf b "result";
          Buffer.contents b
        in
        String.concat "\n" (List.map ext_quot [ quot; quot_res ])

let bessel_quot str =
  match words_list str with
  | "cyl" :: letter :: tl ->
      let tl = String.concat " " tl in
      String.concat ""
        [ sf_quot ("bessel_" ^ letter ^ "0 float " ^ tl);
          sf_quot ("bessel_" ^ letter ^ "1 float " ^ tl);
          sf_quot ("bessel_" ^ letter ^ "n int float " ^ tl);
          ext_quot
            (sprintf "bessel_%sn_array@ml_gsl_sf_bessel_%sn_array,\
                      int,float,float array,unit" letter letter);
        ]
  | "cyl_scaled" :: letter :: tl ->
      let tl = String.concat " " tl in
      String.concat ""
        [ sf_quot ("bessel_" ^ letter ^ "0_scaled float " ^ tl);
          sf_quot ("bessel_" ^ letter ^ "1_scaled float " ^ tl);
          sf_quot ("bessel_" ^ letter ^ "n_scaled int float " ^ tl);
          ext_quot
            (sprintf
               "bessel_%sn_scaled_array@ml_gsl_sf_bessel_%sn_scaled_array,\
                int,float,float array,unit" letter letter);
        ]
  | "sph" :: letter :: tl ->
      let tl = String.concat " " tl in
      String.concat ""
        [ sf_quot ("bessel_" ^ letter ^ "0 float " ^ tl);
          sf_quot ("bessel_" ^ letter ^ "1 float " ^ tl);
          sf_quot ("bessel_" ^ letter ^ "2 float " ^ tl);
          sf_quot ("bessel_" ^ letter ^ "l int float " ^ tl);
          ext_quot
            (sprintf "bessel_%sl_array@ml_gsl_sf_bessel_%sl_array,\
                      int,float,float array,unit" letter letter);
        ]
  | "sph_scaled" :: letter :: tl ->
      let tl = String.concat " " tl in
      String.concat ""
        [ sf_quot ("bessel_" ^ letter ^ "0_scaled float " ^ tl);
          sf_quot ("bessel_" ^ letter ^ "1_scaled float " ^ tl);
          sf_quot ("bessel_" ^ letter ^ "l_scaled int float " ^ tl);
          ext_quot
            (sprintf
               "bessel_%sl_scaled_array@ml_gsl_sf_bessel_%sl_scaled_array,\
                int,float,float array,unit" letter letter);
        ]
  | _ -> failwith "bessel_quot: wrong args for quotation"

let process_line =
  let quotation = Str.regexp "<\\(:[a-z]*\\)?<\\(.*\\)>>$" in
  fun l ->
    if not (Str.string_match quotation l 0) then l
    else
      let quot =
        try Str.matched_group 1 l
        with Not_found -> ":sf" in
      let data = Str.matched_group 2 l in
      match quot with
      | ":ext" -> ext_quot data
      | ":sf" -> sf_quot data
      | ":bessel" -> bessel_quot data
      | _ -> "(* quotation parse error *)"

let () =
  In_channel.with_file "sf.mli.q" ~f:(fun ic ->
    Out_channel.with_file "sf.mli" ~f:(fun mli_oc ->
      Out_channel.with_file "sf.ml" ~f:(fun ml_oc ->
        In_channel.iter_lines ic ~f:(fun l ->
          let nl = process_line l in
          output_string mli_oc nl;
          output_string ml_oc nl;
          output_char mli_oc '\n';
          output_char ml_oc '\n');
        output_string ml_oc "\nlet () = Error.init ()\n")))
