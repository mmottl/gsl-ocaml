EXAMPLES = $(wildcard *.ml)
TARGETS = $(patsubst %.ml, %.bc, $(EXAMPLES))

.PHONY: all clean

all:
	@echo jbuilder: Entering directory \`$(abspath $(dir $(lastword $(PWD))))\'
	@jbuilder build --dev $(TARGETS)

clean:
	@jbuilder clean
