library(testthat)
source("../../R/download_combine_data.R")

# valid URLs for testing
test_urls <- list(
  berlin_weekdays = "https://zenodo.org/records/4446043/files/berlin_weekdays.csv",
  london_weekends = "https://zenodo.org/records/4446043/files/london_weekends.csv"
)

# invalid URL for testing
invalid_url <- list(
  fake_data = "https://ezenodododoasf.com/fake_dataaaaaa.csv"
)

# Test cases
test_that("works correctly with valid URLs", {
  result <- download_combine_data(test_urls)
  
  expect_s3_class(result, "data.frame")  # Check if result is a dataframe
  expect_true("city" %in% colnames(result))  # Check required columns
  expect_true("weekdays" %in% colnames(result))
  expect_gt(nrow(result), 0)  # Ensure data is not empty
})

test_that("an empty URL list", {
  result <- download_combine_data(list())
  
  expect_s3_class(result, "data.frame")  # Should return a dataframe
  expect_equal(nrow(result), 0)  # Should be empty
})

test_that("a single valid URL", {
  single_url <- list(berlin_weekdays = "https://zenodo.org/records/4446043/files/berlin_weekdays.csv")
  result <- download_combine_data(single_url)
  
  expect_s3_class(result, "data.frame")
  expect_gt(nrow(result), 0)
})

test_that("fails with an invalid URL", {
  expect_error(download_combine_data(invalid_url))
})

test_that("fails with non-string URL inputs", {
  bad_input <- list(berlin_weekdays = 12345)
  expect_error(download_combine_data(bad_input))
})