(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2005 - Olivier Andrieu                *)
(* Distributed under the terms of the LGPL version 2.1      *)


let maybe_or_else o def = 
  match o with
  | None -> def
  | Some v -> v

let may vo f = 
  match vo with
  | None -> ()
  | Some v -> f v

let may_apply fo v =
  match fo with
  | None -> ()
  | Some f -> f v

let is = function
  | None -> false
  | Some _ -> true
