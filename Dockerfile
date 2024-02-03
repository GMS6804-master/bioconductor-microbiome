# Docker inheritance
FROM bioconductor/bioconductor_docker:devel

RUN apt-get update

### Bioconductor: Part 1
RUN R -e 'BiocManager::install(ask = F)' && R -e 'BiocManager::install(c("microbiome", \
    ask = F))' 

