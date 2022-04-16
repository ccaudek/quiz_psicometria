
library("here")
library("tidyverse")
library("bayesplot")
library("rstan")
library("cmdstanr")
library("bayesrules")


prob_level <- 0.89

data_bin2 <- list(
  N1 = 37, 
  y1 = 12, 
  N2 = 23, # treatment
  y2 = 13
)

model_string <- "
  //  Comparison of two groups with Binomial
  data {
    int<lower=0> N1;              // number of experiments in group 1
    int<lower=0> y1;              // number of survivers in group 1
    int<lower=0> N2;              // number of experiments in group 2
    int<lower=0> y2;              // number of survivers in group 2
  }
  parameters {
    real<lower=0,upper=1> theta1; // probability of surviving in group 1
    real<lower=0,upper=1> theta2; // probability of surviving in group 2
  }
  model {
    theta1 ~ beta(1, 1);          // prior
    theta2 ~ beta(1, 1);          // prior
    y1 ~ binomial(N1, theta1);    // control
    y2 ~ binomial(N2, theta2);    // tratment
  }
  generated quantities {
    // generated quantities are computed after sampling
    real oddsratio = (theta2/(1-theta2))/(theta1/(1-theta1));
  }
  "

writeLines(model_string, con = "twoprop_1.stan")

file <- file.path("twoprop_1.stan")

mod <- cmdstan_model(file)

fit <- mod$sample(
  data = data_bin2,
  iter_sampling = 10000L,
  iter_warmup = 2000L,
  seed = 84735,
  chains = 4L,
  refresh = 0
)

fit_stanfit <- rstan::read_stan_csv(fit$output_files())

out <- rstantools::posterior_interval(
  as.matrix(fit_stanfit),
  prob = prob_level
)

## solution
out

out <- fit$summary()
out[4, 2]
