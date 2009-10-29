# If you're compiling with cygwin, comment this out
DYNAMIC_LINKING = true

OCAMLC   := ocamlc
OCAMLOPT := ocamlopt
CAMLP4O  := camlp4o
OCAMLDOC := ocamldoc
OCAMLMKLIB := ocamlmklib
OCAMLFIND  := ocamlfind

OCAML    := ocaml
OCAMLDIR := "$(shell $(OCAMLC) -where)"
OCAMLDEP := ocamldep
OCPP     := ocpp

FORT := fort 
AWK  := gawk

MNOCYGWIN     ?= $(shell $(OCAMLC) -verbose foo.c 2>&1 | $(AWK) "NR==1 { print \$$3 }")	
ifeq ($(MNOCYGWIN),-mnocygwin)
OCAML_BACKEND := mingw
endif

OCAML_BACKEND ?= $(shell $(OCAMLC) -verbose foo.c 2>&1 | $(AWK) "NR==1 { print \$$2 }")
OCAML_VERSION ?= $(shell $(OCAMLC) -version)

OCAMLBCFLAGS := -g 
OCAMLNCFLAGS :=

INSTALLDIR := $(OCAMLDIR)/gsl
DESTDIR =

AUTO_SRC := gsl_const.ml gsl_const.mli \
            gsl_sf.ml gsl_sf.mli \
            gsl_cdf.ml gsl_cdf.mli mlgsl_cdf.c

SRC := wrappers.h gsl_misc.ml io.h \
       gsl_error.ml gsl_error.mli mlgsl_error.c \
       gsl_ieee.ml gsl_ieee.mli mlgsl_ieee.c \
       gsl_math.ml gsl_math.mli mlgsl_math.c \
       gsl_complex.ml gsl_complex.mli mlgsl_complex.c mlgsl_complex.h \
       gsl_vector.ml gsl_vector.mli gsl_vector_flat.ml gsl_vector_flat.mli \
       gsl_vector_complex.ml gsl_vector_complex.mli \
       gsl_vector_complex_flat.ml gsl_vector_complex_flat.mli \
       mlgsl_vector.h \
       mlgsl_vector_float.c mlgsl_vector_float.h \
       mlgsl_vector_double.c mlgsl_vector_double.h \
       mlgsl_vector_complex.h mlgsl_vector_complex_float.h \
       gsl_matrix.ml gsl_matrix.mli gsl_matrix_flat.ml gsl_matrix_flat.mli \
       gsl_matrix_complex.ml gsl_matrix_complex.mli \
       gsl_matrix_complex_flat.ml gsl_matrix_complex_flat.mli \
       mlgsl_matrix.h \
       mlgsl_matrix_float.c mlgsl_matrix_float.h \
       mlgsl_matrix_double.c mlgsl_matrix_double.h \
       mlgsl_matrix_complex.c mlgsl_matrix_complex.h \
       mlgsl_matrix_complex_float.c mlgsl_matrix_complex_float.h \
       gsl_vectmat.ml gsl_vectmat.mli \
       gsl_blas.ml gsl_blas_flat.ml gsl_blas_gen.ml \
       gsl_blas.mli gsl_blas_flat.mli gsl_blas_gen.mli \
       mlgsl_blas.h mlgsl_blas.c \
       mlgsl_blas_float.c mlgsl_blas_complex.c mlgsl_blas_complex_float.c \
       gsl_fun.ml gsl_fun.mli mlgsl_fun.c mlgsl_fun.h \
       gsl_permut.ml gsl_permut.mli mlgsl_permut.c mlgsl_permut.h \
       gsl_sort.ml gsl_sort.mli mlgsl_sort.c \
       gsl_linalg.ml gsl_linalg.mli mlgsl_linalg.c mlgsl_linalg_complex.c \
       gsl_eigen.ml gsl_eigen.mli mlgsl_eigen.c \
       gsl_poly.ml gsl_poly.mli mlgsl_poly.c \
       gsl_interp.ml gsl_interp.mli mlgsl_interp.c \
       gsl_rng.ml gsl_rng.mli mlgsl_rng.c mlgsl_rng.h \
       gsl_qrng.ml gsl_qrng.mli mlgsl_qrng.c \
       gsl_randist.ml gsl_randist.mli mlgsl_randist.c \
       gsl_integration.ml gsl_integration.mli mlgsl_integration.c \
       gsl_fit.ml gsl_fit.mli mlgsl_fit.c \
       gsl_multifit.ml gsl_multifit.mli \
       gsl_multifit_nlin.ml gsl_multifit_nlin.mli mlgsl_multifit.c \
       gsl_root.ml gsl_root.mli mlgsl_roots.c \
       gsl_multiroot.ml gsl_multiroot.mli mlgsl_multiroots.c \
       gsl_min.ml gsl_min.mli mlgsl_min.c \
       gsl_multimin.ml gsl_multimin.mli mlgsl_multimin.c \
       gsl_diff.ml gsl_diff.mli mlgsl_diff.c \
       gsl_cheb.ml gsl_cheb.mli mlgsl_cheb.c \
       gsl_sum.ml gsl_sum.mli mlgsl_sum.c \
       gsl_fft.ml gsl_fft.mli mlgsl_fft.c \
       gsl_monte.ml gsl_monte.mli mlgsl_monte.c \
       gsl_siman.ml gsl_siman.mli \
       gsl_odeiv.ml gsl_odeiv.mli mlgsl_odeiv.c \
       gsl_histo.ml gsl_histo.mli mlgsl_histo.c \
       gsl_stats.ml gsl_stats.mli mlgsl_stats.c \
       gsl_wavelet.ml gsl_wavelet.mli mlgsl_wavelet.c \
       gsl_bspline.ml gsl_bspline.mli mlgsl_bspline.c \
       mlgsl_sf.c \
       $(AUTO_SRC)

