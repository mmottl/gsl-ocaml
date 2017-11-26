EXAMPLES = $(wildcard *.ml)
TARGETS = $(patsubst %.ml, %.bc, $(EXAMPLES))

.PHONY: all clean

all:
	@jbuilder build --dev $(TARGETS)

clean:
	@jbuilder clean
