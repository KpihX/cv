# CHANGELOG — cv

## [Unreleased]

---

## [1.2.0] — 2026-09-05

### Added
- [x] HR header: centered pitch + 6-month research internship sought from end of March 2027
- [x] Quantified DxO entry (eye-state CNN, blur corpus) from the culling-presentation deck
- [x] `scripts/check-dashes.sh`: fail on em-dash (`---`) outside comments, runs first in `make check`
- [x] `make build` (always rebuilds, no timestamp check); bare `make` shows help
- [x] `make check`: dashes → build → 1-page gate (also gates `make push`)

### Changed
- [x] Repo renamed `cv-atf` → `cv` (GitHub `KpihX/cv`, GitLab `kpihx/cv`, remotes `github`/`gitlab`)
- [x] Skills rewritten in plain language; software/cloud/infra merged
- [x] Page geometry bottom `0.45in` → `0.3in` to hold 1 page

### Removed
- [x] `make clean` target

---

## [1.0.0] — 2026-03-22

### Added
- [x] Initial CV source: moderncv banking style, blue theme, pdflatex
- [x] Sections: Education, Professional Experience, Projects Highlights, Technical Skills, Extracurriculars & Awards
- [x] GitLab CI pipeline (`.gitlab-ci.yml`): pdflatex double-pass, PDF + PNG artifacts (1 year)
- [x] GitHub Actions pipeline (`.github/workflows/build-pdf.yml`): pdflatex, PDF artifact, auto-preview PNG commit, Release on tag
- [x] README with CI badges and preview image
- [x] Source renamed to `CV_KAMDEM_Ivann.tex` / output `CV_KAMDEM_Ivann.pdf`

### Fixed
- [x] Color rendering: `\moderncvcolor` must precede `\moderncvstyle` in moderncv v2.4.1 (banking loads `\colorlet{sectioncolor}{color1}` at package load time)
- [x] Bold lost on entry titles: switched from XeLaTeX to pdflatex + `lmodern` + T1 encoding
- [x] Name tint: forced `firstnamecolor = color1` (banking default is `lastnamecolor!60`)
- [x] GitLab CI YAML: removed nested block scalar (`|`) inside script list items
- [x] XeLaTeX `\cventry` inside `\begin{itemize}` conflict: removed outer itemize wrappers

---

*Format: [Keep a Changelog](https://keepachangelog.com) · Versioning: [SemVer](https://semver.org)*
