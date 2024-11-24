(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2012 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)

(** Error reporting *)

val version : string
(** Version of GSL library. *)

type errno =
  | CONTINUE  (** iteration has not converged *)
  | FAILURE
  | EDOM  (** input domain error, e.g sqrt(-1) *)
  | ERANGE  (** output range error, e.g. exp(1e100) *)
  | EFAULT  (** invalid pointer *)
  | EINVAL  (** invalid argument supplied by user *)
  | EFAILED  (** generic failure *)
  | EFACTOR  (** factorization failed *)
  | ESANITY  (** sanity check failed - shouldn't happen *)
  | ENOMEM  (** malloc failed *)
  | EBADFUNC  (** problem with user-supplied function *)
  | ERUNAWAY  (** iterative process is out of control *)
  | EMAXITER  (** exceeded max number of iterations *)
  | EZERODIV  (** tried to divide by zero *)
  | EBADTOL  (** user specified an invalid tolerance *)
  | ETOL  (** failed to reach the specified tolerance *)
  | EUNDRFLW  (** underflow *)
  | EOVRFLW  (** overflow *)
  | ELOSS  (** loss of accuracy *)
  | EROUND  (** failed because of roundoff error *)
  | EBADLEN  (** matrix, vector lengths are not conformant *)
  | ENOTSQR  (** matrix not square *)
  | ESING  (** apparent singularity detected *)
  | EDIVERGE  (** integral or series is divergent *)
  | EUNSUP  (** requested feature is not supported by the hardware *)
  | EUNIMPL  (** requested feature not (yet) implemented *)
  | ECACHE  (** cache limit exceeded *)
  | ETABLE  (** table limit exceeded *)
  | ENOPROG  (** iteration is not making progress towards solution *)
  | ENOPROGJ  (** jacobian evaluations are not improving the solution *)
  | ETOLF  (** cannot reach the specified tolerance in F *)
  | ETOLX  (** cannot reach the specified tolerance in X *)
  | ETOLG  (** cannot reach the specified tolerance in gradient *)
  | EOF  (** end of file *)

exception Gsl_exn of errno * string
(** [Error.Gsl_exn] is raised by GSL to indicate an error. The second argument
    gives the reason for the error. *)

val init : unit -> unit
(** [Error.init ()] sets up the GSL error handler so that the OCaml function
    {!Error.handler} gets called in case of an error. This behavior is the
    default now. *)

val uninit : unit -> unit
(** [Error.uninit ()] reverts the GSL error handler to the default of the GSL
    C-library. The default GSL error simply aborts the program. *)

val handler : (errno -> string -> unit) ref
(** The OCaml handler for GSL errors. Initially set to {!Error.default_handler}.
    If the function returns, the error is ignored and execution of the GSL
    function continues.

    Redefine it so as to ignore some particular errors ([EOVRFLW] or [EUNDRFLW]
    for instance). *)

val default_handler : errno -> string -> 'a
(** The default OCaml handler for GSL errors. It simply raises the
    {!Error.Gsl_exn} exception. *)

val strerror : errno -> string
(** [strerror e] returns a description of the error [e]. *)

val string_of_errno : errno -> string
(** [string_of_errno e] returns the name of [e]. *)

val printer : exn -> string option
(** [printer] is an exceoption printer for {!Exn}. It is registered by default
    with [Printexc]. *)
