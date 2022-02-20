
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

