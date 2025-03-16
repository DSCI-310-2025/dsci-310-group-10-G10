library(tidyverse)
library(docopt)

# Define command-line arguments
'Usage: modelanalysis.R --input_path=<input> --output_dir=<output>' -> doc
args <- docopt(doc)

# Load cleaned data
airbnb <- read_csv(args$input_path)

# Run multiple linear regression including 'weekdays' and 'city'
model <- lm(realSum ~ person_capacity + bedrooms + dist + metro_dist + attr_index_norm +
              host_is_superhost + room_type + weekdays + city + rest_index_norm, data = airbnb)

# Save model summary
summary_output <- capture.output(summary(model))
writeLines(summary_output, file.path(args$output_dir, "model_summary.txt"))

# Plot residuals
png(filename = file.path(args$output_dir, "residuals_plot.png"), width = 800, height = 600)
plot(model$residuals, main="Residuals Plot", col="blue", pch=20)
abline(h=0, col="red")
dev.off()
