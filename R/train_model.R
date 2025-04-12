#' Train a regression model using caret
#'
#' @param train_data A data frame containing the training set. Must include a column called `price`.
#' @return A trained caret model.
#' @export
#'
#' @examples
#' \dontrun{
#' library(caret)
#' df <- data.frame(
#'   price = rnorm(100, mean = 200, sd = 50),
#'   size = rnorm(100, mean = 80, sd = 10),
#'   rating = rnorm(100, mean = 4, sd = 0.5)
#' )
#' model <- train_model(df)
#' summary(model)
#' }

train_model <- function(train_data) {
  library(caret)

  model <- train(
    price ~ ., data = train_data,
    method = "lm",
    trControl = trainControl(method = "cv", number = 5)
  )

  return(model)
}
