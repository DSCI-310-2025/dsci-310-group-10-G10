library(dplyr)
library(ggplot2)
library(corrplot)


#' Check for completely empty rows
#'
#' This function identifies rows in a data frame where all values are either NA or empty strings.
#'
#' @param data A data frame to check for empty rows.
#'
#' @return A data frame containing the empty rows.
#' @export
#'
#' @examples
#' df <- data.frame(a = c(1, NA, ""), b = c(NA, NA, ""))
#' check_empty_rows(df)
check_empty_rows <- function(data) {
  empty_rows <- data %>% filter(if_all(everything(), ~ is.na(.) | . == ""))
  return(empty_rows)
}

#' Check for columns exceeding a missing value threshold
#'
#' This function calculates the proportion of missing values in each column
#' and returns those exceeding a specified threshold.
#'
#' @param data A data frame to check.
#' @param threshold A numeric value (default 0.1) indicating the allowed proportion of missing values.
#'
#' @return A named numeric vector of columns exceeding the threshold.
#' @export
#'
#' @examples
#' df <- data.frame(a = c(1, NA, NA), b = c(1, 2, 3))
#' check_missing_threshold(df, threshold = 0.3)
check_missing_threshold <- function(data, threshold = 0.1) {
  col_missing <- sapply(data, function(col) mean(is.na(col)))
  exceeded <- col_missing[col_missing > threshold]
  return(exceeded)
}

#' Check column data types against expectations
#'
#' This function compares the actual types of selected columns in a data frame
#' against a named vector of expected types and returns the mismatched ones.
#'
#' @param data A data frame to check.
#' @param expected_types A named character vector of expected types (e.g., c(col1 = "numeric")).
#'
#' @return A named character vector of mismatched expected types.
#' @export
#'
#' @examples
#' df <- data.frame(a = 1:3, b = as.character(1:3))
#' check_column_types(df, c(a = "numeric", b = "numeric"))
check_column_types <- function(data, expected_types) {
  actual_types <- sapply(data, class)
  mismatches <- actual_types[names(expected_types)] != expected_types
  return(expected_types[mismatches])
}


#' Check for duplicate rows
#'
#' This function returns all duplicated rows in a data frame.
#'
#' @param data A data frame to check for duplicates.
#'
#' @return A data frame of duplicated rows.
#' @export
#'
#' @examples
#' df <- data.frame(a = c(1, 2, 2), b = c("x", "y", "y"))
#' check_duplicates(df)
check_duplicates <- function(data) {
  duplicate_rows <- data[duplicated(data), ]
  return(duplicate_rows)
}

#' Detect outliers in numeric columns
#'
#' This function identifies outliers in each specified numeric column using the IQR method.
#' An outlier is a value outside the range [Q1 - 1.5 * IQR, Q3 + 1.5 * IQR].
#'
#' @param data A data frame containing numeric columns.
#' @param numeric_cols A character vector of column names to check for outliers.
#'
#' @return A named list of data frames containing outliers for each column.
#' @export
#'
#' @examples
#' df <- data.frame(x = c(1, 2, 3, 100), y = c(10, 12, 14, 13))
#' check_outliers(df, numeric_cols = c("x", "y"))
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
                        
#' Check for unexpected category levels
#'
#' This function compares the unique values in a categorical column to expected values,
#' and returns any unexpected levels.
#'
#' @param data A data frame containing the categorical column.
#' @param column The name of the categorical column to check.
#' @param expected_levels A character vector of valid category levels.
#'
#' @return A character vector of unexpected levels found in the column.
#' @export
#'
#' @examples
#' df <- data.frame(room_type = c("Shared room", "Private room", "Capsule room"))
#' check_category_levels(df, "room_type", expected_levels = c("Shared room", "Private room", "Entire home/apt"))
check_category_levels <- function(data, column, expected_levels) {
  actual_levels <- unique(data[[column]])
  unexpected <- setdiff(actual_levels, expected_levels)
  return(unexpected)
}

                        
#' Plot and summarize the distribution of the target variable
#'
#' This function generates a histogram and summary statistics of the target variable,
#' and saves them to the specified output directory.
#'
#' @param data A data frame containing the target variable.
#' @param target_var A string representing the column name of the target variable.
#' @param output_dir A path to the output directory where results will be saved.
#'
#' @return None. Side effects: saves a PNG plot and a text summary file.
#' @export
#'
#' @examples
#' df <- data.frame(price = c(100, 150, 120, 180, 200))
#' out_dir <- tempdir()
#' check_target_distribution(df, target_var = "price", output_dir = out_dir)
#' list.files(file.path(out_dir, "validation_issues"))
check_target_distribution <- function(data, target_var, output_dir) {
  target_values <- data[[target_var]]
  summary_stats <- summary(target_values)

  write.table(summary_stats,
              file = file.path(output_dir, "validation_issues", "target_summary.txt"),
              col.names = FALSE)

  png(filename = file.path(output_dir, "validation_issues", "target_histogram.png"),
      width = 800, height = 600)
  ggplot(data, aes(x = .data[[target_var]])) +
    geom_histogram(bins = 50, fill = "skyblue", color = "black") +
    labs(title = paste("Distribution of", target_var), x = target_var, y = "Count")
  dev.off()
}


#' Plot correlations between features and target variable
#'
#' This function computes the correlation matrix between selected numeric features and the target,
#' and generates a correlation heatmap using the corrplot package.
#'
#' @param data A data frame containing the numeric features and target variable.
#' @param features A character vector of feature column names.
#' @param target_var A string representing the target variable column name.
#' @param output_dir A path to the output directory where the correlation plot will be saved.
#'
#' @return None. Side effect: saves a PNG correlation plot.
#' @export
#'
#' @examples
#' if (requireNamespace("corrplot", quietly = TRUE)) {
#'   df <- data.frame(
#'     price = c(100, 150, 200),
#'     size = c(30, 40, 50),
#'     rating = c(4.5, 4.0, 5.0)
#'   )
#'   out_dir <- tempdir()
#'   check_feature_correlations(df, features = c("size", "rating"), target_var = "price", output_dir = out_dir)
#'   list.files(file.path(out_dir, "validation_issues"))
#' }
check_feature_correlations <- function(data, features, target_var, output_dir) {
  numeric_data <- data[, c(features, target_var)]
  cor_matrix <- cor(numeric_data, use = "complete.obs")

  png(filename = file.path(output_dir, "validation_issues", "feature_correlation.png"),
      width = 800, height = 800)
  corrplot::corrplot(cor_matrix, method = "color", tl.col = "black", tl.srt = 45)
  dev.off()
}
                        
