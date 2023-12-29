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
PANDOC_CMD = pandoc $(CHAPTERS) --toc --pdf-engine=xelatex --template $(EISVOGEL_PATH) --output $(OUTPUT) --metadata-file=$(METADATA) -V lang=$(LANGUAGE)
# -V multicol=$(COLUMNS) --toc

# Default rule
all: $(OUTPUT)

# Rule to build PDF
$(OUTPUT): $(CHAPTERS) $(METADATA) $(PDF_RESOURCES)
	$(PANDOC_CMD)

resources/%.pdf: resources/%.svg
	rsvg-convert -f pdf -o $@ $<

# Clean rule
clean:
	rm -f $(OUTPUT)

# Phony targets
.PHONY: all clean
