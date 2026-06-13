# Cleaning scripts

Quarto scripts that turn the raw inputs in `../data-raw/` into the
analysis-ready files in `../data/`. Render in order:

```sh
quarto render code/01-prepare-metadata.qmd
quarto render code/02-prepare-qc-data.qmd
quarto render code/03-prepare-mgs-data.qmd
```

`_helpers.R` contains small inlined copies of helpers originally from
the [naoutils](https://github.com/securebio/naoutils-rpkg) package
(commit `975a97a`): qPCR Results CSV parsing and Kraken2 report
parsing. Inlining lets these scripts depend only on packages on
CRAN / Bioconductor.

| Script | Inputs | Outputs |
| --- | --- | --- |
| `01-prepare-metadata.qmd` | `data-raw/sample-log/*.csv`, `data-raw/bmc-email.txt` | `data/processed-samples-metadata.rds`, `data/libraries.tsv` |
| `02-prepare-qc-data.qmd` | `data-raw/qpcr/*_Results_*.csv`, `data-raw/qubit/measurements.csv` | `data/qpcr.rds`, `data/qubit.rds` |
| `03-prepare-mgs-data.qmd` | `data-raw/mgs/`, `data-raw/public/kraken-standard_20240605-inspect.txt` (fetched on first run) | `data/kraken-phyloseq.rds`, `data/hv-phyloseq.rds` |

The Massachusetts COVID-19 dashboard archive
(`data-raw/public/archived-covid-19-dashboard-2023-2024.xlsx`) is read
directly by the manuscript and has no separate cleaning step.
