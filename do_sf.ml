(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2005 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)

#load "str.cma"

open Printf

let split ?(collapse=false) c s =
  let len = String.length s in
  let rec proc accu n =
    let n' =
      try String.index_from s n c
      with Not_found -> len in
    let accu' =
      if collapse && n' = n
      then accu
      else (String.sub s n (n' - n)) :: accu in
    if n' >= len - 1
    then List.rev accu'
    else proc accu' (succ n')
  in
  proc [] 0

let words_list s =
  split ~collapse:true ' ' s


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
    Buffer.clear b ;
    match split ',' str with
    | [] -> failwith "ext_quot: empty quotation"
    | _ :: [] -> failwith "ext_quot: no arguments"
    | name_r :: (arg1 :: argr as args) ->
       let (name, name_c, name_float) = match split '@' name_r with
         | name :: [] -> name, name, ""
         | name :: name_c :: [] -> name, name_c, ""
         | name :: name_c :: name_f :: _ -> name, name_c, name_f
         | [] -> failwith "ext_quot: too many C function names"
       in
       Format.fprintf bh "@[<2>external %s : %s" name arg1 ;
       List.iter (fun a -> Format.fprintf bh " -> %s" a) argr ;
       Format.fprintf bh "@ = " ;
       if List.length args > 6 then
         Format.fprintf bh "\"%s_bc\"" name_c ;
       if (List.for_all ((=) "float") args) && name_float <> "" then (
         if List.length args <= 6 then
           Format.fprintf bh "\"%s\"" name_c ;
         Format.fprintf bh " \"%s\" \"float\"" name_float
       )
       else
         Format.fprintf bh "\"%s\"" name_c ;
       Format.fprintf bh "@]@\n%!";
       Buffer.contents b


let sf_quot =
  let b = Buffer.create 256 in
  fun str ->
    let wl = words_list str in
    let float, wl = List.partition ((=) "@float") wl in
    let float = float <> [] in
    match wl with
    | [] -> failwith "sf_quot: empty quotation"
    | _ :: [] -> failwith "sf_quot: no arguments"
    | name :: args ->
        let quot =
          Buffer.clear b ;
          bprintf b "%s@ml_gsl_sf_%s%s," name name
                  (if float && List.for_all ((=) "float") args then
                     "@" ^ "gsl_sf_" ^ name
                   else "");
          List.iter (fun a -> bprintf b "%s," a) args ;
          bprintf b "float" ;
          Buffer.contents b
        in
        let quot_res =
          Buffer.clear b ;
          bprintf b "%s_e@ml_gsl_sf_%s_e," name name ;
          List.iter (fun a -> bprintf b "%s," a) args ;
          bprintf b "result" ;
          Buffer.contents b
        in
        String.concat "" (List.map ext_quot [ quot ; quot_res ])

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
                      int,float,float array,unit" letter letter) ;
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
                int,float,float array,unit" letter letter) ;
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
                      int,float,float array,unit" letter letter) ;
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
                  int,float,float array,unit" letter letter) ;
        ]
  | _ -> failwith "bessel_quot: wrong args for quotation"





let process_line =
  let quotation = Str.regexp "<\\(:[a-z]*\\)?<\\(.*\\)>>$" in
  fun l ->
    if Str.string_match quotation l 0
    then begin
      let quot =
        try Str.matched_group 1 l
        with Not_found -> ":sf" in
      let data = Str.matched_group 2 l in
      match quot with
      | ":ext"    -> ext_quot    data
      | ":sf"     -> sf_quot     data
      | ":bessel" -> bessel_quot data
      | _         -> "(* quotation parse error *)"
    end
    else l



let iter_lines f ic =
  try
    while true do
      f (input_line ic)
    done
  with End_of_file -> ()

let _ =
  iter_lines
    (fun l ->
      let nl = process_line l in
      print_string nl ; print_char '\n')
    stdin
