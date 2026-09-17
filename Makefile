SOURCE   = CV_KAMDEM_Ivann
BUILDDIR = build

# Detect target PDF name dynamically from git branch matching exact Pro/ case naming
BRANCH = $(shell git rev-parse --abbrev-ref HEAD 2>/dev/null)
PDF_OUT = $(shell python3 -c 'import re; b = "$(BRANCH)"; src = "$(SOURCE)"; \
pro_cases = { \
    "columbia/stage_columbia_spatially_aware_foundation_models-x_3a_2027": "Columbia-Stage_Columbia_Spatially_Aware_Foundation_Models-X_3A_2027", \
    "columbia/stage_columbia_machine_learning_single_cell-x_3a_2027": "Columbia-Stage_Columbia_Machine_Learning_Single_Cell-X_3A_2027", \
    "freelance/mission_agent_ia_immobilier": "Freelance-Mission_Agent_IA_Immobilier", \
}; \
print(f"{src}.pdf" if b in ["master", "main", "HEAD", ""] else f"{src}-{pro_cases[b]}.pdf" if b in pro_cases else f"{src}-" + "-".join("".join(t.capitalize() if t not in ["-", "_"] else t for t in re.split(r"([-_])", s)) for s in b.split("/")) + ".pdf")')

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
