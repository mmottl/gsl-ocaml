# OASIS_START
# DO NOT EDIT (digest: a3c674b4239234cbbe53afe090018954)

SETUP = ocaml setup.ml

build: setup.data
	$(SETUP) -build $(BUILDFLAGS)

doc: setup.data build
	$(SETUP) -doc $(DOCFLAGS)

test: setup.data build
	$(SETUP) -test $(TESTFLAGS)

all:
	$(SETUP) -all $(ALLFLAGS)

install: setup.data
	$(SETUP) -install $(INSTALLFLAGS)

uninstall: setup.data
	$(SETUP) -uninstall $(UNINSTALLFLAGS)

reinstall: setup.data
	$(SETUP) -reinstall $(REINSTALLFLAGS)

clean:
	$(SETUP) -clean $(CLEANFLAGS)

distclean:
	$(SETUP) -distclean $(DISTCLEANFLAGS)

setup.data:
	$(SETUP) -configure $(CONFIGUREFLAGS)

configure:
	$(SETUP) -configure $(CONFIGUREFLAGS)

.PHONY: build doc test all install uninstall reinstall clean distclean configure

# OASIS_STOP

setup.ml: _oasis
	oasis setup -setup-update dynamic

GSLINCDIR := $(shell gsl-config --prefix)/include

.PHONY: post-conf
post-conf:
	ocaml do_const.ml --mli > lib/gsl_const.mli
	ocaml do_const.ml > lib/gsl_const.ml
	ocaml do_sf.ml < lib/gsl_sf.mli.q > lib/gsl_sf.mli
	cp lib/gsl_sf.mli lib/gsl_sf.ml
	ocaml do_cdf.ml < $(GSLINCDIR)/gsl/gsl_cdf.h > lib/gsl_cdf.mli
	cp lib/gsl_cdf.mli lib/gsl_cdf.ml
	ocaml do_cdf.ml --c < $(GSLINCDIR)/gsl/gsl_cdf.h > lib/mlgsl_cdf.c
