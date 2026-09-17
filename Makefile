SOURCE   = CV_KAMDEM_Ivann
BUILDDIR = build

# Detect target PDF name from git branch (fallback to CV_KAMDEM_Ivann.pdf on master/main)
BRANCH = $(shell git rev-parse --abbrev-ref HEAD 2>/dev/null)

ifeq ($(BRANCH),columbia/spatially-aware-foundation-models)
PDF_OUT = $(SOURCE)-Columbia-Spatially_Aware_Foundation_Models.pdf
else ifeq ($(BRANCH),columbia/single-cell-perturbation-data)
PDF_OUT = $(SOURCE)-Columbia-Single_Cell_Perturbation_Data.pdf
else ifeq ($(BRANCH),freelance/agent-ia-immobilier)
PDF_OUT = $(SOURCE)-Freelance-Agent_IA_Immobilier.pdf
else
PDF_OUT = $(SOURCE).pdf
endif

.DEFAULT_GOAL := help

.PHONY: help build preview check push push-tags sync

help:  ## Show this help
	@grep -E '^[a-z-]+:.*?## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-10s %s\n", $$1, $$2}'

build:  ## Compile : double pdflatex pass, PDF copied to root target name
	mkdir -p $(BUILDDIR)
	pdflatex -interaction=nonstopmode -output-directory=$(BUILDDIR) $(SOURCE).tex
	pdflatex -interaction=nonstopmode -output-directory=$(BUILDDIR) $(SOURCE).tex
	cp $(BUILDDIR)/$(SOURCE).pdf $(PDF_OUT)

preview: build  ## Generate preview.png from the PDF (requires imagemagick)
	convert -density 150 $(PDF_OUT) -quality 90 -background white -alpha remove preview.png

check:  ## Dashes first (no build on failure), then build, then 1-page gate
	sh scripts/check-dashes.sh
	$(MAKE) -s build
	@test "$$(pdfinfo $(PDF_OUT) | awk '/^Pages:/ {print $$2}')" = "1" || (echo "check FAILED: expected 1 page" >&2; exit 1)
	@echo "check OK: no em-dash, 1 page ($$PDF_OUT)"

sync:  ## Fetch github + merge (recovers CI-committed preview.png)
	git fetch github
	git merge github/master --no-edit

push: check sync  ## check, then sync, then push HEAD to both remotes
	git push github HEAD
	git push gitlab HEAD

push-tags: push  ## push + push all tags
	git push github --tags
	git push gitlab --tags
