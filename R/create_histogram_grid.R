#' Create and save a grid of histograms for numeric variables
#'
#' This function generates histograms for a set of numeric columns in a data frame
#' and saves them as a grid plot.
#'
#' @param df A data frame containing numeric columns
#' @param vars A character vector of column names to plot
#' @param output_path A string, path to save the output .png file
#'
#' @return NULL (saves the plot to file)
#' @export
#'
#' @examples
#' df <- data.frame(
#'   price = c(100, 150, 200, 250),
#'   size = c(20, 25, 30, 35),
#'   rating = c(4.5, 4.0, 5.0, 3.5)
#' )
#' out_path <- tempfile(fileext = ".png")
#' create_histogram_grid(df, vars = c("price", "size", "rating"), output_path = out_path)
#' file.exists(out_path)  # should return TRUE

create_histogram_grid <- function(df, vars, output_path) {
  library(ggplot2)
  library(cowplot)
  library(purrr)

  plot_list <- map(vars, function(var) {
    ggplot(df, aes(x = !!sym(var))) +
      geom_histogram(bins = 50, fill = "blue", color = "black") +
      ggtitle(paste("Distribution of", var)) +
      xlab(var) + ylab("Count") +
      theme_minimal()
  })

  combined_plot <- cowplot::plot_grid(plotlist = plot_list, ncol = 2)

  ggsave(filename = output_path,
         plot = combined_plot, width = 15, height = 20)
}
