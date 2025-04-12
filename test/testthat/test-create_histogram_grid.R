source("R/create_histogram_grid.R")
library(testthat)

valid_df <- data.frame(
  price = c(100, 150, 200, 250),
  size = c(20, 25, 30, 35),
  rating = c(4.5, 4.0, 5.0, 3.5)
)

invalid_df <- data.frame(a = 1:3, b = 4:6)

tmp_file <- tempfile(fileext = ".png")

test_that("create_histogram_grid creates a plot file with valid input", {
  create_histogram_grid(valid_df, vars = c("price", "size", "rating"), output_path = tmp_file)
  expect_true(file.exists(tmp_file))
  unlink(tmp_file)
})

test_that("create_histogram_grid fails with non-dataframe input", {
  expect_error(create_histogram_grid("not_a_df", vars = c("price"), output_path = tmp_file))
})

test_that("create_histogram_grid fails if column is missing", {
  expect_error(create_histogram_grid(invalid_df, vars = c("price"), output_path = tmp_file))
})


