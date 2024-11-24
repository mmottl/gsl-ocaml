open Gsl

let _ =
  Error.init ();
  Rng.env_setup ()

let rng = Rng.make (Rng.default ())

let _ =
  Printf.printf "# generator type: %s\n" (Rng.name rng);
  Printf.printf "# seed = %nu\n" (Rng.default_seed ());
  Printf.printf "# min value   = %nu\n" (Rng.min rng);
  Printf.printf "# max value   = %nu\n" (Rng.max rng);
  Printf.printf "# first value = %nu\n" (Rng.get rng)

let sigma = 3.

let _ =
  Printf.printf "# gaussian with sigma=%g\n" sigma;
  for _i = 1 to 10 do
    let x = Randist.gaussian rng ~sigma in
    Printf.printf "%+.7f\n" x
  done

(* Local Variables: *)
(* compile-command: "ocamlopt -o rng -I .. gsl.cmxa rng.ml" *)
(* End: *)
