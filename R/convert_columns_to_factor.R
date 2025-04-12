#' Convert selected columns to factor type
#'
#' This function takes a data frame and converts specified columns to factors.
#' 
#' @param df A data frame containing the columns: room_type, host_is_superhost, city, weekdays
#'
#' @return A data frame with the specified columns converted to factors
#' @export
#' @examples
#' df <- data.frame(
#'   room_type = c("Private room", "Entire home/apt"),
#'   host_is_superhost = c("t", "f"),
#'   city = c("Madrid", "Barcelona"),
#'   weekdays = c(TRUE, FALSE),
#'   price = c(100, 150)
#' )
#' convert_columns_to_factor(df)

convert_columns_to_factor <- function(df) {

  cols_to_convert <- c("room_type", "host_is_superhost", "city", "weekdays")
  
  # Only attempt to convert columns that exist in the data
  existing_cols <- cols_to_convert[cols_to_convert %in% colnames(df)]
  
  # Check if any columns are not character, factor, or logical 
  for (col in existing_cols) {
    if (!is.character(df[[col]]) && !is.factor(df[[col]]) && !is.logical(df[[col]])) {
      stop(paste("Column", col, "must be a character, factor, or logical"))
    }
  }

  # Convert columns to factor
  df <- df %>%
    dplyr::mutate(across(all_of(existing_cols), ~ as.factor(.)))
  
  return(df)
}
