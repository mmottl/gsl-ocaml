TARGETS = gsl.cma

.PHONY: all clean

all:
	@echo jbuilder: Entering directory \`$(abspath $(dir $(lastword $(PWD))))\'
	@jbuilder build --dev $(TARGETS)

clean:
	@jbuilder clean
