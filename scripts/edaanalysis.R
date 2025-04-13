library(tidyverse)
library(docopt)
library(ggplot2)
library(cowplot)
library(corrplot)
library(airbnbtools)
# Define command-line arguments
'Usage: edaanalysis.R --input_path=<input> --output_dir=<output>' -> doc
args <- docopt(doc)

# Load cleaned data
airbnb <- read_csv(args$input_path)

# Check structure and missing values
str(airbnb)
cat("The number of missing values is:", sum(is.na(airbnb)), "\n")

# Summary statistics
summary(airbnb[, c("realSum", "person_capacity", "bedrooms", "dist",
                   "metro_dist", "attr_index", "attr_index_norm", "rest_index", "rest_index_norm")])

# Set plot dimensions
options(repr.plot.width = 15, repr.plot.height = 20)

# List of numeric variables
numeric_vars <- c("realSum", "person_capacity", "bedrooms", "dist",
                  "metro_dist", "attr_index", "attr_index_norm",
                  "rest_index", "rest_index_norm")

# Create and save histograms
output_histograms_path <- file.path(args$output_dir, "histograms.png")
create_histogram_grid(airbnb, vars = numeric_vars, output_path = output_histograms_path)


# Compute and save correlation matrix
cor_matrix <- cor(airbnb[, c("realSum", "person_capacity", "bedrooms", "dist", "metro_dist", "attr_index")], use = "complete.obs")
png(filename = file.path(args$output_dir, "correlation_matrix.png"), width = 800, height = 800)
corrplot(cor_matrix, method = "color", tl.col = "black", tl.srt = 45)
dev.off()


