FROM bioconductor/bioconductor_docker:devel
WORKDIR /tmp
COPY . .


RUN git clone https://bitbucket.org/tasseladmin/tassel-5-standalone.git
RUN wget https://s3.amazonaws.com/plink1-assets/plink_linux_x86_64_20230116.zip && \ 
unzip -o plink_linux_x86_64_20230116.zip

RUN R -e "install.packages('renv', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN R -e "renv::restore()"
ENTRYPOINT /bin/bash ./run.sh 
