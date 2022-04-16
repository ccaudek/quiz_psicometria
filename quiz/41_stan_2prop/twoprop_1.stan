
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
    y1 ~ binomial(N1, theta1);    // observation model / likelihood
    y2 ~ binomial(N2, theta2);    // observation model / likelihood
  }
  generated quantities {
    // generated quantities are computed after sampling
    real oddsratio = (theta2/(1-theta2))/(theta1/(1-theta1));
  }
  
