(lang dune 1.10)
(name gsl)

(generate_opam_files true)

(source (github mmottl/gsl-ocaml))
(license "GPL-3+")
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
    (ocaml (>= 4.08))
    (dune (>= 1.10))
    dune-configurator
    (conf-gsl :build)
    (conf-pkg-config :build)
    (base :build)
    (stdio :build)
  )
)
