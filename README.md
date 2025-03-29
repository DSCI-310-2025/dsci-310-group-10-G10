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
