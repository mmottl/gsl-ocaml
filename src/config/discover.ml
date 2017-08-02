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
      match C.Pkg_config.get c with
      | None ->
          Out_channel.(with_file "gsl_include.sexp" ~f:(fun oc ->
            output_string oc "/usr/include"));
          default
      | Some pc ->
          Option.value_map (C.Pkg_config.query pc ~package:"gsl") ~default
            ~f:(fun conf ->
              let has_include_flag =
                List.exists conf.cflags ~f:(fun cflag ->
                  let len = String.length cflag in
                  len >= 2 && Char.(cflag.[0] = '-' && cflag.[1] = 'I') &&
                  let gsl_include = String.sub cflag ~pos:2 ~len:(len - 2) in
                  write_sexp "gsl_include.sexp" (sexp_of_string gsl_include);
                  true)
              in
              if has_include_flag then conf
              else failwith "gsl-ocaml configurator: no include flag found")
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