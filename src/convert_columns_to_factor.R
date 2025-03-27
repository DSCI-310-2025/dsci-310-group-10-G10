#' Convert selected columns to factor type
#'
#' This function takes a data frame and converts specified columns to factors.
#' 
#' @param df A data frame containing the columns: room_type, host_is_superhost, city, weekdays
#'
#' @return A data frame with the specified columns converted to factors
#' @export
convert_columns_to_factor <- function(df) {
  df %>%
    dplyr::mutate(
      room_type = as.factor(room_type),
      host_is_superhost = as.factor(host_is_superhost),
      city = as.factor(city),
      weekdays = as.factor(weekdays)
    )
}

