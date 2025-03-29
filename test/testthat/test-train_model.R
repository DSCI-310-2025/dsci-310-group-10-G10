library(testthat)
source("../../R/train_model.R")

test_that("train_model returns a caret model", {
  df <- data.frame(
    price = c(100, 200, 300),
    x1 = c(1, 2, 3),
    x2 = c(4, 5, 6)
  )
  model <- train_model(df)
  expect_s3_class(model, "train")
})

test_that("train_model errors without 'price' column", {
  df <- data.frame(
    x1 = c(1, 2, 3),
    x2 = c(4, 5, 6)
  )
  expect_error(train_model(df), , regexp = "price")
})

test_that("train_model uses 5-fold cross-validation", {
  df <- data.frame(
    price = c(100, 200, 300),
    x1 = c(1, 2, 3),
    x2 = c(4, 5, 6)
  )
  model <- train_model(df)
  expect_equal(model$control$number, 5)
})

test_that("train_model trains on correct number of predictors", {
  df <- data.frame(
    price = c(100, 200, 300, 400),
    x1 = c(1, 2, 3, 4),
    x2 = c(5, 6, 7, 8)
  )
  model <- train_model(df)
  expect_equal(length(model$finalModel$coefficients) - 1, ncol(df) - 1)
})

test_that("train_model works with small dataset", {
  df <- data.frame(
    price = c(100, 200, 300, 400, 500),
    x1 = 1:5,
    x2 = 5:1
  )
  model <- train_model(df)
  expect_s3_class(model, "train")
})