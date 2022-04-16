
y <- c(
  19.6, 17.5, 15.7, 15.6, 17.8, 15.2, 13.3, 17.7, 17.2, 19.3, 18.2, 13, 22.5, 
  27, 22.3, 19.2, 17.5, 11.4, 12.7, 18.3, 23.5
)

out <- bayesrules::summarize_normal_normal(
  mean = 17.3, # media della distribuzione a priori per mu 
  sd = 4.8, # sd della distribuzione a priori per mu
  sigma = sd(y), # sd del campione
  y_bar = round(mean(y), 3), # media del campione
  n = length(y) # ampiezza campionaria
)
out

mu_post <- out[2, 2]
sd_post <- out[2, 5]

mu_0 <- 22.62

round(pnorm(mu_0, mu_post, sd_post), 2)

round(dnorm(mu_post, mu_post, sd_post), 2)
