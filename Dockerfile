# Use Jupyter Data Science Notebook as the base image
FROM jupyter/datascience-notebook:latest

# Set working directory
WORKDIR /home/jovyan/work

# Clone GitHub repository into Docker container
RUN git clone https://github.com/DSCI-310-2025/dsci-310-group-10-G10.git /home/jovyan/work/

#Copy `environment.yml` and create Conda environment
COPY environment.yml /home/jovyan/work/environment.yml
RUN conda env create -f /home/jovyan/work/environment.yml && \
    conda clean --all -y

# Setting the Conda Environment as Default
ENV PATH /opt/conda/envs/r-environment/bin:$PATH
RUN echo "conda activate r-environment" >> ~/.bashrc
    
# Run Jupyter Notebook
CMD ["start-notebook.sh", "--NotebookApp.token=''","--NotebookApp.ip='0.0.0.0'"]

