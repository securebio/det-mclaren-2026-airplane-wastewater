## Helpers used across code/*.qmd
##
## These are minimal inlined copies of functions originally provided by
## the naoutils package (https://github.com/securebio/naoutils-rpkg) at
## commit 975a97a, kept here so the cleaning scripts have no external
## R-package dependency beyond what is on CRAN/Bioconductor.

# qPCR --------------------------------------------------------------------

#' Column types for QuantStudio 'Results' / 'Standard Curve Result' CSVs.
qpcr_results_col_types <- readr::cols(
  Well = "i",
  `Well Position` = "c",
  Sample = "c",
  Target = "c",
  Task = "c",
  Reporter = "c",
  Quencher = "c",
  `Amp Status` = "c",
  # Cq is either a number or "Undetermined", so read in as character first
  Cq = "c",
  `Cq Mean` = "n",
  `Cq Confidence` = "n",
  `Cq SD` = "n",
  `Auto Threshold` = "l",
  Threshold = "n",
  `Auto Baseline` = "l",
  `Baseline Start` = "i",
  `Baseline End` = "i",
  Omit = "l"
)

qpcr_amp_col_types <- readr::cols(
  Well = "i",
  `Well Position` = "c",
  `Cycle Number` = "i",
  Target = "c",
  Rn = "n",
  dRn = "n",
  Sample = "c",
  Omit = "l"
)

clean_qpcr_common <- function(x) {
  x |>
    janitor::clean_names() |>
    tidyr::separate(well_position,
      into = c("row", "column"), sep = 1, remove = FALSE
    ) |>
    dplyr::mutate(
      column = as.integer(column) |> ordered(levels = 1:12),
      row = ordered(row, levels = LETTERS[1:8])
    )
}

#' Read a QuantStudio 'Results' CSV.
read_qpcr_results_csv <- function(file) {
  present_cols <- readr::read_csv(
    file,
    comment = "#", n_max = 0, show_col_types = FALSE, progress = FALSE
  ) |>
    names()
  cts <- qpcr_results_col_types
  cts$cols <- cts$cols[intersect(names(cts$cols), present_cols)]

  readr::read_csv(file, comment = "#", col_types = cts) |>
    clean_qpcr_common() |>
    dplyr::mutate(
      cq = ifelse(cq == "Undetermined", NA, cq) |> as.numeric(),
      cq_status = ifelse(is.na(cq), "Undetermined", "Determined")
    )
}

#' Read a QuantStudio 'Amplification Data' CSV.
read_qpcr_amplification_csv <- function(file) {
  readr::read_csv(file, comment = "#", col_types = qpcr_amp_col_types) |>
    clean_qpcr_common()
}

# Kraken ------------------------------------------------------------------

kraken_col_names <- c(
  "clade_fragments_percent",
  "clade_fragments",
  "node_fragments",
  "minimizers_total",
  "minimizers_distinct",
  "rank_code",
  "taxid",
  "scientific_name",
  "rank_level",
  "taxonomy"
)

#' Read one or more Kraken2 standard sample reports or inspect files
#'
#' Can use with `minizers = FALSE` to read an inspect file.
read_kraken_reports <- function(files, minimizers, id = "file", num_threads = 1) {
  if (minimizers) {
    cts <- "nnnnncic"; cns <- kraken_col_names[1:8]
  } else {
    cts <- "nnncic";   cns <- kraken_col_names[c(1:3, 6:8)]
  }
  if (is.null(names(files))) names(files) <- files
  if (is.null(id)) id <- rlang::zap()
  files |>
    purrr::map(\(x) readr::read_tsv(x,
      col_names = cns, col_types = cts,
      comment = "#", trim_ws = FALSE,
      progress = FALSE, num_threads = num_threads
    )) |>
    purrr::list_rbind(names_to = id) |>
    dplyr::mutate(
      rank_level = scientific_name |>
        stringr::str_extract("^ *") |>
        stringr::str_length() |>
        (\(x) x %/% 2L)(),
      scientific_name = stringr::str_replace(scientific_name, "^ *", "")
    )
}

#' Add a `taxonomy` column to a Kraken report giving the full lineage
#' path (e.g. "R__root;D__Bacteria;K__...;").
kraken_add_taxonomy <- function(x) {
  stopifnot(all(c("rank_code", "scientific_name", "rank_level") %in% names(x)))
  lvls <- x$rank_level
  get_clade_idx <- function(i) {
    next_non_child <- match(TRUE,
      seq_along(lvls) > i & lvls <= lvls[i],
      nomatch = length(lvls) + 1
    )
    seq.int(i, next_non_child - 1)
  }
  x <- tibble::add_column(x, taxonomy = "")
  for (i in seq.int(nrow(x))) {
    node_string <- stringr::str_c(
      x[[i, "rank_code"]], "__", x[[i, "scientific_name"]], ";"
    )
    clade_idx <- get_clade_idx(i)
    x[clade_idx, "taxonomy"] <- stringr::str_c(
      x[clade_idx, ][["taxonomy"]], node_string
    )
  }
  x
}
