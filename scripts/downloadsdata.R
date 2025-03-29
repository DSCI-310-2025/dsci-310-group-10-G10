library(tidyverse)
library(docopt)
source("R/download_combine_data.R") 

# Define command-line arguments
'Usage: downloaddata.R --output_path=<output>' -> doc
args <- docopt(doc)

# Ensure output directory exists
dir.create(dirname(args$output_path), recursive = TRUE, showWarnings = FALSE)

# URLs for datasets
urls <- list(
  berlin_weekdays  = "https://zenodo.org/records/4446043/files/berlin_weekdays.csv",
  berlin_weekends  = "https://zenodo.org/records/4446043/files/berlin_weekends.csv",
  london_weekdays  = "https://zenodo.org/records/4446043/files/london_weekdays.csv",
  london_weekends  = "https://zenodo.org/records/4446043/files/london_weekends.csv",
  paris_weekdays   = "https://zenodo.org/records/4446043/files/paris_weekdays.csv",
  paris_weekends   = "https://zenodo.org/records/4446043/files/paris_weekends.csv"
)

# Download and combine all data
airbnb_combined <- download_combine_data(urls)

# Save as a single CSV
write_csv(airbnb_combined, args$output_path)