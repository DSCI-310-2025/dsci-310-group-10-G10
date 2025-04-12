#' Split data into training and testing sets
#'
#' This function splits a dataset into training and testing sets using stratified sampling
#' based on the response variable.
#'
#' @param data A data frame containing the dataset to split
#' @param response_col A string specifying the name of the response column
#' @param train_ratio A numeric value indicating the proportion of data to be used for training (default is 0.8)
#' @param seed An integer seed for reproducibility (default is 123)
#'
#' @return A list containing two elements: 'train' and 'test', which are data frames
#' @export
#'
#' @examples
#' df <- data.frame(
#'   x = rnorm(100),
#'   y = rnorm(100)
#' )
#' split_data <- split_train_test(df, train_frac = 0.75)
#' str(split_data$train)
#' str(split_data$test)

split_train_test <- function(data, response_col, train_ratio = 0.8, seed = 123) {
  set.seed(seed)
  train_indices <- caret::createDataPartition(data[[response_col]], p = train_ratio, list = FALSE)
  train_data <- data[train_indices, ]
  test_data <- data[-train_indices, ]
  return(list(train = train_data, test = test_data))
}
