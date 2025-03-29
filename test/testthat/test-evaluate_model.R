library(testthat)
library(caret)
library(tibble)
source("../../R/evaluate_model.R")

test_that("evaluate_model returns a tibble with RMSE, MAE, and R2", {
  df <- data.frame(
    price = c(100, 200, 300, 400),
    x1 = c(1, 2, 3, 4),
    x2 = c(10, 20, 30, 40)
  )
  
  model <- train(price ~ ., data = df, method = "lm")
  metrics <- evaluate_model(model, df, response_col = "price")
  
  expect_s3_class(metrics, "tbl_df")
  expect_named(metrics, c("RMSE", "MAE", "R2"))
  expect_true(all(sapply(metrics, is.numeric)))
})

test_that("evaluate_model throws error with missing column", {
  df <- data.frame(
    price = c(100, 200, 300),
    x = 1:3
  )
  model <- train(price ~ ., data = df, method = "lm")
  
  # remove 'price' column from new data
  df_missing <- df
  df_missing$price <- NULL
  
  expect_error(evaluate_model(model, df_missing, response_col = "price"))
})

test_that("evaluate_model returns perfect metrics when model fits perfectly", {
  df <- data.frame(price = c(10, 20, 30), x = c(1, 2, 3))
  model <- train(price ~ ., data = df, method = "lm")
  metrics <- evaluate_model(model, df, "price")
  expect_equal(metrics$RMSE, 0)
  expect_equal(metrics$MAE, 0)
  expect_equal(metrics$R2, 1)
})