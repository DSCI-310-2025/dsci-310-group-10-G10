# Analyzing Key Factors Affecting Airbnb Prices in Europe

## Contributors

- Kevin Cheng
- Yueyang Ding
- Tiffany Gong
- Chenguang Li

## Overview

This project aims to investigate the factors that influence Airbnb pricing by analyzing a dataset of listings from Berlin, London, and Paris. Through exploratory data analysis (EDA), correlation analysis, and multiple linear regression, we seek to identify the key predictors of Airbnb pricing.

The data we used was collected from <https://zenodo.org/records/4446043#.Y9Y9ENJBwUE>.

## How to Run this Project using Docker
### How Docker Image is Built 
- This project uses **GitHub Actions** to build and push Docker images to DockerHub manually.
- To trigger the workflow:
  1. **Navigate to the GitHub Actions tab in the repository.**
  2. **Select the Docker Build and Push workflow.**
  3. **Click Run workflow to manually start the build process.**
- Once triggered, the workflow:
  1. **GitHub Actions builds a new Docker image**
  2. **The new image is pushed to DockerHub at:**  
     👉 [DockerHub Repository](https://hub.docker.com/r/dscidyy/dsci310_project)
### Manually Pull the Latest Image
1. **Clone repository**
   ```sh
   git clone https://github.com/DSCI-310-2025/dsci-310-group-10-G10.git
2. **cd into repo**
3. **Make sure Docker is running**
4. **Run the services**
   ```sh
   docker-compose up
5. **Navigate to browser**
  to http://localhost:8888/
4. **Inside R**
   ```sh
   system("make all") #to run analysis from start
   system("make clean") #to delete what analysis generated

## Project Structure and Functionality

This project is organized into modular R scripts, each responsible for a specific step in the Airbnb price analysis pipeline.

### Script Overview

| Script | Description |
|--------|-------------|
| `downloadsdata.R` | Downloads raw Airbnb datasets from provided URLs and combines them into a single data frame. |
| `cleandata.R` | Cleans and formats the combined dataset, handling missing values and renaming variables. |
| `data_validation.R` | Validates the cleaned data by checking for missing values, outliers, type mismatches, and unusual categorical levels. |
| `edaanalysis.R` | Performs exploratory data analysis and generates summary statistics, histograms, and correlation plots. |
| `preprocessdata.R` | Applies preprocessing transformations such as converting categorical variables to factors. |
| `modelanalysis.R` | Trains and evaluates a regression model using cross-validation and outputs performance metrics. |
| `trainmodel.R` | Fits a regression model using the caret package. Used internally within `modelanalysis.R`. |

---

### Recommended Manual Workflow

To reproduce the analysis manually without Docker, run the following scripts in order:

```bash
# 1. Download and combine datasets
Rscript scripts/downloadsdata.R --output_path=data/raw_combined.csv

# 2. Clean the data
Rscript scripts/cleandata.R --input_path=data/raw_combined.csv --output_path=data/cleaned_airbnb.csv

# 3. Validate the cleaned data
Rscript scripts/data_validation.R --input_path=data/cleaned_airbnb.csv --output_dir=results/

# 4. Perform EDA
Rscript scripts/edaanalysis.R --input_path=data/cleaned_airbnb.csv --output_dir=results/

# 5. Train and evaluate model
Rscript scripts/modelanalysis.R --input_path=data/cleaned_airbnb.csv --output_dir=results/

### Expected Outputs

All results and diagnostics are saved to the `results/` directory. These include:

- `validation_summary.txt`: Summary of data quality checks
- `target_histogram.png`, `feature_correlation.png`: Visualizations of target variable and feature correlations
- Validation issue files:
  - `high_missing_columns.csv`
  - `duplicated_rows.csv`
  - `outliers_<column>.csv`
  - `column_type_mismatches.csv`
  - `unexpected_room_types.csv`
- `model_summary.txt`: RMSE, MAE, R-squared values for model evaluation


## List of dependencies needed to run analysis

R packages:
- `tidyverse`
- `ggplot2`
- `dplyr`
- `car`
- `corrplot`
- `tidyr`
- `cowplot`
- `docopt`
- `caret`

## Licenses

- MIT License
- Attribution 4.0 International (CC BY 4.0) License
