# Use Jupyter Data Science Notebook as the base image
FROM jupyter/base-notebook:latest

COPY environment.yml .
RUN conda env update --file environment.yml
