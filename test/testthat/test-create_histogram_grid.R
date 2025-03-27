library(testthat)
source("R/create_histogram_grid.R")

test_that("create_histogram_grid creates a plot file", {
  # Create temporary file path
  tmp_file <- tempfile(fileext = ".png")

  # Create toy data
  df <- data.frame(
    price = c(100, 150, 200, 250),
    size = c(20, 25, 30, 35),
    rating = c(4.5, 4.0, 5.0, 3.5)
  )

  # Call the function
  create_histogram_grid(df, vars = c("price", "size", "rating"), output_path = tmp_file)

  # Check that file exists
  expect_true(file.exists(tmp_file))

  # Clean up (optional)
  unlink(tmp_file)
})

