# Use Jupyter Data Science Notebook as the base image
FROM jupyter/datascience-notebook:latest

# Set working directory
WORKDIR /home/jovyan/work

# Clone GitHub repository into Docker container
RUN git clone https://github.com/DSCI-310-2025/dsci-310-group-10-G10.git /home/jovyan/work/

# Copy `environment.yml` and create Conda environment
COPY environment.yml /home/jovyan/work/environment.yml

# Create conda environment using environment.yml
RUN conda env update --file /home/jovyan/work/environment.yml --name r-environment && \
    conda clean --all -y

# Set the Conda environment as the default
ENV PATH /opt/conda/envs/r-environment/bin:$PATH

# Ensure the environment is activated in shell sessions
RUN echo "source activate r-environment" >> ~/.bashrc

# Run Jupyter Notebook
CMD ["start-notebook.sh", "--NotebookApp.token=''", "--NotebookApp.ip='0.0.0.0'"]


