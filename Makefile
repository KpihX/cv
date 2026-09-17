SOURCE   = CV_KAMDEM_Ivann
BUILDDIR = build

# Reproducible PDF: pin the embedded timestamp to the repository root commit so
# any rebuild of an unchanged source is byte-identical (worktree never goes dirty).
SOURCE_DATE_EPOCH ?= $(shell git log --reverse --format=%ct 2>/dev/null | head -1 || echo 0)
PDFTEX = FORCE_SOURCE_DATE=1 SOURCE_DATE_EPOCH=$(SOURCE_DATE_EPOCH) pdflatex

# Target PDF name = branch name with / -> - and every char after start/-/_ upcased (Pro/ convention)
BRANCH = $(shell git rev-parse --abbrev-ref HEAD 2>/dev/null)
PDF_OUT = $(shell python3 -c 'import re; b = "$(BRANCH)"; src = "$(SOURCE)"; \
print(f"{src}.pdf" if not b or b in ["master", "main", "HEAD"] else f"{src}-" + re.sub(r"(?:^|[-_])([a-z0-9])", lambda m: m.group(0).upper(), b.replace("/", "-")) + ".pdf")')

.DEFAULT_GOAL := help

.PHONY: help build preview check push push-tags sync

help:  ## Show this help
	@grep -E '^[a-z-]+:.*?## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-10s %s\n", $$1, $$2}'

build:  ## Compile : double pdflatex pass (reproducible), PDF copied to root target name
	mkdir -p $(BUILDDIR)
	$(PDFTEX) -interaction=nonstopmode -output-directory=$(BUILDDIR) $(SOURCE).tex
	$(PDFTEX) -interaction=nonstopmode -output-directory=$(BUILDDIR) $(SOURCE).tex
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
