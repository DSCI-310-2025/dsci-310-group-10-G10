#!/bin/bash

# Create report directory if it doesn't exist
mkdir -p report/content

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

# Create _toc.yml file if missing
if [ ! -f "report/_toc.yml" ]; then
    cat <<EOL > report/_toc.yml
format: jb-book
root: index
chapters:
  - file: content/introduction
  - file: content/data
  - file: content/methods
  - file: content/results
EOL
    echo "Created report/_toc.yml"
fi

# Create sample content files if missing
for file in index.md content/introduction.md content/data.md content/methods.md content/results.md
do
    if [ ! -f "report/$file" ]; then
        echo "# $(basename $file .md)" > "report/$file"
        echo "Created report/$file"
    fi
done

echo "Jupyter-Book report structure is set up!"
