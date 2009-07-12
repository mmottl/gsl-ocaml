#load "bigarray.cma"
#load "gsl.cma"

(** The common signature of vector modules *)
module type VECTOR = sig
  type vector
  val create   : ?init:float -> int -> vector
  val of_array : float array -> vector
  val to_array : vector -> float array
  val length : vector -> int
  val get : vector -> int -> float
  val set : vector -> int -> float -> unit
  val set_all   : vector -> float -> unit
  val set_zero  : vector -> unit
  val set_basis : vector -> int -> unit
  val memcpy : src:vector -> dst:vector -> unit
  val copy   : vector -> vector
  val swap_element : vector -> int -> int -> unit
  val reverse : vector -> unit
  val add : vector -> vector -> unit 
  val sub : vector -> vector -> unit 
  val mul : vector -> vector -> unit 
  val div : vector -> vector -> unit 
  val scale : vector -> float -> unit 
  val add_constant : vector -> float -> unit
  val max : vector -> float
  val min : vector -> float
  val minmax : vector -> float * float
  val max_index : vector -> int
  val min_index : vector -> int
  val minmax_index : vector -> int * int
  end
;;


module Test = functor (M : VECTOR) ->
  struct
  let test () =
    Fort.expect_pass "base ops"
      (fun () ->
	let len = 10 in
	let vec = M.create len in
	let v1, v2 = (1., 2.) in
	Fort.expect_equal ~msg:"length" len (M.length vec) ;
	Fort.expect_equal ~msg:"array conversion"
	  vec (M.of_array (M.to_array vec)) ;
	Fort.expect_equal ~msg:"set/get"
	  v2 (M.set vec 0 v2 ; M.get vec 0) ;
	Fort.expect_equal ~msg:"init"
	  v1 (M.get (M.create ~init:v1 len) 0) ;

	Fort.expect_equal ~msg:"set_all"
	  v1 (M.set_all vec v1 ; M.get vec 1) ;
	Fort.expect_equal ~msg:"set_zero"
	  0. (M.set_zero vec ; M.get vec 1) ;
	Fort.expect_equal ~msg:"set_basis"
	  (0., 1.) (M.set_basis vec 1; (M.get vec 0, M.get vec 1)) ;

	let vec' = M.copy vec in
	Fort.expect_equal ~msg:"copy" vec' vec ;
	for i=0 to pred len do
	  M.set vec i (float i)
	done ;
	Fort.expect_equal ~msg:"memcpy" 
	  vec (M.memcpy vec vec'; vec') ;

	let vec1 = M.of_array [| 1.; 2.; 3.; |] in
	let vec2 = M.of_array [| 2.; 1.; 3.; |] in
	let vec3 = M.of_array [| 3.; 1.; 2.; |] in
	Fort.expect_equal ~msg:"swap_element" 
	  vec2 (M.swap_element vec1 0 1; vec1) ;
	Fort.expect_equal ~msg:"reverse1" 
	  vec3 (M.reverse vec1; vec1) ;
	
	let vec1 = M.of_array [| 1.; 2.; 3.; 4.; |] in
	let vec2 = M.of_array [| 4.; 3.; 2.; 1.; |] in
	Fort.expect_equal ~msg:"reverse2" 
	  vec2 (M.reverse vec1; vec1) ;
      ) ;

    Fort.expect_pass "arith ops"
      (fun () ->
	let v1 = M.of_array [| 1.; 2.; 3. |] in
	let v2 = M.of_array [| 4.; 5.; 6. |] in
	let v3 = M.of_array [| 5.; 7.; 9. |] in
	let v4 = M.of_array [| 3.; 3.; 3. |] in
	let v5 = M.of_array [| 4.; 10.; 18. |] in
	let v6 = M.of_array [| 0.5; 1.; 1.5 |] in

	Fort.expect_equal ~msg:"add"
	  v3 (let v = M.copy v1 in M.add v v2 ; v) ;
	Fort.expect_equal ~msg:"sub"
	  v4 (let v = M.copy v2 in M.sub v v1 ; v) ;
	Fort.expect_equal ~msg:"mul"
	  v5 (let v = M.copy v1 in M.mul v v2 ; v) ;
	Fort.expect_equal ~msg:"div"
	  v2 (let v = M.copy v5 in M.div v v1 ; v) ;
	Fort.expect_equal ~msg:"scale"
	  v6 (let v = M.copy v1 in M.scale v 0.5 ; v) ;
	Fort.expect_equal ~msg:"add_constant"
	  v2 (let v = M.copy v1 in M.add_constant v 3. ; v) ;
      ) ;

    Fort.expect_pass "index ops"
      (fun () ->
	let v = M.of_array [| 3.; 7.; 2.; 5.|] in
 	Fort.expect_equal ~msg:"min" 2. (M.min v) ;
 	Fort.expect_equal ~msg:"max" 7. (M.max v) ;
 	Fort.expect_equal ~msg:"minmax" (2., 7.) (M.minmax v) ;
 	Fort.expect_equal ~msg:"min_index" 2 (M.min_index v) ;
 	Fort.expect_equal ~msg:"max_index" 1 (M.max_index v) ;
 	Fort.expect_equal ~msg:"minmax_index" (2, 1) (M.minmax_index v) 
      )
  end
;;

module M = Test(Gsl_vector) ;;
M.test() ;;

module M = Test(Gsl_vector.Single);;
M.test() ;;

module M = Test(Gsl_vector_flat);;
M.test() ;;


(** Test subvector thing *)
module M = Gsl_vector;;
Fort.expect_pass "subvector bigarray"
    (fun () ->
      let len = 10 in
      let v = M.create ~init:0. len in
      for i=0 to pred len do v.{i} <- float i done ;
      let s = M.subvector v ~off:2 ~len:3 in
      Fort.expect_equal [| 2.; 3.; 4. |] (M.to_array s)
    )
;;
module M = Gsl_vector.Single;;
Fort.expect_pass "subvector bigarray single"
    (fun () ->
      let len = 10 in
      let v = M.create ~init:0. len in
      for i=0 to pred len do v.{i} <- float i done ;
      let s = M.subvector v ~off:2 ~len:3 in
      Fort.expect_equal [| 2.; 3.; 4. |] (M.to_array s)
    )
;;
module M = Gsl_vector_flat;;
Fort.expect_pass "subvector flat"
    (fun () ->
      let len = 10 in
      let a = Array.init len (fun i -> float i) in
      let v = M.of_array a in
      let s = M.subvector v ~off:2 ~len:3 in
      Fort.expect_equal ~msg:"no stride" 
	[| 2.; 3.; 4. |] (M.to_array s) ;
      let s2 = M.subvector ~stride:2 v ~off:1 ~len:3 in
      Fort.expect_equal ~msg:"with stride" 
	[| 1.; 3.; 5. |] (M.to_array s2) ;
      M.set s2 0 (-1.) ;
      Fort.expect_equal ~msg:"sharing" 
	(M.get s2 0) (M.get v s2.M.off)
    )
;;
Fort.expect_pass "view_array flat"
    (fun () ->
      let len = 10 in
      let a = Array.init len (fun i -> float i) in
      let v = M.view_array ~stride:2 ~off:3 ~len:2 a in
      Fort.expect_equal
	[| 3.; 5.; |] (M.to_array v) ;
      let k = v.M.off + v.M.stride in
      a.(k) <- -1. ;
      Fort.expect_equal ~msg:"sharing" 
	(M.get v 1) a.(k)
    )
;;
