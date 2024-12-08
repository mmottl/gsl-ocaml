## 1.25.1 (2024-11-25)

- Reformatted OCaml and Dune files with `ocamlformat`.

- Reformatted C files with `clang-format`.

- Reformatted and improved Markdown files.

- Added GitHub workflow.

- Improved comment references.

- Link the blas library after gsl.

  Thanks to Jerry James for this contribution.

- Fixed Dune/OPAM license specification.

## 1.24.3 (2020-08-04)

- Removed `base` and `stdio` build dependencies.

## 1.24.2 (2020-07-30)

- Switched to OPAM file generation via `dune-project`

- Added support for const char strings in stubs due to stricter handling
  in newer OCaml runtimes. This eliminates C-compiler warnings.

## 1.24.1 (2019-10-11)

- Fixed warnings in C-stubs

## 1.24.0 (2018-10-24)

- Updated to OPAM 2.0

## 1.23.0 (2018-10-06)

- Switched to dune and dune-release

## 1.22.0 (2018-06-11)

- Fixed warnings and errors in configuration code due to upstream changes.

## 1.21.0 (2017-12-06)

- Added `Randist.multivariate_gaussian`.

  Thanks to Ilias Garnier for this contribution.

- Added hypergeometric functions.

  Thanks to Christophe Troestler for this contribution.

- Fixed error handler initialization.

## 1.20.2 (2017-10-15)

- Fixed a configuration bug leading to wrong include paths

## 1.20.1 (2017-10-10)

- Fixed automatic generation of special functions

- Improved documentation of configuration options

- Improved automatic configuration of include paths

## 1.20.0 (2017-08-01)

- Switched to jbuilder and topkg

## Changes Before Version 1.20.0

