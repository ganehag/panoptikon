# Makefile to convert Markdown to PDF using Pandoc and Eisvogel template

# Variables
CHAPTERS := $(addprefix chapters/,$(shell cat chapters.txt))
METADATA := metadata/page.yaml
OUTPUT := manual.pdf
LANGUAGE := sv-SE
COLUMNS := 1
RESOURCEDIR := resources
SVG_SOURCES := $(shell find $(RESOURCEDIR) -name '*.svg')
PDF_RESOURCES := $(SVG_SOURCES:%.svg=%.pdf)

# Path to Eisvogel template, adjust as needed
EISVOGEL_PATH = template/eisvogel.latex

# Pandoc command
# -V multicol=$(COLUMNS) --toc

# Default rule
all: $(OUTPUT)

# Rule to build PDF
$(OUTPUT): $(CHAPTERS) $(METADATA) $(PDF_RESOURCES)
	pandoc $(CHAPTERS) --pdf-engine=xelatex --template $(EISVOGEL_PATH) --output content.tex --metadata-file=$(METADATA) -V lang=$(LANGUAGE) --top-level-division=chapter -V classoption=oneside
	xelatex -jobname=manual content.tex
	xelatex -jobname=manual content.tex

content.md: $(CHAPTERS) $(METADATA) $(PDF_RESOURCES)
	pandoc $(CHAPTERS) --pdf-engine=xelatex --template $(EISVOGEL_PATH) --output content.md --metadata-file=$(METADATA) -V lang=$(LANGUAGE) --top-level-division=chapter -V classoption=oneside

resources/%.pdf: resources/%.svg
	rsvg-convert -f pdf -o $@ $<

# Clean rule
clean:
	rm -f $(OUTPUT)

# Phony targets
.PHONY: all clean
