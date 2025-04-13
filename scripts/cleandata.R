library(tidyverse)
library(docopt)
library(airbnbtools)

# Define command-line arguments
'Usage: cleandata.R --input_path=<input> --output_path=<output>' -> doc
args <- docopt(doc)

# Ensure output directory exists
dir.create(dirname(args$output_path), recursive = TRUE, showWarnings = FALSE)

# Load data
airbnb <- read_csv(args$input_path, show_col_types = FALSE)

# Convert categorical variables to factors
airbnb <- convert_columns_to_factor(airbnb)

# Save cleaned dataset
write_csv(airbnb, args$output_path)
