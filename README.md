GSL-OCaml - GSL-Bindings for OCaml
==================================

This library was written by [Olivier Andrieu](http://oandrieu.nerim.net/ocaml).
This version (gsl-ocaml) contains patches by [Markus
Mottl](http://www.ocaml.info) that may be merged into the original distribution
in the future.

GSL-OCaml is an interface to the [GSL](http://www.gnu.org/software/gsl)
(GNU scientific library) for the [OCaml](http://www.ocaml.org)-language.

Requirements
------------

The platform must not align doubles on double-word addresses, i.e. the C-macro
`ARCH_ALIGN_DOUBLE` must be undefined in the OCaml C-configuration header in
`<caml/config.h>`.

Installation
------------

```sh
$ ./configure
$ make
$ make install
```

### Configuring alternative BLAS-libraries

The underlying GSL-library depends on a C-implementation of the BLAS-library
(Basic Linear Algebra Subroutines).  It comes with its own implementation,
`gslcblas`, which GSL will link with by default, e.g.:

```sh
$ gsl-config --libs
-L/opt/local/lib -lgsl -lgslcblas
```

This implementation is usually considerably slower than alternatives like
[OpenBLAS](http://www.openblas.net) or [ATLAS (Automatically Tuned Linear
Algebra Software)](http://math-atlas.sourceforge.net) or miscellaneous
platform-specific vendor implementations.

If you want GSL-OCaml to link with another BLAS-implementation by
default, you will need to set an environment variable before starting
the build process.  For example, if you are installing the package via
[OPAM](http://opam.ocamlpro.com), you may want to do the following:

```sh
$ export GSL_CBLAS_LIB=-lopenblas
$ gsl-config --libs
-L/opt/local/lib -lgsl -lopenblas
$ opam install gsl-ocaml
```

The above shows that after setting the environment variable `GSL_CBLAS_LIB`,
`gsl-config` will return the correct linking flags to the build process
of GSL-OCaml.

Note that on Mac OS X GSL-OCaml requires the Apple-specific, highly optimized
vendor library `vecLib`, which is part of the Accelerate-framework, and will
automatically link with it.

Documentation
-------------

Check the [GSL manual](http://www.gnu.org/software/gsl/manual/html_node)
to learn more about the GNU Scientific Library.

You can browse the OCaml module interfaces as `ocamldoc`-generated HTML files
in directory `API.docdir` after building the documentation with `make doc`.
It is also available [online](http://mmottl.github.io/gsl-ocaml/api).

Usage Hints
-----------

### Vectors and Matrices

There are several data types for handling vectors and matrices.

  * Modules `Gsl.Vector`, `Gsl.Vector.Single`, `Gsl.Vector_complex`,
    `Gsl.Vector_complex.Single`, and the corresponding matrix modules use
    bigarrays with single or double precision and real or complex values.

  * Modules `Gsl.Vector_flat`, `Gsl.Vector_complex_flat`, and the corresponding
    matrix modules use a record wrapping a regular OCaml float array.  This is
    the equivalent of the `gsl_vector` and `gsl_matrix` structs in GSL.

  * Module `Gsl.Vectmat` defines a sum type with polymorphic variants
    that regroups these two representations.  For instance:

    ```ocaml
    Gsl.Vectmat.v_add (`V v1) (`VF v2)
    ```

    adds a vector in an OCaml array to a bigarray.

  * Modules `Gsl.Blas Gsl.Blas_flat` and `Gsl.Blas_gen` provide a (quite
    incomplete) interface to CBLAS for these types.

### ERROR HANDLING

Errors in GSL functions are reported as exceptions:

```ocaml
Gsl.Error.Gsl_exn (errno, msg)
```

You have to call `Gsl.Error.init ()` to initialize error reporting.  Otherwise,
the default GSL error handler is used and aborts the program, leaving a core
dump (not so helpful with OCaml).

If a callback (for minimizers, solvers, etc.) raises an exception, `gsl-ocaml`
either returns `GSL_FAILURE` or `NaN` to GSL depending on the type of callback.
In either case the original OCaml exception is not propagated.  The GSL
function will either return normally (but probably with values containing
`NaN`s somewhere) or raise a `Gsl_exn` exception.
