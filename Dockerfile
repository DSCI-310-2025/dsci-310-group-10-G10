# Use Jupyter Data Science Notebook as the base image
FROM jupyter/datascience-notebook:latest

# Maintainer information
LABEL maintainer="Your Name <your.email@example.com>"

# Set working directory
WORKDIR /home/jovyan/work

# Clone GitHub repository into Docker container
RUN git clone https://github.com/DSCI-310-2025/dsci-310-group-10-G10.git /home/jovyan/work/

# Install Python dependencies
RUN pip install --no-cache-dir -r /home/jovyan/work/requirements.txt

# Install R dependencies
RUN R -e "install.packages(c('tidyverse', 'ggplot2', 'caret'), repos='http://cran.us.r-project.org')"

# Run Jupyter Notebook
CMD ["start-notebook.sh", "--NotebookApp.token=''","--NotebookApp.ip='0.0.0.0'"]

