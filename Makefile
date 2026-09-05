SOURCE   = CV_KAMDEM_Ivann
BUILDDIR = build

.DEFAULT_GOAL := help

.PHONY: help build preview check push push-tags sync

help:  ## Show this help
	@grep -E '^[a-z-]+:.*?## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-10s %s\n", $$1, $$2}'

build:  ## Compile — always rebuilds, double pdflatex pass, PDF copied to root
	mkdir -p $(BUILDDIR)
	pdflatex -interaction=nonstopmode -output-directory=$(BUILDDIR) $(SOURCE).tex
	pdflatex -interaction=nonstopmode -output-directory=$(BUILDDIR) $(SOURCE).tex
	cp $(BUILDDIR)/$(SOURCE).pdf .

preview: build  ## Generate preview.png from the PDF (requires imagemagick)
	convert -density 150 $(SOURCE).pdf -quality 90 -background white -alpha remove preview.png

check:  ## Dashes first (no build on failure), then build, then 1-page gate
	sh scripts/check-dashes.sh
	$(MAKE) -s build
	@test "$$(pdfinfo $(SOURCE).pdf | awk '/^Pages:/ {print $$2}')" = "1" || (echo "check FAILED: expected 1 page" >&2; exit 1)
	@echo "check OK: no em-dash, 1 page"

sync:  ## Fetch github + merge (recovers CI-committed preview.png)
	git fetch github
	git merge github/master --no-edit

push: check sync  ## check, then sync, then push master to both remotes
	git push github master
	git push gitlab master

push-tags: push  ## push + push all tags → triggers GitHub Release with PDF
	git push github --tags
	git push gitlab --tags
