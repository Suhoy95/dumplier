SHELL := /bin/bash

TITLE := 2k19. Yet Another Cold-Boot Attack
SUBJECT := CCF
NUMBER := X
TARGET_FILENAME := I_Sukhoplyuev-$(SUBJECT)-$(shell sed -e 's/\s/-/g' <<< "${TITLE}")
TARGET := $(TARGET_FILENAME).pdf

all: $(TARGET)

%.pdf: README.md
	# More quotes! Welcome to shell-family
	./scripts/preamble.sh "$(TITLE)" "$(SUBJECT)" "$(NUMBER)" | cat - $< | pandoc -o "$@" --latex-engine xelatex

export: all $(wildcard *)
	# Welcome to shell-family
	zip --recurse-paths "$(TARGET_FILENAME).zip" "$(TARGET)" $(addprefix ",$(addsuffix ",$(wildcard *)))

clean:
	git clean -xnfd
	read -p "Are you sure?"
	git clean -xfd
