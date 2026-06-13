# Metagenomic sequencing of composite airplane wastewater for surveillance of emerging viruses — code and data

Companion repository for *Metagenomic sequencing of composite airplane
wastewater for surveillance of emerging viruses* by McLaren et al. Contains
the raw inputs, the cleaning pipeline, the cleaned analysis-ready files,
and the Quarto source for the manuscript.

## Layout

```
data-raw/     Raw inputs (sample-log exports, instrument CSVs, MGS pipeline outputs, …)
code/         Quarto scripts that turn data-raw/ into data/
data/         Cleaned, analysis-ready inputs read by the manuscript
manuscript/   Quarto source for the paper (index.qmd, references.bib, title.tex)
renv.lock     Pinned R package versions (managed by renv)
.Rprofile     Activates renv and pins the CRAN mirror to a PPM snapshot
```

See per-directory `README.md` files in `data-raw/`, `code/`, and `data/`
for file-level details.

## Reproducing the manuscript

### Prerequisites

- R 4.6 (the version captured in `renv.lock`)
- [Quarto](https://quarto.org/) 1.4 or later

### Steps

1. **Restore the R package environment.** From the repository root, in R:

   ```r
   install.packages("renv")
   renv::restore()
   ```

   This installs ~220 packages — `tidyverse`, `phyloseq` from Bioconductor,
   `speedyseq` from GitHub, `rstanarm`, etc. — into a project-local library
   (`renv/library/`). Your system R library is untouched.

2. **Render the cleaning scripts in order.** From the repository root:

   ```sh
   quarto render code/01-prepare-metadata.qmd
   quarto render code/02-prepare-qc-data.qmd
   quarto render code/03-prepare-mgs-data.qmd
   ```

   On the first render of `code/03`, the Kraken2 standard-DB inspect file
   (~3 GB) is downloaded to `data-raw/public/` from the Kraken2
   maintainers' public URL. The resulting cleaned files appear
   in `data/`.

   You can skip this step entirely if you trust the committed `data/`
   contents; the manuscript renders from those directly.

3. **Render the manuscript.** From the repository root:

   ```sh
   quarto render manuscript/index.qmd --to html
   ```

   The first render fits Bayesian negative-binomial models with `rstanarm`
   and takes on the order of 10–30 minutes. The fits are cached to
   `manuscript/_output/nb-fits.rds`; subsequent renders reuse the cache
   and are fast.

## Provenance

This repository was extracted from a larger private research notebook.
The cleaning scripts in `code/` were rewritten to read from the raw inputs
in `data-raw/` so that the full pipeline can be reproduced from the
committed sources alone, without access to the upstream Google Sheets,
private S3 buckets, or other internal-only systems.

Before being committed, the raw inputs were privacy-scrubbed and
restricted to the manuscript date window; see `data-raw/README.md` for
details.

The original code and analysis were carried out without AI tools. Claude Code
(Anthropic) was used to extract this repository from the private notebook,
perform the privacy scrubbing, and create documentation (the README files and
code comments in this repository).
