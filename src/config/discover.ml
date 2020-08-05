module Option = struct
  include Option

  let value_map ~default ~f = function
    | Some x -> f x
    | None -> default
end  (* Option *)

module List = struct
  include List

  let find_map t ~f =
    let rec loop = function
      | [] -> None
      | x :: l ->
          match f x with
          | None -> loop l
          | Some _ as r -> r
    in
    loop t
end  (* List *)

let () =
  let module C = Configurator.V1 in
  let open C.Pkg_config in
  C.main ~name:"gsl" (fun c ->
    let conf =
      let default = {
        libs = ["-lgsl"; "-lgslcblas"; "-lm"];
        cflags = []
      } in
      let write_gsl_include = C.Flags.write_lines "gsl_include.sexp" in
      let default_gsl_include = ["/usr/include"] in
      match C.Pkg_config.get c with
      | None -> write_gsl_include default_gsl_include; default
      | Some pc ->
          Option.value_map ~default (C.Pkg_config.query pc ~package:"gsl")
            ~f:(fun conf ->
              let gsl_include =
                Option.value ~default:default_gsl_include @@
                List.find_map conf.cflags ~f:(fun cflag ->
                  let len = String.length cflag in
                  if len >= 2 && cflag.[0] = '-' && cflag.[1] = 'I'
                  then Some [String.sub cflag 2 (len - 2)]
                  else None)
              in
              write_gsl_include gsl_include;
              conf)
    in
    let conf =
      let without_cblas () =
        List.filter (fun x -> not (String.equal x "-lgslcblas")) conf.libs
      in
      match Sys.getenv_opt "GSL_CBLAS_LIB" with
      | Some alt_blas -> { conf with libs = alt_blas :: without_cblas () }
      | None ->
          Option.value_map ~default:conf (C.ocaml_config_var c "system")
            ~f:(function
              | "macosx" ->
                  let libs = "-framework" :: "Accelerate" :: without_cblas () in
                  { conf with libs }
              | _ -> conf)
    in
    C.Flags.write_sexp "c_flags.sexp" conf.cflags;
    C.Flags.write_sexp "c_library_flags.sexp" conf.libs)
