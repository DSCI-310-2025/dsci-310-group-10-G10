# Uses Rocker Tidyverse as a base image, includes R 4.3.1 and Tidyverse related tools
FROM rocker/tidyverse:4

# Setting up the working directory
WORKDIR /home/rproject

# Copy local code (original git clone removed)
COPY . /home/rproject/

# Install the R dependencies
RUN Rscript -e "remotes::install_version('ggplot2', version = '3.5.1', repos='http://cran.us.r-project.org')" && \
    Rscript -e "remotes::install_version('dplyr', version = '1.1.4', repos='http://cran.us.r-project.org')" && \
    Rscript -e "remotes::install_version('corrplot', version = '0.92', repos='http://cran.us.r-project.org')" && \
    Rscript -e "remotes::install_version('tidyr', version = '1.2.1', repos='http://cran.us.r-project.org')" && \
    Rscript -e "remotes::install_version('cowplot', version = '1.1.1', repos='http://cran.us.r-project.org')" && \
    Rscript -e "remotes::install_version('caret', version = '6.0-94', repos='http://cran.us.r-project.org')" && \
    Rscript -e "remotes::install_version('docopt', version = '0.7.1', repos='http://cran.us.r-project.org')"

# Install airbnbtools package from GitHub (main branch)
RUN Rscript -e "devtools::install_github('DSCI-310-2025/airbnbtools@main')"

# Setting the default command when the container starts
CMD ["/init"]


