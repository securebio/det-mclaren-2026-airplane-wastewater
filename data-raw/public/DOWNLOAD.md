# External downloads

This directory holds inputs that come from external public sources.

## Committed

- `archived-covid-19-dashboard-2023-2024.xlsx` — Massachusetts Department of
  Public Health COVID-19 dashboard archive. Downloaded from
  <https://www.mass.gov/info-details/covid-19-reporting>. The manuscript
  uses only the *County Data* sheet, filtered to Suffolk, Norfolk, and
  Middlesex counties.

## Not committed (download on first run)

- `kraken-standard_20240605-inspect.txt` — Inspect file for the Kraken2
  standard reference database (build 2024-06-05). This file is large
  (~3 GB uncompressed) and is hosted publicly by the Kraken2
  maintainers. `code/03-prepare-mgs-data.qmd` downloads it on first
  run if missing.

  Source URL:
  <https://genome-idx.s3.amazonaws.com/kraken/standard_20240605/inspect.txt>

  To pre-download manually:

  ```sh
  curl -L -o data-raw/public/kraken-standard_20240605-inspect.txt \
      https://genome-idx.s3.amazonaws.com/kraken/standard_20240605/inspect.txt
  ```
