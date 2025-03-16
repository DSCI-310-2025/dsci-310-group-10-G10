#!/bin/bash

# Create report directory if it doesn't exist
mkdir -p report

# Create _config.yml file if missing
if [ ! -f "report/_config.yml" ]; then
    cat <<EOL > report/_config.yml
title: "Airbnb Pricing Analysis Report"
author: "G10"
execute:
  execute_notebooks: force
EOL
    echo "Created report/_config.yml"
fi

# Create _toc.yml file with .qmd as the root
if [ ! -f "report/_toc.yml" ]; then
    cat <<EOL > report/_toc.yml
format: jb-book
root: Airbnb_Pricing_Analysis_Milestone_1  # Use .qmd as the landing page
EOL
    echo "Created report/_toc.yml"
fi


echo "Jupyter-Book report structure is set up"
