# AGENTS.md — cv

LaTeX CV (moderncv banking, blue, pdflatex) — single source `CV_KAMDEM_Ivann.tex`.
Workflows: `make build` (always rebuilds) · `make check` (dashes → build → 1 page, gates `make push`) · `make push` (github + gitlab).

## Style guide (KπX rules — enforced on every CV edit)

1. **Action sentences, not keyword soup.** Bullets are full sentences built on
   strong verbs: `Built …`, `Architected …`, `… reaching/getting …`.
   Never a bare list of terms with no semantic link.
2. **Technical terms, nuanced.** Keep the terms that prove expertise
   (CNN, RAG, out-of-fold, macro-F1…), but never too many in one bullet,
   and always inside a sentence that stays readable by HR.
3. **Always the purpose (`pour …`).** Every bullet answers *why / for whom*,
   e.g. `… so experts can query a complex codebase in plain language`.
4. **No em-dash (`---`) — ever.** `scripts/check-dashes.sh` (wired first in
   `make check`) fails the build on any `---` outside `%` comments.
   Use `--` or a comma instead.
5. **One page, always.** `make check` fails on ≠1 page. If content overflows,
   condense wording first — never shrink fonts or cheat margins further.

## Release process (tag format is LAW)

- Tags are **dated**: `vX.Y (YYYY-MM-DD)` — e.g. `v1.2 (2026-09-05)`.
  Never a plain `vX.Y`: the tag name becomes the Release title
  (`## CV — <tag>` via `.github/workflows/build-pdf.yml`).
- All three tags must exist on **both** remotes (`github` + `gitlab`).
- Order: CHANGELOG entry → commit → `make push` (check gates) →
  `git tag -a "vX.Y (YYYY-MM-DD)" -m "vX.Y (YYYY-MM-DD)"` →
  push the tag to both remotes → CI builds the PDF and creates the Release.
- Pushing a tag for an old commit (backfill): point it at the original commit.
