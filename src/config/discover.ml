open Base
open Stdio

module Sys = Caml.Sys

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
              ignore (
                Caml.Sys.command "\
                  pkg-config --cflags-only-I gsl | \
                  cut -b 3- > gsl_include.sexp");
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
    let write_sexp file sexp =
      Out_channel.write_all file ~data:(Sexp.to_string sexp)
    in
    write_sexp "c_flags.sexp" (sexp_of_list sexp_of_string conf.cflags);
    write_sexp "c_library_flags.sexp" (sexp_of_list sexp_of_string conf.libs))
