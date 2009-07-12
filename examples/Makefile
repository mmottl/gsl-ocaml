
OCAMLC   := ocamlc.opt
OCAMLOPT := ocamlopt.opt
CAMLP4O  := camlp4o.opt

OCAMLBCFLAGS := -g
OCAMLNCFLAGS := -unsafe

SRC := cheb.ml diff.ml fit.ml integration.ml interp.ml min.ml monte.ml \
       multifit-data.ml multifit.ml permut.ml qrng.ml rng.ml root.ml \
       linalg.ml blas.ml multiroot.ml multimin.ml sum.ml multifit_nlin.ml \
       eigen.ml siman.ml siman_tsp.ml odeiv.ml stats.ml const.ml histo.ml \
       wavelet.ml bspline.ml

PROGS     := $(patsubst %.ml,%.test,$(SRC))
PROGS_OPT := $(patsubst %.ml,%.test.opt,$(SRC))

LIBS    = bigarray.cma gsl.cma
LIBSOPT = $(LIBS:%.cma=%.cmxa)

MLGSLDIR = ..

all : $(PROGS) $(PROGS_OPT)

multifit.test multifit.test.opt : PP=-pp "$(CAMLP4O)"

interp.test interp.test.opt : LIBS += unix.cma
odeiv.test odeiv.test.opt : LIBS += unix.cma

%.test : %.ml $(MLGSLDIR)/gsl.cma $(MLGSLDIR)/libmlgsl.a
	$(OCAMLC) $(PP) $(OCAMLBCFLAGS) -o $@ -I $(MLGSLDIR) -dllpath $(MLGSLDIR) $(LIBS) $<

%.test.opt : %.ml $(MLGSLDIR)/gsl.cmxa $(MLGSLDIR)/libmlgsl.a
	$(OCAMLOPT) $(PP) $(OCAMLNCFLAGS) -o $@ -I $(MLGSLDIR) $(LIBSOPT) $<

.PHONY : clean all 

clean :
	rm -f *.cm* *.[ao] *.so core *.test *.test.opt $(TRASH)

