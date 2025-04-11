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

check_outliers <- function(data, numeric_cols) {
  outliers_list <- list()

  for (col in numeric_cols) {
    values <- data[[col]]
    q1 <- quantile(values, 0.25, na.rm = TRUE)
    q3 <- quantile(values, 0.75, na.rm = TRUE)
    iqr <- q3 - q1
    lower <- q1 - 1.5 * iqr
    upper <- q3 + 1.5 * iqr
    outliers <- data %>% filter(!is.na(.data[[col]]) & (.data[[col]] < lower | .data[[col]] > upper))
    
    if (nrow(outliers) > 0) {
      outliers_list[[col]] <- outliers
    }
  }

  return(outliers_list)
}

check_category_levels <- function(data, column, expected_levels) {
  actual_levels <- unique(data[[column]])
  unexpected <- setdiff(actual_levels, expected_levels)
  return(unexpected)
}
