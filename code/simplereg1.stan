
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

