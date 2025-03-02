# Analyzing Key Factors Affecting Airbnb Prices in Europe

## Contributors

- Kevin Cheng
- Yueyang Ding
- Tiffany Gong
- Chenguang Li

## Overview

This project aims to investigate the factors that influence Airbnb pricing by analyzing a dataset of listings from Berlin, London, and Paris. Through exploratory data analysis (EDA), correlation analysis, and multiple linear regression, we seek to identify the key predictors of Airbnb pricing.

The data we used was collected from <https://zenodo.org/records/4446043#.Y9Y9ENJBwUE>.

## How to Run this project

To run the coding part, follow these steps:

1. Open terminal or command prompt, cloning GitHub code locally by: git clone https://github.com/DSCI-310-2025/dsci-310-group-10-G10.git
2. Change location: cd dsci-310-group-10-G10
3. Set up the environment, if using conda, run: conda env create -f environment.yml
4. Activate conda: conda activate r-environment
5. Lunch Jypyter Notebook: jupyter notebook

Or Option 2: Run with Docker (Recommended)
1. Pull the latest Docker image from DockerHub: docker pull dscidyy/dsci310_project:latest
2. Run the Docker container: docker run -p 8888:8888 dscidyy/dsci310_project
3. Open your web browser and navigate to: http://localhost:8888


## List of dependencies needed to run analysis

R packages:
- `ggplot2`
- `dplyr`
- `car`
- `corrplot`
- `tidyr`
- `cowplot`

## Licenses

- MIT License
- Attribution 4.0 International (CC BY 4.0) License

## References

Gyódi, K., & Nawaro, Ł. (2021). Determinants of Airbnb prices in European cities: A spatial econometrics approach (Supplementary Material) [Data set]. Zenodo. https://doi.org/10.5281/zenodo.4446043
