CC=gplc
CFLAGS=

SOURCES=$(wildcard ./src/*.pl)
EXECUTABLE=./bin/submerged

.PHONY: all bin clean


all: bin

bin: $(EXECUTABLE)

$(EXECUTABLE):
	$(CC) $(SOURCES) $(CFLAGS) -o $@

clean:
	-rm $(EXECUTABLE)
