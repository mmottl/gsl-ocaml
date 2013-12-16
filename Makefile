# OASIS_START
# DO NOT EDIT (digest: 7b2408909643717852b95f994b273fee)

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

.PHONY: build doc test all install uninstall reinstall clean distclean configure

# OASIS_STOP

GSLINCDIR := $(shell gsl-config --prefix)/include

.PHONY: post-conf
post-conf:
	ocaml do_const.ml --mli > lib/const.mli
	ocaml do_const.ml > lib/const.ml
	ocaml do_sf.ml < lib/sf.mli.q > lib/sf.mli
	cp lib/sf.mli lib/sf.ml
	ocaml do_cdf.ml < $(GSLINCDIR)/gsl/gsl_cdf.h > lib/cdf.mli
	cp lib/cdf.mli lib/cdf.ml
	ocaml do_cdf.ml --c < $(GSLINCDIR)/gsl/gsl_cdf.h > lib/mlgsl_cdf.c
