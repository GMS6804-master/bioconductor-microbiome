## Microbiome Alpha Diversity Analysis

In this tutorial, we use a [bioconductor docker image](https://www.bioconductor.org/help/docker/) that includes the [microbiome package](Introduction to the microbiome R package) and [asciinema](https://asciinema.org/). We will complete the [Alpha Diversity Tutorial](https://microbiome.github.io/tutorials/Alphadiversity.html) using a the [dietswap data set](https://microbiome.github.io/tutorials/Data.html). The "dietswap" data is from a two-week diet swap study between western (USA) and traditional (rural Africa) diets reported in [O’Keefe et al. Nat. Comm. 6:6342, 2015](http://dx.doi.org/10.1038/ncomms7342). 

# Overview
Here we walk through computing microbial alpha diversity using the microbiome/phyloseq packages. We will start from the OTU tables, complete some exploratory analysis, compute alpha diversity and visually explore the results.

- In the examples below, `$` indicates the command line prompt within the container.


- In the example below you will need to export figures using CLI. I have provided an example using a function called png(file="file_name.png") that comes before the plotting function and the dev.off() directly after the plotting function. 


<!-- blank line -->
----
<!-- blank line -->

## Learning Objectives:
 - pull a [bioconductor docker image](https://hub.docker.com/r/bioconductor/bioconductor_docker) from DockerHub
 - run the bioconductor/bioconductor_docker container via docker
 - perform exploratory data analysis (EDA) on example data

## Assignment 
1. Complete the assignment described below.
2. Upload a link to your dockerhub account.
3. Upload a html or word document with plots.
4. Upload a link with asciinema screen-cast.


### Prerequisites
* create an asciinema account using email at [asccinema.org](https://asciinema.org/login/new) 
* navigate to the your project directory: ~/path/to/project/
<!-- blank line -->
----
<!-- blank line -->

 ### Assignment Points
|  Rubric        | Points | 
|----------------|-------|
| Screencast     |  -/50  |
| Results          |  -/20 |
| Plots          |  -/50 |
| On Time        |  -/20  |
*Total Points: -/140*

## Getting Started

### 1. open docker teminal

![asciinema_auth](https://github.com/GMS6804-master/assignment/blob/main/images/terminal_start.png)
<!-- blank line -->
----
<!-- blank line -->

### 2. pull a docker image from DockerHub
```
docker pull [YOUR DOCKERHUB ID]/bioconductor_microbiome:[month_year]
```

### 3. boot into container as bash while also mounting a "dropbox-style" directory that will link your docker container to your local machine
```
docker run -it -v [path-to-working-directory]:/projeect dominicklemas/bioconductor_microbiome:02_2024 bash
```
As an example: 
```
docker run -it -v C:/Users/djlemas/OneDrive/Documents/microbiome:/project dominicklemas/bioconductor_microbiome:02_2024 bash
```
<!-- blank line -->
----
<!-- blank line -->

### 4. link your container to your asciinema.org account by opening the URL in a web browser 
```
$ asciinema auth
```
![asciinema_auth](https://github.com/GMS6804-master/assignment/blob/main/images/asciinema_auth.png)
<!-- blank line -->
----
<!-- blank line -->

### 5. add screen-cast headers 
```
$ asciinema rec
$ # Name: 
$ # Date: 
$ # bioconductor:: bioconductor_microbiome
```
<!-- blank line -->
----
<!-- blank line -->

### 6. Start R 
```
$ R
```

### 7. Load data and Compute Microbial Diversity Metrics

```
library("microbiome")
data(dietswap)
print(dietswap)
pseq <- dietswap
tab <-microbiome::alpha(pseq, index = "all")
kable(head(tab))

```
#### Question 7.1: How many samples are in the study? 

```

```

#### Question 7.2: Determine richness (something)

```
tab <- richness(pseq)
kable(head(tab))

# Figure_8.1_Richness
png(filename = "Figure_8.1_Richness.png");
meanSdPlot(cts, ranks = FALSE);
dev.off()
```

#### Question 7.3: Determine dominance (something)

```
tab <- dominance(pseq, index = "all")
kable(head(tab))

# Figure_8.1_Richness
png(filename = "Figure_8.1_Richness.png");
meanSdPlot(cts, ranks = FALSE);
dev.off()
```
## Testing differences in alpha diversity
We recommend the non-parametric [Kolmogorov-Smirnov test](https://www.rdocumentation.org/packages/dgof/versions/1.2/topics/ks.test) for two-group comparisons when there are no relevant covariates.

# Construct the data
d <- meta(pseq)
d$diversity <- microbiome::diversity(pseq, "shannon")$shannon
# Split the values by group
spl <- split(d$diversity, d$sex)
# Kolmogorov-Smironv test
pv <- ks.test(spl$female, spl$male)$p.value
# Adjust the p-value
padj <- p.adjust(pv)

#### Question 8.1: 

```
tab <- dominance(pseq, index = "all")
kable(head(tab))

# Figure_8.1_Richness
png(filename = "Figure_8.1_Richness.png");
meanSdPlot(cts, ranks = FALSE);
dev.off()
```



### 9. stop your screen-cast recording 

***CTRL+D*** or ***CTRL+C*** to stop recording
***ENTER*** or ***CTRL+C*** to stop recording

![asciinema_auth](https://github.com/GMS6804-master/assignment/blob/main/images/asciinema_stop.png)
<!-- blank line -->
----
<!-- blank line -->
