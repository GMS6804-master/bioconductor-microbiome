## Microbiome Alpha Diversity Analysis

In this tutorial, we use a [bioconductor docker image](https://www.bioconductor.org/help/docker/) that includes the [microbiome package](https://bioconductor.org/packages/release/bioc/html/microbiome.html) and [asciinema](https://asciinema.org/). We will complete the [Alpha Diversity Tutorial](https://microbiome.github.io/tutorials/Alphadiversity.html) using a the [dietswap data set](https://microbiome.github.io/tutorials/Data.html). The "dietswap" data is from a two-week diet swap study between western (USA) and traditional (rural Africa) diets reported in [O’Keefe et al. Nat. Comm. 6:6342, 2015](http://dx.doi.org/10.1038/ncomms7342). 

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

```
ps1 <- prune_taxa(taxa_sums(pseq) > 0, pseq)
tab <- microbiome::alpha(ps1, index = "all")
kable(head(tab))
```
#### Question 8.1: How many [something about metadata]
```
ps1.meta <- meta(ps1)
kable(head(ps1.meta))
```
#### Question 8.2: Visualizes differences in Shannon index between bmi group 

# combine diversity and metadata
```
ps1.meta$Shannon <- tab$diversity_shannon 
ps1.meta$InverseSimpson <- tab$diversity_inverse_simpson

```
# create a list of pairwise comparisons
```
bmi <- levels(ps1.meta$bmi_group) 
```
# make a pairwise list that we want to compare.
```
bmi.pairs <- combn(seq_along(bmi), 2, simplify = FALSE, FUN = function(i)bmi[i])
print(bmi.pairs)
```
# create a violin plot 
```
#ps1.meta$'' <- alpha(ps1, index = 'shannon')
p1 <- ggviolin(ps1.meta, x = "bmi_group", y = "Shannon",
 add = "boxplot", fill = "bmi_group", palette = c("#a6cee3", "#b2df8a", "#fdbf6f")) 
print(p1)
```
# insert pairwise comparison using non-parametric test (Wilcoxon test).

```
p1 <- p1 + stat_compare_means(comparisons = bmi.pairs) 
print(p1)
```

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
