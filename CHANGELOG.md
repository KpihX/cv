# CHANGELOG — cv

## [Unreleased]

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
