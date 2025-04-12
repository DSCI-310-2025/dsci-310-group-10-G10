#' This function downloads Airbnb data from given URLs, adds metadata, and combines them. 
#'
#' @param urls A named list where names indicate the city and time period (weekdays/weekends) 
#'            and values are the corresponding dataset URLs.
#'
#' @return A combined data frame with an added city and weekdays column.
#' @export
#' @examples
#' # Not run because this requires internet and real URLs:
#' \dontrun{
#' urls <- list(
#'   "Vancouver_weekdays" = "https://example.com/vancouver_weekdays.csv",
#'   "Toronto_weekends" = "https://example.com/toronto_weekends.csv"
#' )
#' combined_df <- download_combine_data(urls)
#' head(combined_df)
#' }

download_combine_data <- function(urls) {
  library(tidyverse)
  
  airbnb_list <- map2(urls, names(urls), function(url, name) {
    df <- read_csv(url, show_col_types = FALSE) %>%
      mutate(
        weekdays = grepl("weekdays", name),
        city = word(name, 1, sep = "_")
      )
    return(df)
  })
  
  airbnb_combined <- bind_rows(airbnb_list)
  
  return(airbnb_combined)
}
