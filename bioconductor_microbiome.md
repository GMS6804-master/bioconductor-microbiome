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
 - run the bioconductor/bioconductor_microbiome container via docker
 - perform exploratory data analysis (EDA) on example data

## Assignment 
1. Complete the assignment described below.
2. Upload a link to your dockerhub account.
3. Upload a html or word document with plots.
4. Upload a link with asciinema screen-cast.


### Prerequisites
* create an asciinema account using email at [asccinema.org](https://asciinema.org/login/new) 
* clone the repository to your local machine: https://github.com/GMS6804-master/bioconductor_microbiome/tree/main
* navigate to the directory: ~/path/to/repository/
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

### 3. boot into container & share a directory between the container and local machine
```
docker run -it -v [path-to-working-directory]:/project [YOUR DOCKERHUB ID]/bioconductor_microbiome:[month_year] bash
```
As an example: 
```
docker run -it -v C:/Users/djlemas/OneDrive/Documents/bioconductor_microbiome:/project dominicklemas/bioconductor_microbiome:02_2024 bash
```
<!-- blank line -->
----
<!-- blank line -->

### 4. link your container to your asciinema.org account. Open the URL in a web browser on local machine 
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

#### Question 7.1: What is the distribution of male/female in the study? 
#### Question 7.2: What is the distribution of sex within BMI groups?
```
library("microbiome")
library("knitr")
library("dplyr")
library("ggplot2")
library("ggpubr")
data(dietswap)
print(dietswap)

meta_df=as_tibble(sample_data(dietswap))

meta_df %>%
group_by(bmi_group, sex) %>%
tally()
```

#### Question 7.3: What is the species richness and why is it important for microbiome studies?
```
pseq <- dietswap
richness <- richness(pseq)
kable(head(richness))

# Figure_7.3_Richness
png(filename = "Figure_7.3_Richness.png");
hist(richness$chao1);
dev.off()
```

#### Question 7.4: What is species evenness and why is it important for microbiome studies?

```
evenness <- evenness(pseq, "all")
kable(head(evenness))

# Figure_7.4_Evenness
png(filename = "Figure_7.4_Evenness.png");
hist(evenness$simpson);
dev.off()
```

## 8.1: How can you visualize the differences in alpha diversity according to sex?
To visualize diversity measures, the package provides a simple wrapper around ggplot2. Currently onnly one measure can be visualized at a time.

```
png(filename = "Figure_8.1_shannon_by_sex.png");
p.shannon <- boxplot_alpha(pseq, 
                           index = "shannon",
                           x_var = "sex",
                           fill.colors = c(female="cyan4", male="deeppink4"))

p.shannon <- p.shannon + theme_minimal() + 
  labs(x="Sex", y="Shannon diversity") +
  theme(axis.text = element_text(size=12),
        axis.title = element_text(size=16),
        legend.text = element_text(size=12),
        legend.title = element_text(size=16))
p.shannon
dev.off()
```

### 8.2: How can you test for differences in alpha diversity according to sex? What is the "pv" and "padj"?

The non-parametric [Kolmogorov-Smirnov test](https://www.rdocumentation.org/packages/dgof/versions/1.2/topics/ks.test) for two-group comparisons when there are no relevant covariates.

```
# Construct the data
d <- meta(pseq)
d$diversity <- microbiome::diversity(pseq, "shannon")$shannon
# Split the values by group
spl <- split(d$diversity, d$sex)
# Kolmogorov-Smironv test
pv <- ks.test(spl$female, spl$male)$p.value
# Adjust the p-value
padj <- p.adjust(pv)
```

### Question 9.2: What is the difference in Shannon index between bmi groups? How do you interpret the results?
```
# Get the metadata (sample_data) from the phyloseq object
pseq.meta <- meta(pseq)
kable(head(pseq.meta))

# create a list of pairwise comparisons
tab <- microbiome::alpha(pseq, index = "all")
pseq.meta$Shannon <- tab$diversity_shannon 
pseq.meta$InverseSimpson <- tab$diversity_inverse_simpson
bmi <- levels(pseq.meta$bmi_group) 

# select the pairs we want to compare.
bmi.pairs <- combn(seq_along(bmi), 2, simplify = FALSE, FUN = function(i)bmi[i])
print(bmi.pairs)

# create a violin plot and add stats from non-parametric test (Wilcoxon test) 
p1 <- ggviolin(pseq.meta, x = "bmi_group", y = "Shannon",
 add = "boxplot", fill = "bmi_group", palette = c("#a6cee3", "#b2df8a", "#fdbf6f")) 
p1 <- p1 + stat_compare_means(comparisons = bmi.pairs)
# Export to png
ggarrange(p1) %>%
  ggexport(filename = "Figure_9.2_alpha_bmi_groups.png")
```


### 9. stop your screen-cast recording 

***CTRL+D*** or ***CTRL+C*** to stop recording
***ENTER*** or ***CTRL+C*** to stop recording

![asciinema_auth](https://github.com/GMS6804-master/assignment/blob/main/images/asciinema_stop.png)
<!-- blank line -->
----
<!-- blank line -->