ifeq ($(OCAML_BACKEND),cl)
include msvc.mak
else
ifeq ($(OCAML_BACKEND:gcc%=gcc),gcc)
include gcc.mak
else
include mingw.mak
endif
endif

CMI      := $(patsubst %.mli,%.cmi,$(filter %.mli,$(SRC)))
MLOBJ    := $(patsubst %.ml,%.cmo,$(filter %.ml,$(SRC)))
MLOPTOBJ := $(MLOBJ:%.cmo=%.cmx)
COBJ     := $(patsubst %.c,%.$(O),$(filter %.c,$(SRC)))
SOBJ     := $(patsubst %.c,%.$(SO),$(filter %.c,$(SRC)))
DOBJ     := $(patsubst %.c,%.$(DO),$(filter %.c,$(SRC)))

TRASH = ocamlgsl$(EXE) $(DEF) $(AUTO_SRC) do_cdf do_sf

DISTSRC := $(filter-out $(AUTO_SRC),$(SRC)) gsl_sf.mli.q \
           mlgsl_vector.c mlgsl_matrix.c \
           .depend .depend_c gcc.mak msvc.mak \
           Makefile .ocamlinit do_const.awk do_cdf.ml do_sf.ml \
           NOTES README.txt NEWS COPYING META ocamlgsl.spec \
           $(wildcard examples/*.ml) examples/Makefile doc \
           $(wildcard test/*.ml) $(wildcard ocamlgsl.info*)
VERSION := 0.6.0

all : stubs gsl.cma gsl.cmxa $(CMI)

STUBS = libmlgsl.$(A)
ifdef DYNAMIC_LINKING
STUBS += dllmlgsl.$(D)
endif
stubs : $(STUBS)

libmlgsl.$(A) : $(SOBJ)
	$(call MKLIB,mlgsl,$^)

# The Windows DLL 'exports' file (exports all non-static objects called ml_gsl*, removing underscores).
$(DEF) : $(DOBJ)
	nm -P $^ | $(AWK) "BEGIN { print \"EXPORTS\" }  \
		/_ml_gsl/{if (\$$2 == \"T\") print(substr(\$$1,2,length(\$$1)))}" > $@

dllmlgsl.$(D) : $(DEF) $(DOBJ)
	$(call MKDLL,mlgsl,$(DOBJ),$(DEF))

gsl.cma : $(MLOBJ)
	$(call MKCMA,mlgsl,gsl,$^)

gsl.cmxa : $(MLOPTOBJ)
	$(call MKCMXA,mlgsl,gsl,$^)

top : libmlgsl.$(A) gsl.cma
	ocamlmktop -I . -o ocamlgsl$(EXE) bigarray.cma gsl.cma

install : all
	$(OCAMLFIND) install gsl META \
          libmlgsl.$(A) dllmlgsl.$(D) gsl.cma gsl.cmxa gsl.$(A) $(CMI) $(MLOPTOBJ) 

ocamlgsl.odoc : $(MLOBJ) $(CMI)
	$(OCAMLDOC) -v -dump $@ $(filter-out gsl_misc.%, $(filter %.mli, $(SRC)))

doc : doc/index.html
doc/index.html: ocamlgsl.odoc
	mkdir -p doc
	$(OCAMLDOC) -v -html -t 'ocamlgsl $(VERSION)' -d doc -load $<

info : ocamlgsl.info
ocamlgsl.info : ocamlgsl.odoc
	$(OCAMLDOC) -v -texi -t 'ocamlgsl $(VERSION)' -o ocamlgsl.texi -load $<
	makeinfo ocamlgsl.texi

test : gsl.cma dllmlgsl.$(D)
	$(FORT) -I . test/*.test.ml

do_sf : do_sf.ml
	$(OCAMLC) -o $@ str.cma $^
gsl_sf.ml : gsl_sf.mli.q do_sf
	./do_sf < $< > $@
gsl_sf.mli : gsl_sf.mli.q do_sf
	./do_sf < $< > $@
gsl_sf.cmo gsl_sf.cmx : gsl_sf.cmi
gsl_sf.cmi : gsl_fun.cmi


gsl_const.ml : 
	$(AWK) -f do_const.awk > $@ \
          $(GSLINCDIR)/gsl/gsl_const_cgsm.h \
          $(GSLINCDIR)/gsl/gsl_const_mksa.h \
          $(GSLINCDIR)/gsl/gsl_const_num.h
gsl_const.mli :
	$(AWK) -f do_const.awk --mli > $@ \
          $(GSLINCDIR)/gsl/gsl_const_cgsm.h \
          $(GSLINCDIR)/gsl/gsl_const_mksa.h \
          $(GSLINCDIR)/gsl/gsl_const_num.h
gsl_const.cmo gsl_const.cmx : gsl_const.cmi


do_cdf : do_cdf.ml
	$(OCAMLC) -o $@ str.cma $^
gsl_cdf.ml : do_cdf $(GSLINCDIR)/gsl/gsl_cdf.h
	./do_cdf < $(GSLINCDIR)/gsl/gsl_cdf.h > $@
gsl_cdf.mli : do_cdf $(GSLINCDIR)/gsl/gsl_cdf.h
	./do_cdf < $(GSLINCDIR)/gsl/gsl_cdf.h > $@
mlgsl_cdf.c : do_cdf $(GSLINCDIR)/gsl/gsl_cdf.h
	./do_cdf --c < $(GSLINCDIR)/gsl/gsl_cdf.h > $@
gsl_cdf.cmo gsl_cdf.cmx :  gsl_cdf.cmi


%.cmo : %.ml	
	$(OCAMLC) $(OCAMLBCFLAGS) -c $<

%.cmx : %.ml
	$(OCAMLOPT) $(OCAMLNCFLAGS) -c $<

%.cmi : %.mli
	$(OCAMLC) $<

%.$(O) : %.c
	$(OCAMLC) -ccopt '$(CPPFLAGS) $(CFLAGS)' -c $<

%.$(SO) : %.c
	$(OCAMLC) -ccopt '$(CPPFLAGS) $(CFLAGS) $(call SCFLAGS,$@)' -c $<

%.$(DO) : %.c
	$(OCAMLC) -ccopt '$(CPPFLAGS) $(CFLAGS) $(call DCFLAGS,$@)' -c $<


.depend : $(filter-out $(AUTO_SRC) %.c,$(SRC))
	@echo "making ocaml deps..."
	-@$(OCAMLDEP) $^ > $@

.depend_c : $(filter-out $(AUTO_SRC), $(filter %.c,$(SRC)))
ifneq ($(OCAML_BACKEND),cl)
	@echo "making C deps..."
	-@$(CC) -isystem $(OCAMLDIR) -isystem $(GSLINCDIR) -MM $^ > $@
endif 

.PHONY : clean realclean top all dist install doc test stubs

dist : doc info
	export DIRNAME=$${PWD##*/} && \
	cd .. && mv $$DIRNAME ocamlgsl-$(VERSION) && \
	tar zcvf ocamlgsl-$(VERSION).tar.gz $(addprefix ocamlgsl-$(VERSION)/,$(DISTSRC)) && mv ocamlgsl-$(VERSION) $$DIRNAME

clean :
	rm -f *.cm* *.$(SO) *.$(DO)  *.$(D) *.$(A) core* $(TRASH)

realclean :
	rm -f .depend* ocamlgsl.info* ocamlgsl.texi ocamlgsl.odoc

-include .depend
-include .depend_c
