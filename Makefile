CC=gplc
CFLAGS=
LATEX=pdflatex

SOURCES=$(wildcard ./src/*.pl)
EXECUTABLE=./bin/submerged

.PHONY: all bin doc clean


all: bin doc

bin: $(EXECUTABLE)

$(EXECUTABLE):
	$(CC) $(SOURCES) $(CFLAGS) -o $@

doc:
	-$(LATEX) doc/report.tex -output-directory doc


clean:
	-rm $(EXECUTABLE)
