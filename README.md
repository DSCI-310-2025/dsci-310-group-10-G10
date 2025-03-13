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
### How Docker Image is Built Automatically
- This project uses **GitHub Actions** to automatically build and push Docker images to DockerHub.
- Whenever a change is pushed to the `Dockerfile` in the `main` branch, the following happens:
  1. **GitHub Actions builds a new Docker image**
  2. **The new image is pushed to DockerHub at:**  
     👉 [DockerHub Repository](https://hub.docker.com/r/dscidyy/dsci310_project)
### Manually Pull the Latest Image
1. **Pull the latest Docker image**
   ```sh
   docker pull dscidyy/dsci310_project:latest
2. **Run the container**
   ```sh
   docker run --platform linux/amd64 -it --rm dscidyy/dsci310_project:latest
3. **Inside the container, start an R session**
   library(ggplot2)
   library(dplyr)
   library(car)
   library(corrplot)
   library(tidyverse)
   library(cowplot)




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
