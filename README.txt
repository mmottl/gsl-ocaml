
This is an interface to GSL (GNU scientific library), for the
Objective Caml langage. 


* REQUIREMENTS
- gsl >= 1.9
- ocaml >= 3.07
- awk and GNU make
- gcc or MSVC

The platform must not need to align doubles on double-word addresses,
i.e. ARCH_ALIGN_DOUBLE must be undefined in <caml/config.h>


* BUILDING & INSTALLING
- have a look at the variables in Makefile and gcc.mak/msvc.mak.
  comment out DYNAMIC_LINKING if it isn't supported on your platform.
- make
- (optional) make install

to link :
  ocamlopt -I gsldir bigarray.cmxa gsl.cmxa my_prog.ml
or :
  ocamlc -I gsldir -dllpath gsldir bigarray.cma gsl.cma my_prog.ml


* CHANGES
cf. the NEWS file to see what's changed between gsl-ocaml versions.

WARNING : the code is not heavily tested !


* DOCUMENTATION
Check the GSL manual ! You can browse the module interfaces with the
ocamldoc-generated HTML files in the doc/ directory.


* VECTOR / MATRICES
There are several datatypes for handling vectors and matrices.

 - modules Gsl_vector, Gsl_vector.Single, Gsl_vector_complex,
   Gsl_vector_complex.Single and the corresponding matrix modules use
   bigarrays with single or double precisions real or complex values.

 - modules Gsl_vector_flat, Gsl_vector_complex_flat and the
   corresponding matrix modules use a record wrapping a regular caml
   float array. This is the equivalent of the gsl_vector and
   gsl_matrix structs in GSL.

 - module Gsl_vectmat defines a sum type with polymorphic variants
   that regroups these two representations. For instance :

     Gsl_vectmat.v_add (`V v1) (`VF v2)

   adds a vector in a caml array to a bigarray.

  - modules Gsl_blas Gsl_blas_flat and Gsl_blas_gen provide a (quite
    incomplete) interface to CBLAS for these types.

* ERROR HANDLING
Errors in GSL functions are reported as exceptions :
  Gsl_error.Gsl_exn (errno, msg)
You have to call Gsl_error.init () so as to initialize error
reporting; otherwise, the default GSL error handler is used and aborts
the program, leaving a core dump (not so helpful with caml).

If a callback (for minimizers, solvers, etc.) raises an exception,
gsl-ocaml either returns GSL_FAILURE or NaN to GSL, depending on the
type of callback. In either case the original caml exception is not
propagated. The GSL function will either return normally (but probably
with values containing NaNs somewhere) or raise a Gsl_exn exception.
