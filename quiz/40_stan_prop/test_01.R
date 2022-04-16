

y_sim <- 11
n_sim <- 25

mu <- 0.6
sigma <- 0.08

prob_int <- 0.65

data_list <- list(
  N = n_sim,
  y = c(rep(1, y_sim), rep(0, (n_sim - y_sim))),
  MU = mu,
  SIGMA = sigma
)

model_string <- "
  data {
    int<lower=0> N;
    array[N] int<lower=0, upper=1> y;
    real MU;
    real<lower=0> SIGMA;
  }
  parameters {
    real<lower=0, upper=1> theta;
  }
  model {
    theta ~ normal(MU, SIGMA);
    y ~ bernoulli(theta);
  }
  "

writeLines(model_string, con = "oneprop_1.stan")

file <- file.path("oneprop_1.stan")

mod <- cmdstan_model(file)

fit <- mod$sample(
  data = data_list,
  iter_sampling = 10000L,
  iter_warmup = 2000L,
  seed = 84735,
  chains = 4L,
  refresh = 0,
  thin = 1
)

fit_stanfit <- rstan::read_stan_csv(fit$output_files())

out <- fit$summary()
out[2, 2]
