# Cleaned analysis inputs

Files produced by the scripts in `../code/` from the raw inputs in
`../data-raw/`. These are what `../manuscript/index.qmd` reads.

| File | Description |
| --- | --- |
| `processed-samples-metadata.rds` | One row per PR extraction; carries collection-side fields from the matching collected sample. Negative controls' `collection_date` is set to their `processed_date`. `sample_source` recodes `BST` → `BOS`; `sample_type` recodes `triturator inflow` → `airplane`. Produced by `code/01-prepare-metadata.qmd`. |
| `libraries.tsv` | One row per MIT BMC sequencing library (41 total). Carries upstream fields via the library → submission → aliquot → processed → collected join chain. Same recodes applied as above. Produced by `code/01-prepare-metadata.qmd`. |
| `qpcr.rds` | One row per qPCR well across 14 QuantStudio plates (SARS-CoV-2 and PMMoV targets). Produced by `code/02-prepare-qc-data.qmd`. |
| `qubit.rds` | One row per (sample × Qubit assay) measurement in long format; OOR readings handled. Produced by `code/02-prepare-qc-data.qmd`. |
| `kraken-phyloseq.rds` | `phyloseq` object (24,596 taxa × 32 samples) of Kraken2 clade abundances, with ribosomal vs. non-ribosomal reads as separate features. Produced by `code/03-prepare-mgs-data.qmd`. |
| `hv-phyloseq.rds` | `phyloseq` object (1,420 taxa × 32 samples) of human-virus clade counts from the pipeline's HV workflow. Produced by `code/03-prepare-mgs-data.qmd`. |
