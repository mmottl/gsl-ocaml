(lang dune 2.7)
(name gsl)

(generate_opam_files true)

(source (github mmottl/gsl-ocaml))
(license "GPL-3.0-or-later")
(homepage "https://mmottl.github.io/gsl-ocaml")
(documentation "https://mmottl.github.io/gsl-ocaml/api")

(maintainers "Markus Mottl <markus.mottl@gmail.com>")

(authors
  "Olivier Andrieu <oandrieu@gmail.com>"
  "Markus Mottl <markus.mottl@gmail.com>"
)

(package
  (name gsl)
  (synopsis "GSL - Bindings to the GNU Scientific Library")
  (description "\
gsl-ocaml interfaces the GSL (GNU Scientific Library), providing many of the
most frequently used functions for scientific computation including algorithms
for optimization, differential equations, statistics, random number generation,
linear algebra, etc.")
  (depends
    (ocaml (>= 4.12))
    dune-configurator
    (conf-gsl :build)
    (conf-pkg-config :build)
  )
)
