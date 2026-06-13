# Raw inputs

Unprocessed inputs that the scripts in `../code/` turn into the analysis-ready
files in `../data/`. Two preparation steps were applied before anything
landed here:

1. **Date-window filter.** Only samples collected (or, for negative controls,
   processed) between **2023-10-31** and **2023-12-22** inclusive are included,
   matching the date range used in the manuscript.
2. **Privacy scrub.** Personnel names are replaced with single-letter
   pseudonyms (`A`, `B`, …); internal sheet URLs, dropbox/drive references,
   and the airport-vendor name have been removed.

## File index

| Path | Description |
| --- | --- |
| `sample-log/dictionary.csv` | Column-rename + R column-type spec used by `code/01-prepare-metadata.qmd` to import the four sample-log tabs. |
| `sample-log/collected-samples.csv` | One row per collected wastewater sample (date, source, collection site, receiver, volume, …). |
| `sample-log/processed-samples.csv` | One row per nucleic-acid extraction performed on a collected sample. |
| `sample-log/extraction-aliquots.csv` | One row per extraction aliquot drawn from a processed sample. |
| `sample-log/submitted-for-sequencing.csv` | One row per aliquot submitted to MIT BioMicro Center for library prep and sequencing. |
| `bmc-email.txt` | Redacted text of the BMC notification email listing the 41 sequenced libraries with their index sequences. |
| `qpcr/*.csv` | QuantStudio 3 export CSVs for each (date, target) qPCR plate. Two file types per plate: `Results` (per-well Cq calls) and `Amplification Data` (per-well, per-cycle fluorescence trajectories). The `# File Name:` header path in each file has been trimmed to just the `.eds` basename. |
| `qubit/measurements.csv` | Qubit fluorometer measurements (HS RNA and HS dsDNA assays) for each extracted sample, exported from a private Google Sheet. One row per extracted sample; assays in wide format. |
| `mgs/` | Outputs of the NAO Viral MGS Analysis Pipeline (v2.2.1), copied from the run on the BMC sequencing data. Subdirectories mirror the pipeline's output layout. `input/{index,run}-params.json` have had internal-bucket names replaced with `<bucket>` / `<private-bucket>` placeholders. |
| `public/` | Inputs from external public sources (MA DPH COVID dashboard archive; Kraken2 standard-DB inspect file is too large to commit and is fetched on first run — see `public/DOWNLOAD.md`). |
