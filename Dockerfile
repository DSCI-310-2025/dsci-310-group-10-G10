# Use Jupyter Data Science Notebook as the base image
FROM jupyter/datascience-notebook:latest

# Set working directory
WORKDIR /home/jovyan/work

# Clone GitHub repository into Docker container
RUN git clone https://github.com/DSCI-310-2025/dsci-310-group-10-G10.git /home/jovyan/work/

# Install Python dependencies
RUN pip install numpy pandas scikit-learn matplotlib seaborn jupyterlab notebook pip setuptools

# Install R dependencies
RUN R -e "install.packages(c('tidyverse', 'ggplot2', 'caret'), repos='http://cran.us.r-project.org')"

# Run Jupyter Notebook
CMD ["start-notebook.sh", "--NotebookApp.token=''", "--NotebookApp.ip='0.0.0.0'"]



