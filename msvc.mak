# -*- makefile -*-

GSLPREFIX := "../gsl"
GSLINCDIR := $(GSLPREFIX)
GSLCFLAGS := /I$(GSLINCDIR) 
GSLLIBS   := gsl.lib gslcblas.lib
GSLLIBDIR := $(GSLPREFIX)/GSLDLL/Release



CPPFLAGS = $(GSLCFLAGS) /I$(OCAMLDIR) /Dinline=__inline /D "WIN32" /D "NDEBUG"  /D "_MBCS" /D "GSL_DLL"  
CFLAGS   = /W3

O=obj
A=lib
D=dll
SO=s.obj
DO=d.obj
EXE=.exe
DEF=dllmlgsl.def 


# if Visual Studio 2005
# USE_MSVC_2005=yes

ifdef USE_MSVC_2005
MKDLL=link /nologo /dll /libpath:$(GSLLIBDIR) $(GSLLIBS) \
           /libpath:$(OCAMLDIR) ocamlrun.lib libbigarray.lib \
           /out:dll$(1).$(D) /implib:dll$(1).$(A) /def:$(3) $(2) \
      && MT /manifest $(1).manifest /outputresource:$(1);\#2
else
MKDLL=link /nologo /dll /libpath:$(GSLLIBDIR) $(GSLLIBS) \
	   /libpath:$(OCAMLDIR) ocamlrun.lib dllbigarray.lib \
	   /out:dll$(1).$(D) /implib:dll$(1).$(A) /def:$(3) $(2)
endif

MKLIB=lib /nologo /debugtype:CV /out:lib$(1).$(A) $(2)
MKCMA=$(OCAMLC) -a -o $(2).cma -cclib -l$(1) -dllib -l$(1) $(3)
MKCMXA=$(OCAMLOPT) -a -o $(2).cmxa -cclib -l$(1)  $(3)

SCFLAGS=/Fo$(1) /MT
DCFLAGS=/Fo$(1) /MD /D "CAML_DLL" 
