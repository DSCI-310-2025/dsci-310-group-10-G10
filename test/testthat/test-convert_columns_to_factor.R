library(testthat)

test_that("convert_columns_to_factor converts specified columns to factor", {
  source("R/convert_columns_to_factor.R")
  df <- data.frame(
    room_type = c("Private", "Shared"),
    host_is_superhost = c("Yes", "No"),
    city = c("Berlin", "Paris"),
    weekdays = c("Mon", "Tue"),
    stringsAsFactors = FALSE
  )

  df_converted <- convert_columns_to_factor(df)

  expect_true(is.factor(df_converted$room_type))
  expect_true(is.factor(df_converted$host_is_superhost))
  expect_true(is.factor(df_converted$city))
  expect_true(is.factor(df_converted$weekdays))
})