```text
in 1.19.3  (gsl-ocaml fork)

  - Fixed build problem on platforms with GSL versions older than 2.0

in 1.19.2  (gsl-ocaml fork)

  - Link to Accelerate Framework on Mac OS X

in 1.19.1  (gsl-ocaml fork)

  - Fixed linking problem

in 1.19.0  (gsl-ocaml fork)

  - Fixed incompatibilities with GSL 2.0

in 1.18.5  (gsl-ocaml fork)

  - Fixed building of examples that depend on camlp4

    Thanks to Akinori Abe for the patch.

in 1.18.4  (gsl-ocaml fork)

  - Fixed configuration issue relating to OPAM packaging

in 1.18.3  (gsl-ocaml fork)

  - Removed superfluous camlp4 dependency from library.

in 1.18.2  (gsl-ocaml fork)

  - Better expected compatibility with OCaml versions larger than 4.02.1

in 1.18.1  (gsl-ocaml fork)

  - Improvements to distribution process

in 1.18.0  (gsl-ocaml fork)

  - Exploit the new module alias feature in OCaml 4.02 to improve compilation
    and linking speed as well as executable size.

in 1.17.2  (gsl-ocaml fork)

  - Added missing include to C-stubs

in 1.17.1  (gsl-ocaml fork)

  - API fixes for upcoming GSL 1.17 release. Affects
      - Multifit_nlin.{test_gradient,covar}
      - SF.ellint_D

    Thanks to Andrey Bergman for the initial patch!

in 1.15.3  (gsl-ocaml fork)

  - Fixed a bug in the bindings for lag1_autocorrelation that could cause
    segfaults (thanks to Hezekiah Carty for the bug report!)

in 1.15.2  (gsl-ocaml fork)

  - Fixed linking on Mac OS X Mavericks using the Accelerate-framework

in 1.15.0  (gsl-ocaml fork)

  - Fixed superfluous Jacobian allocation when not requested for ODE solving.

in 1.10.2  (gsl-ocaml fork)
  - Fixed linking problem

in 1.10.1  (gsl-ocaml fork)
  - Switched to Oasis
  - GSL is now a packed library. E.g. the module "Gsl_rng" is now "Gsl.Rng".
  - Fixed new OCaml 4.00 warnings
  - Added stricter C-compilation flags
  - Minor fixes

in 1.10.0
  - ocamlgsl version number now indicates the required major+minor GSL
    version
  - improved error support:
      GSL errors are now handled by an OCaml function. By default it raises
      the Gsl_exn exception, but you can redefine it to ignore some errors.
  - callbacks:
      now exceptions raised in OCaml callback functions propagate and are
      no longer "absorbed".
      Mind that for some functions (Gsl_monte.integrate_miser for one) this can
      result in a memory leak in GSL.
  - fixes for multimin (Markus)
  - fixes for exceptions on "all-float" functions
  - update the buildsystem (autoconf)
  - support for gsl_stats_correlation

in 0.6.1
  - Minor changes to improve installation and to fix stack overflows
    when dealing with large optimization problems.
    (Markus Mottl)

in 0.6.0
  - sync with GSL 1.9
    - Nonsymmetric eigensystems in Gsl_eigen
    - Basis splines
    - misc. other improvements, cf. GSL 1.9 NEWS file

in 0.5.3
  - compile with ocaml 3.10
  - fix GC bugs with C functions taking a callbak parameter (min, multimin,
    multifit, etc.)

in 0.5.2
  - fix Gsl_sf.legendre_array_size

in 0.5.1
  - fix wrong declaration of externals in gsl_wavelet (Will M. Farr)
  - rewrite the blurb about callbacks raising exceptions (see below)
  - drop the mode argument Gsl_cheb.eval ("not for casual use")
  - fix GC bug in Gsl_cheb

in 0.5.0
  - sync with GSL 1.8
    - fix Gsl_cdf
    - wrap new functions:
       gsl_multifit_linear_est, gsl_linalg_cholesky_decomp_unit,
       gsl_ran_gamma_mt, gsl_ran_gaussian_ziggurat,
       gsl_sf_debye_5, gsl_sf_debye_6
  - sync with GSL 1.7
    - add Gsl_randist.binomial_knuth, add Gsl_multifit._linear_svd

in 0.4.1
  - make record types 'private'. This disallows building bogus values
    that could crash the program.
  - remove unsafe manual memory-management functions from module signatures
  - added Associated Legendre Polynomials and Spherical Harmonics in
    Gsl_sf (Will M. Farr)
  - fixed the type Gsl_fft.Complex.direction (Joe Shirron)
  - fixed types of Gsl_randist.negative_binomial and negative_binomial_pdf
    (Martin Willensdorfer)

in 0.4.0
  - sync with GSL 1.6
    - new module Gsl_wavelet for DWT
    - new module Gsl_sort
    - in Gsl_linalg, support for LQ and P^T LQ decompositions
    - add a mode argument in Gsl_cheb.eval
    - add RK2SIMP in Gsl_odeiv.step_kind
    - a couple of other small additions
  - bugfix for functions in Gsl_sf returning a result_e10
  - better support for Cygwin (James Scott, Lexifi)

in 0.3.5
  - improve build system a bit so that it works better on cygwin
    (thanks to Brian Wilfley)
  - fix bugs in Gsl_odeiv (thanks to Will M. Farr)

in 0.3.4
  - fix a GC bug in the error handler, simplify exception raising code
  - add Qrng.dimension and Qrng.sample

in 0.3.3
  - report an error when building on a platform with ARCH_ALIGN_DOUBLE
    defined
  - findlib support

in 0.3.2
  - complex functions (contributed by Paul Pelzl)

in 0.3.1 :
  - bugfix in Gsl_interp.eval_array
  - mlgsl_ieee.c now compiles with gcc 2.9x
  - build system improvements

in 0.3.0 :
  - sync with GSL 1.4
    - new module Gsl_cdf for cumulative distributions
    - new function Gsl_randist.binomial_tpe
  - compiles with MSVC (contributed by Lexifi)
  - memory bugfix in adaptative integration routines
  - bugfix in Gsl_ieee.set_mode, added FPU status word querying
  - changed arguments order in Gsl_matrix.transpose :
      first arg is destination, second is source

in 0.2.2 :
  - sync with GSL 1.3
    - new multidimensional minimizer (Nelder Mead Simplex algorithm)
    - new random distributions : Dirichlet and multinomial
    - new function Gsl_math.fcmp for approximate floating point values
    comparisons
  - fixed some potential problems with the GC

in 0.2.1 :
  - Gsl_linalg.matmult is now Gsl_linalg.matmult
  - Gsl_matrix.mul is now Gsl_matrix.mul_elements (same for
  Gsl_matrix.div)
  - vector/matrix macros work with gcc 2.9x (old_gcc target
  in Makefile)

in 0.2 :
  - rewrote the vector/matrix modules to add single precision
  bigarrays and complex values
  - added complex functions in Gsl_linalg and Gsl_eigen
  - added Ordinary Differential Equations
  - added Simulated Annealing
  - added Statistics and Histograms

in 0.1.1 :
  - fixed install target in Makefile
  - fixed C stub function names
  - fixed a bug in ext_quot in quot.ml
```
