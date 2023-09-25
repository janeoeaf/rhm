FROM bioconductor/bioconductor_docker:devel
WORKDIR /tmp
COPY . .
RUN R -e "install.packages('renv', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN R -e "renv::restore()"
ENTRYPOINT /bin/bash ./run.sh 
