## ------------------------------------------------------------------
## Filename.R
## 
## Project: 
## Purpose: 
## Author: Corrado Caudek
## Date: 
## ------------------------------------------------------------------

library("tidyverse")
library("bayesplot")
theme_set(bayesplot::theme_default(base_size=16))

N <- 20
k <- 16

p <- seq(0, 1, length.out = 1e4)
p

ll <- dbinom(k, N, p, log = TRUE)

p1 <- data.frame(p, ll) %>%
  ggplot(
    aes(x = p, y = ll)
  ) +
  geom_line(color = "#8184FC", size = 1) +
  vline_at(16 / 20, color = "gray", linetype = "dashed", size = 1) +
  labs(
    y = "Verosimiglianza",
    x = c("Parametro p")
  )
p1

dat <- data.frame(p, ll)

# dat[dat$p > 0.499 & dat$p < 0.501, ]$ll

dat %>% 
  dplyr::filter(
    p > 0.599 & p < 0.601
  )



# Normal distribution -----------------------------------------------------


x <- c(2, 3, 1, 3, 4)

true_sigma = 1.2

# Definiamo la funzione di log-verosimiglianza
log_likelihood <- function(x, mu, sigma = true_sigma) {
  sum(dnorm(x, mu, sigma, log = TRUE))
}

# number of points of the plot
nrep <- 1e5
# Values of the parameter mu for which the LL function will be evaluated.
mu <- seq(mean(x) - sd(x), mean(x) + sd(x), length.out = nrep)
# For each possible mu_plot, we compute the value of the joint 
# probability distribution of all observed data points -- i.e., the 
# value of the log-likelihood function. The computed values are saved 
# in the ll vector.
ll <- rep(NA, nrep)
for (i in 1:nrep) {
  ll[i] <- log_likelihood(x, mu[i], true_sigma)
}


p1 <- ggplot(
  data.frame(mu, ll),
  aes(x = mu, y = ll)
) +
  geom_line(color = "blue", size = 1) +
  vline_at(mean(x), color = "gray", linetype="dashed", size = 1) +
  labs(
    y = "Log-verosimiglianza",
    x = c("Parametro \u03BC")
  ) 
p1

max(ll)

