library(dplyr)
library(ggplot2)
library(corrplot)


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

check_feature_correlations <- function(data, features, target_var, output_dir) {
  numeric_data <- data[, c(features, target_var)]
  cor_matrix <- cor(numeric_data, use = "complete.obs")

  png(filename = file.path(output_dir, "validation_issues", "feature_correlation.png"),
      width = 800, height = 800)
  corrplot::corrplot(cor_matrix, method = "color", tl.col = "black", tl.srt = 45)
  dev.off()
}
