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

## Branch naming and Multi-Track Architecture (GRAVE)

- **`master` branch:** canonical source of truth for generic engineering/AI applications.
  - Source LaTeX: `CV_KAMDEM_Ivann.tex`
  - Root PDF output: `CV_KAMDEM_Ivann.pdf`
- **Targeted / Specialized branches (non-master):**
  - **Branch Naming Standard (lowercase):** Exact relative folder name from `Pro/` in full lowercase:
    `<company_or_institution>/<folder_name_in_lowercase>`
    Examples:
    - `columbia/stage_columbia_spatially_aware_foundation_models-x_3a_2027`
    - `columbia/stage_columbia_machine_learning_single_cell-x_3a_2027`
    - `freelance/mission_agent_ia_immobilier`
  - **LaTeX Source:** ALWAYS named `CV_KAMDEM_Ivann.tex` across ALL branches (never renamed).
  - **Root PDF Output:** Exact `Pro/` naming with slashes `/` replaced by dashes `-`:
    `CV_KAMDEM_Ivann-<Company_or_Institution>-<Subject_or_Role_with_Pro_Case>.pdf`
    Examples:
    - `CV_KAMDEM_Ivann-Columbia-Stage_Columbia_Spatially_Aware_Foundation_Models-X_3A_2027.pdf`
    - `CV_KAMDEM_Ivann-Columbia-Stage_Columbia_Machine_Learning_Single_Cell-X_3A_2027.pdf`
    - `CV_KAMDEM_Ivann-Freelance-Mission_Agent_IA_Immobilier.pdf`
  - **Git Cleanliness:** Every branch tracks its own `CV_KAMDEM_Ivann.tex` and its specific output `.pdf` without collisions or leftover files.

## Release process (tag format is LAW)

- Tags are **dates**: `YYYY-MM-DD` — e.g. `2026-09-05`.
  (Plain `vX.Y` retired; `vX.Y (date)` with space/parens is **invalid in git**
  — `check-ref-format` rejects spaces in ref names.)
  The tag name becomes the Release title (`## CV — <tag>`).
- All tags must exist on **both** remotes (`github` + `gitlab`).
- Order: CHANGELOG entry → commit → `make push` (check gates) →
  `git tag -a "YYYY-MM-DD" -m "YYYY-MM-DD"` →
  push the tag to both remotes → CI builds the PDF and creates the Release.
- Backfill (tag for an old commit): point it at the original commit.

## Lessons learned (2026-09-05 — tag/release galère, never again)

1. **Spaces/parens are INVALID in git tag names** (`check-ref-format` rejects
   them). `vX.Y (date)` is impossible — use date-only `YYYY-MM-DD`.
2. **Replacing tags = delete everywhere first**: local (`git tag -d`),
   remote (`git push <remote> :refs/tags/<tag>`), plus the attached GitHub
   Releases (`gh release delete <tag> --yes`) — CI recreates them on push.
3. **CI tag filter is read from the workflow AT the tagged commit.**
   Backfill tags on old commits (old `tags: ['v*']` filter) never trigger —
   create those releases manually:
   `gh release create <tag> <pdf> --notes "## CV — <tag>…"`,
   reusing PDFs from the successful CI runs on the same commits
   (`gh run download <run-id> -n <artifact> -D /tmp/…`).
4. **Workflow trigger must match future tag formats** (here
   `tags: ['v*', '[0-9]*']` in `.github/workflows/build-pdf.yml`).
5. **AGENTS.md was globally git-ignored** (template `.gitignore` + kernel
   `git-ignore-global`) — both fixed so this file is tracked.
6. **`make check` order is dashes → build → pages**, and `check` gates `push`
   — a `---` or 2-page PDF never reaches remotes.
