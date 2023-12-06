### 1.25.0 (2023-12-05)

  * Make the GSL bindings compatible with OCaml 5.0.

    Thanks to Florian Angeletti <florian.angeletti@inria.fr> for this
    large patch!

  * Added `Randist.multinomial_inplace`

    Thanks to Martynas Sinkievic <tasmartynas@gmail.com> for this contribution!

### 1.24.3 (2020-08-04)

  * Removed `base` and `stdio` build dependencies.


### 1.24.2 (2020-07-30)

  * Switched to OPAM file generation via `dune-project`

  * Added support for const char strings in stubs due to stricter handling
    in newer OCaml runtimes.  This eliminates C-compiler warnings.


### 1.24.1 (2019-10-11)

  * Fixed warnings in C-stubs


### 1.24.0 (2018-10-24)

  * Updated to OPAM 2.0


### 1.23.0 (2018-10-06)

  * Switched to dune and dune-release


### 1.22.0 (2018-06-11)

  * Fixed warnings and errors in configuration code due to upstream changes.


### 1.21.0 (2017-12-06)

  * Added `Randist.multivariate_gaussian`.

    Thanks to Ilias Garnier for this contribution!

  * Added hypergeometric functions.

    Thanks to Christophe Troestler for this contribution!

  * Fixed error handler initialization.


### 1.20.2 (2017-10-15)

  * Fixed a configuration bug leading to wrong include paths


### 1.20.1 (2017-10-10)

  * Fixed automatic generation of special functions

  * Improved documentation of configuration options

  * Improved automatic configuration of include paths


### 1.20.0 (2017-08-01)

  * Switched to jbuilder and topkg
