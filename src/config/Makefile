TARGETS = discover.bc do_cdf.bc do_const.bc
JBUILDER_ROOT = ../..

.PHONY: all clean

all:
	@echo jbuilder: Entering directory \`$(realpath $(PWD)/$(JBUILDER_ROOT))\'
	@jbuilder build --dev $(TARGETS)

clean:
	@jbuilder clean
