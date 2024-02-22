# build bioconductor_microbiome docker image

This assignment walks you through modifying an [bioconductor docker images](https://hub.docker.com/r/bioconductor/bioconductor_docker) by installing a variety of bioconductor packages and asciinema. [asciinema](https://asciinema.org/about) is a free and open source solution for recording terminal sessions and sharing them on the web. [Docker](https://www.docker.com/resources/what-container) is tool that packages software into self-contained computing environments, called containers. [Docker Hub](https://www.docker.com/products/docker-hub) is a hosted repository service provided by Docker for finding and sharing container images with others.

<!-- blank line -->
----
<!-- blank line -->

## Learning Objectives:
 - build a [bioconductor docker image](https://hub.docker.com/r/bioconductor/bioconductor_docker) from a dockerfile
 - push the new docker image to dockerhub
 
  ## Assignment 
1. Complete the assignment described below.
2. Upload the link to your dockerhub account.


### Prerequisites
* create a [dockerhub account](https://hub.docker.com/)
* navigate to the directory: ~/path/to/directory/with/dockerfile/
<!-- blank line -->
----
<!-- blank line -->

 ### Assignment Points
|  Rubric        | Points | 
|----------------|-------|
| Dockerhub     |  -/40  |
| On Time        |  -/20  |
*Total Points: -/60*

## Getting Started

### 1. open docker teminal
<!-- blank line -->
----
<!-- blank line -->

### 2. create a new image with bioconductor and asciinema using a dockerfile
```
docker build -t bioconductor_microbiome .
```
<!-- blank line -->
----
<!-- blank line -->

### 3. boot into your new docker container & test R libraries 
```
docker run -it bioconductor_microbiome:latest bash
```
when you boot into the container, you should see something similar to:
```
root@[some-numbers/characters]:/project#
```
start R and test bioconductor libraries (i.e. microbiome) are installed correctly. you should see something about phyloseq if the microbiome package is installed correctly.
```
R
library(microbiome)
```
after confirming the microbiome package is installed correctly, you will then exit R
```
quit()
```
then you need to exit the container
```
CTRL-D
```

<!-- blank line -->
----
<!-- blank line -->

### 4. login to dockerhub
```
docker login
login: [YOUR DOCKERHUB ID]
pwd: [YOUR PASSWORD]
```
<!-- blank line -->
----
<!-- blank line -->

### 5. tag your container with the date
```
docker tag bioconductor_microbiome [YOUR DOCKERHUB ID]/bioconductor_microbiome:[month_year]
```
<!-- blank line -->
----
<!-- blank line -->

### 6. push your container to DockerHub
```
docker push [YOUR DOCKERHUB ID]/bioconductor_microbiome:[month_year]
```
