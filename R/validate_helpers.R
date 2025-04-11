library(dplyr)

check_empty_rows <- function(data) {
  empty_rows <- data %>% filter(if_all(everything(), ~ is.na(.) | . == ""))
  return(empty_rows)
}

check_missing_threshold <- function(data, threshold = 0.1) {
  col_missing <- sapply(data, function(col) mean(is.na(col)))
  exceeded <- col_missing[col_missing > threshold]
  return(exceeded)
}


check_column_types <- function(data, expected_types) {
  actual_types <- sapply(data, class)
  mismatches <- actual_types[names(expected_types)] != expected_types
  return(expected_types[mismatches])
}


check_duplicates <- function(data) {
  duplicate_rows <- data[duplicated(data), ]
  return(duplicate_rows)
}
