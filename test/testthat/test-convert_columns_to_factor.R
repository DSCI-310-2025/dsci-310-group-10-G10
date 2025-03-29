library(testthat)
source("../../R/convert_columns_to_factor.R")

test_that("convert_columns_to_factor converts specified columns to factor", {
  df <- data.frame(
    room_type = c("Private", "Shared"),
    host_is_superhost = c("Yes", "No"),
    city = c("Berlin", "Paris"),
    weekdays = c("Mon", "Tue"),
    stringsAsFactors = FALSE
  )

  df_converted <- convert_columns_to_factor(df)

  expect_s3_class(df_converted, "data.frame")
  expect_true(is.factor(df_converted$room_type))
  expect_true(is.factor(df_converted$host_is_superhost))
  expect_true(is.factor(df_converted$city))
  expect_true(is.factor(df_converted$weekdays))
})

#Test handling of missing columns
test_that("convert_columns_to_factor handles missing columns gracefully", {
  #dataframe with missing columns
  incomplete_data <- data.frame(
    room_type = c("Entire home/apt", "Private room"),
    host_is_superhost = c("t", "f"),
    stringsAsFactors = FALSE
  )
  
  result <- convert_columns_to_factor(incomplete_data)
  
  # Check if missing columns are still missing
  expect_false("city" %in% colnames(result))
  expect_false("weekdays" %in% colnames(result))
})

# Test with an empty dataframe
test_that("convert_columns_to_factor works with an empty dataframe", {
  empty_data <- data.frame(
    room_type = character(0),
    host_is_superhost = character(0),
    city = character(0),
    weekdays = character(0),
    stringsAsFactors = FALSE
  )
  
  result <- convert_columns_to_factor(empty_data)
  
  # Check if columns are still factors in the empty dataframe
  expect_s3_class(result$room_type, "factor")
  expect_s3_class(result$host_is_superhost, "factor")
  expect_s3_class(result$city, "factor")
  expect_s3_class(result$weekdays, "factor")
})


# Test with invalid input
test_that("convert_columns_to_factor fails with non-string columns", {
  bad_input <- data.frame(
    room_type = 12345,
    host_is_superhost = TRUE,
    city = 67890,
    weekdays = 1,
    stringsAsFactors = FALSE
  )
  
  expect_error(convert_columns_to_factor(bad_input))
})

# Test with missing data in the columns
test_that("convert_columns_to_factor handles missing data in columns", {
  df_with_na <- data.frame(
    room_type = c("Private", "Shared", NA),
    host_is_superhost = c("Yes", "No", NA),
    city = c("Berlin", "Paris", NA),
    weekdays = c("Mon", "Tue", NA),
    stringsAsFactors = FALSE
  )
  
  df_converted <- convert_columns_to_factor(df_with_na)
  
  expect_true(any(is.na(df_converted$room_type)))
  expect_true(any(is.na(df_converted$host_is_superhost)))
  expect_true(any(is.na(df_converted$city)))
  expect_true(any(is.na(df_converted$weekdays)))
})