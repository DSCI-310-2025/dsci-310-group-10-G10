library(testthat)
library(ggplot2)
source("R/validate_helpers.R")

# ---- Mock data for testing ----
mock_data <- data.frame(
  A = c(1, 2, NA, 4),
  B = c(NA, NA, NA, NA),
  C = c("x", "y", "", "z"),
  D = c(1, 2, 3, 4),
  E = c(1, 1, 1, 1),
  room_type = c("Private room", "Entire home/apt", "Unknown", "Shared room"),
  realSum = c(100, 150, 200, 300),
  person_capacity = c(2, 4, 1, 6),
  bedrooms = c(1, 2, 1, 3),
  dist = c(0.5, 1.0, 2.0, 3.0),
  metro_dist = c(0.3, 0.8, 1.5, 2.2),
  attr_index = c(1, 2, 3, 4),
  rest_index = c(3, 2, 5, 4),
  rest_index_norm = c(0.3, 0.2, 0.5, 0.4)
)

# ---- Test 1: check_empty_rows ----
test_that("check_empty_rows detects fully empty or blank rows", {
  df <- data.frame(a = c("", "", ""), b = c("", "", "x"))
  result <- check_empty_rows(df)
  expect_equal(nrow(result), 2)
})

# ---- Test 2: check_missing_threshold ----
test_that("check_missing_threshold identifies columns exceeding threshold", {
  result <- check_missing_threshold(mock_data, threshold = 0.5)
  expect_true("B" %in% names(result))
})

# ---- Test 3: check_column_types ----
test_that("check_column_types identifies mismatches", {
  expected <- c(A = "numeric", B = "numeric", C = "character", D = "numeric")
  result <- check_column_types(mock_data, expected)
  expect_length(result, 0)  # no mismatch
})

# ---- Test 4: check_duplicates ----
test_that("check_duplicates finds duplicated rows", {
  duplicated_data <- data.frame(x = c(1, 2, 2), y = c("a", "b", "b"))
  result <- check_duplicates(duplicated_data)
  expect_equal(nrow(result), 1)
})

# ---- Test 5: check_outliers ----
test_that("check_outliers returns correct outlier list", {
  result <- check_outliers(mock_data, c("realSum", "bedrooms"))
  expect_type(result, "list")
  expect_true("realSum" %in% names(result) || "bedrooms" %in% names(result))
})

# ---- Test 6: check_category_levels ----
test_that("check_category_levels identifies unexpected levels", {
  expected_levels <- c("Private room", "Entire home/apt", "Shared room")
  result <- check_category_levels(mock_data, "room_type", expected_levels)
  expect_equal(result, "Unknown")
})

# ---- Test 7: check_target_distribution ----
test_that("check_target_distribution generates plot and summary", {
  tmp_dir <- tempfile()
  dir.create(tmp_dir)
  check_target_distribution(mock_data, "realSum", tmp_dir)
  expect_true(file.exists(file.path(tmp_dir, "validation_issues", "target_summary.txt")))
  expect_true(file.exists(file.path(tmp_dir, "validation_issues", "target_histogram.png")))
})

# ---- Test 8: check_feature_correlations ----
test_that("check_feature_correlations generates correlation plot", {
  tmp_dir <- tempfile()
  dir.create(tmp_dir)
  check_feature_correlations(
    mock_data,
    c("realSum", "person_capacity", "bedrooms", "dist"),
    "realSum",
    tmp_dir
  )
  expect_true(file.exists(file.path(tmp_dir, "validation_issues", "feature_correlation.png")))
})
