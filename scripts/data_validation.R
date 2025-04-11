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
print(unique(data$room_type))

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

expected_types <- c(
  realSum = "numeric",
  city = "character",
  person_capacity = "numeric",
  bedrooms = "numeric"
)

type_mismatches <- check_column_types(data, expected_types)

if (length(type_mismatches) > 0) {
  type_df <- data.frame(Column = names(type_mismatches), Expected = type_mismatches)
  write_csv(type_df, file.path(args$output_dir, "validation_issues", "column_type_mismatches.csv"))
  summary_lines <- c(summary_lines, paste("⚠️ Column types do not match expected:", paste(names(type_mismatches), collapse = ", ")))
} else {
  summary_lines <- c(summary_lines, "✅ All column types match expectations.")
}

# Check 4: Duplicate row check
duplicates <- check_duplicates(data)

if (nrow(duplicates) > 0) {
  write_csv(duplicates, file.path(args$output_dir, "validation_issues", "duplicated_rows.csv"))
  summary_lines <- c(summary_lines, paste("⚠️ Found", nrow(duplicates), "duplicate rows."))
} else {
  summary_lines <- c(summary_lines, "✅ No duplicate rows found.")
}

# Check 5: Outlier detection for numeric columns
numeric_cols <- c("realSum", "person_capacity", "bedrooms", "dist",
                  "metro_dist", "attr_index", "attr_index_norm",
                  "rest_index", "rest_index_norm")

outliers_list <- check_outliers(data, numeric_cols)

if (length(outliers_list) > 0) {
  for (col in names(outliers_list)) {
    write_csv(outliers_list[[col]],
              file.path(args$output_dir, "validation_issues", paste0("outliers_", col, ".csv")))
  }
  summary_lines <- c(summary_lines, paste("⚠️ Outliers detected in columns:", paste(names(outliers_list), collapse = ", ")))
} else {
  summary_lines <- c(summary_lines, "✅ No outliers detected in numeric columns.")
}

# Check 6: Category level mismatch
expected_room_types <- c("Private room", "Entire home/apt", "Shared room")
unexpected_levels <- check_category_levels(data, "room_type", expected_room_types)

if (length(unexpected_levels) > 0) {
  write_csv(as.data.frame(unexpected_levels),
            file.path(args$output_dir, "validation_issues", "unexpected_room_types.csv"))
  summary_lines <- c(summary_lines, paste("⚠️ Unexpected room_type values found:", paste(unexpected_levels, collapse = ", ")))
} else {
  summary_lines <- c(summary_lines, "✅ All room_type values match expectations.")
}

# Check 7: Target variable distribution
check_target_distribution(data, target_var = "realSum", output_dir = args$output_dir)
summary_lines <- c(summary_lines, "📊 Target variable distribution saved as histogram and summary.")

# Check 8: Correlation between features and target
numeric_features <- c("person_capacity", "bedrooms", "dist", "metro_dist",
                      "attr_index", "attr_index_norm", "rest_index", "rest_index_norm")

check_feature_correlations(data, features = numeric_features,
                           target_var = "realSum", output_dir = args$output_dir)

summary_lines <- c(summary_lines, "📊 Feature-target correlations plot saved.")

write_lines(summary_lines, summary_path)
cat(paste(summary_lines, collapse = "\n"))

