
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
  
