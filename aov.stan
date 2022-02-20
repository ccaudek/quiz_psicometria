
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
 
