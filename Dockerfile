# Uses Rocker Tidyverse as a base image, includes R 4.3.1 and Tidyverse related tools
FROM rocker/tidyverse:4.3.1

# Setting up the working directory
WORKDIR /home/rproject

# Copy local code (original git clone removed)
COPY . /home/rproject/

# Install the R dependency in environment.yml
RUN R -e "install.packages(c('ggplot2', 'dplyr', 'car', 'corrplot', 'tidyr', 'cowplot'), repos='https://cran.rstudio.com/')"

# Setting the default command when the container starts
CMD ["R"]


