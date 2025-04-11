library(tidyverse)
library(docopt)
source("R/validate_helpers.R")

doc <- "
Usage:
  data_validation.R --input_path=<input> --output_dir=<output>
"

args <- docopt(doc)

dir.create(file.path(args$output_dir, "validation_issues"), recursive = TRUE, showWarnings = FALSE)

data <- read_csv(args$input_path, show_col_types = FALSE)

empty_rows <- check_empty_rows(data)
missing_cols <- check_missing_threshold(data, threshold = 0.1)

summary_path <- file.path(args$output_dir, "validation_summary.txt")
summary_lines <- c()

if (nrow(empty_rows) > 0) {
  write_csv(empty_rows, file.path(args$output_dir, "validation_issues", "empty_rows.csv"))
  summary_lines <- c(summary_lines, paste("⚠️ Found", nrow(empty_rows), "completely empty rows."))
} else {
  summary_lines <- c(summary_lines, "✅ No completely empty rows found.")
}

if (length(missing_cols) > 0) {
  write_csv(as.data.frame(missing_cols), file.path(args$output_dir, "validation_issues", "high_missing_columns.csv"))
  summary_lines <- c(summary_lines, paste("⚠️ Columns with >10% missing values:", paste(names(missing_cols), collapse = ", ")))
} else {
  summary_lines <- c(summary_lines, "✅ No columns exceed 10% missing values.")
}

write_lines(summary_lines, summary_path)

cat(paste(summary_lines, collapse = "\n"))

