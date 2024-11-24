open Gsl

type city = { name : string; lat : float; long : float }

let cities =
  Array.map
    (fun (n, la, lo) -> { name = n; lat = la; long = lo })
    [|
      ("Santa Fe", 35.68, 105.95);
      ("Phoenix", 33.54, 112.07);
      ("Albuquerque", 35.12, 106.62);
      ("Clovis", 34.41, 103.20);
      ("Durango", 37.29, 107.87);
      ("Dallas", 32.79, 96.77);
      ("Tesuque", 35.77, 105.92);
      ("Grants", 35.15, 107.84);
      ("Los Alamos", 35.89, 106.28);
      ("Las Cruces", 32.34, 106.76);
      ("Cortez", 37.35, 108.58);
      ("Gallup", 35.52, 108.74);
    |]

let city_distance { lat = la1; long = lo1 } { lat = la2; long = lo2 } =
  let earth_radius = 6375. in
  let pi_180 = Math.pi /. 180. in
  let sla1 = sin (la1 *. pi_180) in
  let cla1 = cos (la1 *. pi_180) in
  let slo1 = sin (lo1 *. pi_180) in
  let clo1 = cos (lo1 *. pi_180) in
  let sla2 = sin (la2 *. pi_180) in
  let cla2 = cos (la2 *. pi_180) in
  let slo2 = sin (lo2 *. pi_180) in
  let clo2 = cos (lo2 *. pi_180) in
  let dot_prod =
    (cla1 *. clo1 *. (cla2 *. clo2))
    +. (cla1 *. slo1 *. (cla2 *. slo2))
    +. (sla1 *. sla2)
  in
  earth_radius *. acos dot_prod

let prepare_distance_matrix cities =
  let nb = Array.length cities in
  let mat = Array.make_matrix nb nb 0. in
  for i = 0 to pred nb do
    for j = succ i to pred nb do
      let dist = city_distance cities.(i) cities.(j) in
      mat.(i).(j) <- dist;
      mat.(j).(i) <- dist
    done
  done;
  mat

let print_distance_matrix mat =
  let nb = Array.length mat in
  for i = 0 to pred nb do
    Printf.printf "# ";
    for j = 0 to pred nb do
      Printf.printf "%15.8f   " mat.(i).(j)
    done;
    print_newline ()
  done;
  flush stdout

let energ_func dist_mat route =
  let nb = Array.length route in
  let e = ref 0. in
  for i = 0 to pred nb do
    e := !e +. dist_mat.(route.(i)).(route.(succ i mod nb))
  done;
  !e

let step_func rng route _step_size =
  let nb = Array.length route in
  let x1 = Rng.uniform_int rng (pred nb) + 1 in
  let x2 = ref x1 in
  while !x2 = x1 do
    x2 := Rng.uniform_int rng (pred nb) + 1
  done;
  let route = Array.copy route in
  let swap = route.(x1) in
  route.(x1) <- route.(!x2);
  route.(!x2) <- swap;
  route

let print_func route =
  let nb = Array.length route in
  print_string "  [";
  for i = 0 to pred nb do
    Printf.printf " %d " route.(i)
  done;
  print_string "]\n"

let main () =
  let rng = Rng.make (Rng.default ()) in
  let nb = Array.length cities in

  let matrix = prepare_distance_matrix cities in
  let route_init = Array.init nb (fun i -> i) in

  Printf.printf "# initial order of cities:\n";
  for i = 0 to pred nb do
    Printf.printf "# \"%s\"\n" cities.(route_init.(i)).name
  done;
  Printf.printf "# distance matrix is:\n";
  print_distance_matrix matrix;
  Printf.printf "# initial coordinates of cities (longitude and latitude)\n";
  for i = 0 to pred nb do
    let c = route_init.(i) in
    Printf.printf "### initial_city_coord: %g %g \"%s\"\n" ~-.(cities.(c).long)
      cities.(c).lat cities.(c).name
  done;
  flush stdout;

  let siman_params =
    {
      Siman.iters_fixed_T = 2000;
      Siman.step_size = 1.;
      Siman.k = 1.;
      Siman.t_initial = 5000.;
      Siman.mu_t = 1.002;
      Siman.t_min = 5e-1;
    }
  in

  let final_route =
    Siman.solve rng route_init ~energ_func:(energ_func matrix) ~step_func
      (* ~print_func *)
      siman_params
  in

  Printf.printf "# final order of cities:\n";
  for i = 0 to pred nb do
    Printf.printf "# \"%s\"\n" cities.(final_route.(i)).name
  done;
  Printf.printf "# final coordinates of cities (longitude and latitude)\n";
  for i = 0 to pred nb do
    let c = final_route.(i) in
    Printf.printf "### final_city_coord: %g %g \"%s\"\n" ~-.(cities.(c).long)
      cities.(c).lat cities.(c).name
  done;
  flush stdout

let () =
  Rng.env_setup ();
  Ieee.env_setup ();
  main ()
