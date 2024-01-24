# Makefile to convert Markdown to PDF using Pandoc and Eisvogel template

# Variables
CHAPTERS := $(addprefix chapters/,$(shell cat chapters.txt))
ACTS := $(addprefix adventures/,$(shell cat acts.txt))

METADATA := metadata/page.yaml
ACTS_METADATA := metadata/acts_page.yaml

OUTPUT := manual.pdf
ACTS_OUTPUT := acts.pdf

LANGUAGE := sv-SE
COLUMNS := 1
RESOURCEDIR := resources
SVG_SOURCES := $(shell find $(RESOURCEDIR) -name '*.svg')
PDF_RESOURCES := $(SVG_SOURCES:%.svg=%.pdf)

# Path to Eisvogel template, adjust as needed
EISVOGEL_PATH = template/eisvogel.latex

# Pandoc options
PANDOC_OPTS = --toc --pdf-engine=xelatex --template $(EISVOGEL_PATH) --top-level-division=chapter
# --lua-filter=filters/short-captions.lua

# Pandoc command
# -V multicol=$(COLUMNS) --toc

# Default rule
all: $(OUTPUT)

# Rule to build PDF
$(OUTPUT): $(CHAPTERS) $(METADATA) $(PDF_RESOURCES)
	pandoc $(CHAPTERS) $(PANDOC_OPTS) --metadata-file=$(METADATA) --output $@
	# xelatex -jobname=manual content.tex
	# xelatex -jobname=manual content.tex

content.md: $(CHAPTERS) $(METADATA) $(PDF_RESOURCES)
	pandoc $(CHAPTERS) --metadata-file=$(METADATA) --top-level-division=chapter --output $@

$(ACTS_OUTPUT): $(ACTS) $(ACTS_METADATA) $(PDF_RESOURCES)
	pandoc $(ACTS) $(PANDOC_OPTS) --metadata-file=$(ACTS_METADATA) --output $@

resources/%.pdf: resources/%.svg
	rsvg-convert -f pdf -o $@ $<

# Clean rule
clean:
	rm -f $(OUTPUT)

# Phony targets
.PHONY: all clean
