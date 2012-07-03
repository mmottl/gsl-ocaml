open Gsl

let f mu _t y f =
  let y0 = y.(0) and y1 = y.(1) in
  f.(0) <- y1 ;
  f.(1) <- -. y0 -. mu *. y1 *. (y0 *. y0 -. 1.)

let jac mu _t y dfdy dfdt =
  let y0 = y.(0) and y1 = y.(1) in
  dfdy.{0, 0} <- 0. ;
  dfdy.{0, 1} <- 1. ;
  dfdy.{1, 0} <- -. 2. *. mu *. y0 *. y1 -. 1. ;
  dfdy.{1, 1} <- -. mu *. (y0 *. y0 -. 1.) ;
  dfdt.(0) <- 0. ;
  dfdt.(1) <- 0.

let integ mu =
  let step    = Odeiv.make_step Odeiv.RK8PD ~dim:2 in
  let control = Odeiv.make_control_y_new ~eps_abs:1e-6 ~eps_rel:0. in
  let evolve  = Odeiv.make_evolve 2 in

  let system = Odeiv.make_system (f mu) ~jac:(jac mu) 2 in
  let (t, t1, h, y) = (0., 100., 1e-6, [| 1.; 0. |]) in
  
  let rec loop data t h =
    if t < t1 then begin
      let (t, h) = 
	Odeiv.evolve_apply evolve control step system
	  ~t ~t1 ~h ~y in
      loop ((t, y.(0), y.(1)) :: data) t h
    end 
    else List.rev data
  in
  loop [] t h



let integ2 mu = 
  let step    = Odeiv.make_step Odeiv.RK8PD ~dim:2 in
  let control = Odeiv.make_control_y_new ~eps_abs:1e-6 ~eps_rel:0. in
  let evolve  = Odeiv.make_evolve 2 in

  let system = Odeiv.make_system (f mu) ~jac:(jac mu) 2 in

  let t1 = 100. in
  let y = [| 1.; 0. |] in
  let state = ref (0., 1e-6) in
  let rec loop ti y = function
    | (t, h) when t < ti ->
	let new_state = 
	  Odeiv.evolve_apply evolve control step system
	    ~t ~t1:ti ~h ~y in
	loop ti y new_state
    | state -> state
  in
  let data = ref [] in
  for i=1 to 100 do
    let ti = float i *. t1 /. 100. in
    state := loop ti y !state ;
    let (t, _) = !state in
    data := (t, y.(0), y.(1)) :: !data
  done ;
  List.rev !data




let integ3 mu = 
  let step   = Odeiv.make_step Odeiv.RK4 ~dim:2 in
  let system = Odeiv.make_system (f mu) ~jac:(jac mu) 2 in

  let t1 = 100. in
  let t = ref 0. in
  let h = 1e-2 in
  let y = [| 1.; 0. |] in
  let yerr     = Array.make 2 0. in
  let dydt_in  = Array.make 2 0. in
  let dydt_out = Array.make 2 0. in
  let dfdy = Matrix.create 2 2 in

  let data = ref [] in
  jac mu t y dfdy dydt_in ;
  while !t < t1 do
    Odeiv.step_apply step ~t:!t ~h ~y ~yerr ~dydt_in ~dydt_out system ;
    Array.blit dydt_out 0 dydt_in 0 2 ;
    t := !t +. h ;
    data := (!t, y.(0), y.(1)) :: !data ;
  done ;
  List.rev !data




let with_temp_file f =
  let tmp = Filename.temp_file "gnuplot_" ".tmp" in
  let res = try f tmp with exn -> Sys.remove tmp ; raise exn in
  Sys.remove tmp ; res

let gnuplot script =
  with_temp_file
    (fun tmp ->
      let script_c = open_out tmp in
      List.iter
	(fun s -> Printf.fprintf script_c "%s\n" s)
	script ;
      close_out script_c ;
      match Unix.system
	(Printf.sprintf "gnuplot %s" tmp) with
      | Unix.WEXITED 0 -> ()
      | _ -> prerr_endline "hmm, problems with gnuplot ?" )



let main () = 
  Error.init () ;
  if Array.length Sys.argv < 2 then exit 1 ;
  let data = 
    match int_of_string Sys.argv.(1) with
    | 3 -> integ3 10.
    | 2 -> integ2 10.
    | _ -> integ 10.
  in
  let points = List.map 
      (fun (_, x, y) -> Printf.sprintf "%.5f %.5f" x y) data in
  gnuplot (List.concat
	     [ [ "plot '-' with lines" ] ; 
	       points ; 
	       [ "e" ; "pause -1" ] ])
    

let _ = 
  main ()
