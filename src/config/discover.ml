open Base
open Stdio

module Sys = Caml.Sys

let write_sexp file sexp =
  Out_channel.write_all file ~data:(Sexp.to_string sexp)

let () =
  let module C = Configurator in
  C.main ~name:"gsl" (fun c ->
    let conf =
      let default : C.Pkg_config.package_conf = {
        libs = ["-lgsl"; "-lgslcblas"; "-lm"];
        cflags = []
      } in
      let write_gsl_include gsl_include =
        write_sexp "gsl_include.sexp" (sexp_of_string gsl_include)
      in
      let default_gsl_include = "/usr/include" in
      match C.Pkg_config.get c with
      | None -> write_gsl_include default_gsl_include; default
      | Some pc ->
          Option.value_map (C.Pkg_config.query pc ~package:"gsl") ~default
            ~f:(fun conf ->
              let gsl_include =
                try
                  List.find_map_exn conf.cflags ~f:(fun cflag ->
                    let len = String.length cflag in
                    if len >= 2 && Char.(cflag.[0] = '-' && cflag.[1] = 'I')
                    then Some (String.sub cflag ~pos:2 ~len:(len - 2))
                    else None)
                with Not_found -> default_gsl_include
              in
              write_gsl_include gsl_include;
              conf)
    in
    let conf =
      let without_cblas () =
        List.filter conf.libs ~f:(String.(<>) "-lgslcblas")
      in
      match Sys.getenv "GSL_CBLAS_LIB" with
      | alt_blas -> { conf with libs = alt_blas :: without_cblas () }
      | exception Not_found ->
          Option.value_map (C.ocaml_config_var c "system") ~default:conf
            ~f:(function
              | "macosx" ->
                  let libs = "-framework" :: "Accelerate" :: without_cblas () in
                  { conf with libs }
              | _ -> conf)
    in
    write_sexp "c_flags.sexp" (sexp_of_list sexp_of_string conf.cflags);
    write_sexp "c_library_flags.sexp" (sexp_of_list sexp_of_string conf.libs))
