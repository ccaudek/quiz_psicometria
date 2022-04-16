## ------------------------------------------------------------------
## Filename.R
## 
## Project: 
## Purpose: 
## Author: Corrado Caudek
## Date: 
## ------------------------------------------------------------------

# Packages
suppressPackageStartupMessages(library("tidyverse")) 
suppressPackageStartupMessages(library("patchwork"))
suppressPackageStartupMessages(library("rethinking"))

weight <- c(46.95, 43.72, 64.78, 32.59, 54.63)

mod <- alist(
  height ~ dnormal(a + b * weight, sigma),
  a ~ dnorm(178, 100),
  b ~ dnorm(0, 10),
  sigma ~ dunif(0, 50)
)



