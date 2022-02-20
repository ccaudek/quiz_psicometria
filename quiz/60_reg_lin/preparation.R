
#----------------------------------------------------------------
# regressione bivariata

suppressPackageStartupMessages({
  library("rstan")
  library("cmdstanr")
  library("posterior")
  library("loo")
  library("rio")
  library("here")
})

rstan_options(auto_write = TRUE) # avoid recompilation of models
options(mc.cores = parallel::detectCores()) # parallelize across all CPUs
Sys.setenv(LOCAL_CPPFLAGS = "-march=native") # improve execution time

d <- rio::import(here("data", "MehrSongSpelke_exp_1.csv"))

names(d)

hist(d$Difference_in_Proportion_Looking)

cor(d$Familiarization_Gaze_to_Familiar, d$Familiarization_Gaze_to_Unfamiliar)

d1 <- d %>% 
  dplyr::filter(exp1 == 1 & Familiarization_Gaze_to_Unfamiliar > 100)

plot(d1$Familiarization_Gaze_to_Familiar, d1$Familiarization_Gaze_to_Unfamiliar)

fm <- lm(Familiarization_Gaze_to_Unfamiliar ~ Familiarization_Gaze_to_Familiar, d1)
summary(fm)

d1$fam_c <- 
  d1$Familiarization_Gaze_to_Familiar - mean(d1$Familiarization_Gaze_to_Familiar)

fm2 <- lm(Familiarization_Gaze_to_Unfamiliar ~ fam_c, d1)
summary(fm2)

data_list <- list(
  N = length(d1$fam_c),
  y = d1$Familiarization_Gaze_to_Unfamiliar,
  x = d1$fam_c
)

modelString <- "
data {
  int<lower=0> N;
  vector[N] y;
  vector[N] x;
}
parameters {
  real alpha;
  real beta;
  real<lower=0> sigma;
}
model {
  // priors
  alpha ~ normal(100, 500);
  beta ~ normal(0, 2.0);
  sigma ~ normal(100, 500);
  y ~ normal(alpha + beta * x, sigma);
}
"
writeLines(modelString, con = "code/simplereg1.stan")

file <- file.path("code", "simplereg1.stan")

mod <- cmdstan_model(file)

fit <- mod$sample(
  data = data_list,
  iter_sampling = 4000L,
  iter_warmup = 2000L,
  seed = 123,
  chains = 4L,
  parallel_chains = 2L,
  refresh = 0,
  thin = 1
)

out <- fit$summary(c("alpha", "beta", "sigma"))
out[2, 6]

#----------------------------------------------------------------
# contronto tra due gruppi

d2 <- d %>% 
  dplyr::filter(exp1 == 1 | exp2 == 1) %>% 
  select(exp1, babylike5)

summary(d2)

d2_clean <- na.omit(d2)

hist(d2_clean$babylike5)

summary(
  lm(babylike5 ~ exp1, data = d2_clean)
)

data_list <- list(
  N = length(d2_clean$babylike5),
  y = d2_clean$babylike5,
  x = d2_clean$exp1
)

modelString <- "
data {
  int<lower=0> N;
  vector[N] y;
  vector[N] x;
}
parameters {
  real alpha;
  real beta;
  real<lower=0> sigma;
}
model {
  // priors
  alpha ~ normal(0, 5);
  beta ~ normal(0, 2.0);
  sigma ~ exponential(1);
  y ~ normal(alpha + beta * x, sigma);
}
generated quantities {
  real cohen_d;
  cohen_d = beta / sigma;
}
"
writeLines(modelString, con = "code/simplereg2.stan")

file <- file.path("code", "simplereg2.stan")

mod <- cmdstan_model(file)

fit <- mod$sample(
  data = data_list,
  iter_sampling = 4000L,
  iter_warmup = 2000L,
  seed = 123,
  chains = 4L,
  parallel_chains = 2L,
  refresh = 0,
  thin = 1
)

out <- fit$summary(c("alpha", "beta", "sigma", "cohen_d"))
out[4, 2]

# create object stanfit
stanfit <- rstan::read_stan_csv(fit$output_files())

out <- rstantools::posterior_interval(
  as.matrix(stanfit),
  prob = 0.57
)

out[2, 1]

#-------------------------------------------------------------------------
# ANOVA

d3 <- d %>% 
  dplyr::filter(exp1 == 1 | exp2 == 1 | exp3 == 1) %>% 
  select(exp1, exp2, exp3, babylike5)

d3 <- d3 %>% 
  mutate(
    exp = ifelse(exp1 == 1, 1, ifelse(exp2 == 1, 2, 3))
  ) %>% 
  dplyr::select(babylike5, exp)

dd <- na.omit(d3)
# table(d3$exp)

summary(lm(babylike5 ~ factor(exp), d3_clean))

data_grp <- list(
  N = nrow(dd),
  K = length(unique(dd$exp)),
  x = dd$exp,
  y = dd$babylike5
)


modelString <- "
 // Comparison of k groups with common variance (ANOVA)
 data {
   int<lower=0> N;            // number of observations
   int<lower=0> K;            // number of groups
   int<lower=1,upper=K> x[N]; // discrete group indicators
   vector[N] y;               // real valued observations
 }
 parameters {
   vector[K] mu;        // group means
   real<lower=0> sigma; // common standard deviation
   real<lower=1> nu;
}
model {
   mu ~ normal(0, 2);
   sigma ~ exponential(1);
   nu ~ gamma(2, 0.1);
   y ~ student_t(nu, mu[x], sigma); 
 }
 "
writeLines(modelString, con = "aov.stan")

file <- file.path("aov.stan")
mod <- cmdstan_model(file)

fit <- mod$sample(
  data = data_grp,
  iter_sampling = 4000L,
  iter_warmup = 2000L,
  seed = 123,
  chains = 4L
)

fit$summary()
stanfit <- rstan::read_stan_csv(fit$output_files())
posterior <- extract(stanfit, permuted = TRUE)

temps <- tibble(posterior$mu) %>%
  setNames(c("Exp 1", "Exp 2", "Exp 3"))

bayesplot::mcmc_areas(temps, prob = 0.95) +
  xlab("Gruppi")

ci95 <- rstanarm::posterior_interval(
  as.matrix(stanfit),
  prob = 0.95
)

ci95[2, 2]


