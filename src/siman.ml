(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2012 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)

let () = Error.init ()

type params = {
  iters_fixed_T : int;
  step_size : float;
  k : float;
  t_initial : float;
  mu_t : float;
  t_min : float;
}

open Misc

let solve rng conf0 ~energ_func ~step_func ?print_func params =
  let best_energ = ref (energ_func conf0) in
  let best_x = ref conf0 in
  let energ = ref !best_energ in
  let x = ref !best_x in

  let t = ref params.t_initial in
  let n_iter = ref 0 in
  let n_eval = ref 1 in

  if is print_func then
    print_string "#-iter  #-evals   temperature     position   energy\n";

  while !t >= params.t_min do
    for _i = 1 to params.iters_fixed_T do
      let new_x = step_func rng !x params.step_size in
      let new_energ = energ_func new_x in
      incr n_eval;
      if new_energ <= !best_energ then (
        best_energ := new_energ;
        best_x := new_x);

      if
        new_energ < !energ
        ||
        let lim = exp (~-.(new_energ -. !energ) /. (!t *. params.k)) in
        Rng.uniform rng < lim
      then (
        energ := new_energ;
        x := new_x)
    done;

    if is print_func then (
      Printf.printf "%5d   %7d  %12g" !n_iter !n_eval !t;
      may_apply print_func !x;
      Printf.printf "  %12g\n" !energ);

    t := !t /. params.mu_t;
    incr n_iter
  done;
  !best_x
