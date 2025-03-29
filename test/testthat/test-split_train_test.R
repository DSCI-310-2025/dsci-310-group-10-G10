library(testthat)
source("../../R/split_train_test.R")

test_that("split_train_test returns a list with train and test sets", {
  df <- data.frame(
    price = seq(100, 500, by = 100),
    bedrooms = 1:5,
    city = rep(c("Paris", "Berlin"), length.out = 5)
  )
  
  result <- split_train_test(df, response_col = "price", train_ratio = 0.8)
  
  expect_type(result, "list")
  expect_named(result, c("train", "test"))
  expect_s3_class(result$train, "data.frame")
  expect_s3_class(result$test, "data.frame")
})

test_that("split_train_test respects train_ratio approximately", {
  df <- data.frame(price = 1:100, x = rnorm(100))
  result <- split_train_test(df, "price", train_ratio = 0.7)
  
  expect_true(abs(nrow(result$train) - 70) <= 2)
  expect_true(abs(nrow(result$test) - 30) <= 2)
})

test_that("split_train_test throws error with bad response_col", {
  df <- data.frame(a = 1:5, b = 2:6)
  expect_error(split_train_test(df, response_col = "not_here"))
})

test_that("split_train_test works with very small dataset", {
  df <- data.frame(price = c(100, 200), x = c(1, 2))
  result <- split_train_test(df, "price", train_ratio = 0.5)
  expect_true(nrow(result$train) == 1)
  expect_true(nrow(result$test) == 1)
})