## ------------------------------------------------------------------
## Filename.R
## 
## Project: 
## Purpose: 
## Author: Corrado Caudek
## Date: 
## ------------------------------------------------------------------

# Packages
suppressPackageStartupMessages(library("tidyverse")) 
suppressPackageStartupMessages(library("patchwork"))
suppressPackageStartupMessages(library("rethinking"))


# Grid
n_points <- 1e5
p_grid <- seq(from = 0, to = 1, length.out = n_points)


# Prior
prior1 <- dbeta(p_grid, 1, 1) / sum(dbeta(p_grid, 1, 1))
sum(prior1)


alpha <- 20
beta <- 2
prior2 <- dbeta(p_grid, alpha, beta) / sum(dbeta(p_grid, alpha, beta))
sum(prior2)


# Likelihood
k <- 5
n <- 7
likelihood <- dbinom(k, size = n, prob = p_grid)


# Unstandardized posterior
unstd_posterior <- likelihood * prior2

# Posterior distribution
posterior <- unstd_posterior / sum(unstd_posterior)

df <- data.frame(p_grid, posterior)
df[which.max(df$posterior), ]$p_grid


p1 <- data.frame(p_grid, prior2) %>% 
  ggplot(aes(x=p_grid, xend=p_grid, y=0, yend=prior2)) +
  geom_line()+
  geom_segment(color = "#8184FC") + 
  #ylim(0, 0.17) +
  labs(
    x = "",
    y = "Probabilità a priori"
  )
p1


p2 <- data.frame(p_grid, likelihood) %>% 
  ggplot(aes(x=p_grid, xend=p_grid, y=0, yend=likelihood)) +
  geom_segment(color = "#8184FC") +
  # ylim(0, 0.17) +
  labs(
    x = "",
    y = "Verosimiglianza"
  )
p2

p3 <- data.frame(p_grid, posterior) %>% 
  ggplot(aes(x=p_grid, xend=p_grid, y=0, yend=posterior)) +
  geom_segment(color = "#8184FC") +
  # ylim(0, 0.17) +
  labs(
    x = "Parametro \U03B8",
    y = "Probabilità a posteriori"
  )
p3

p1 / p2 / p3





# Grid
n_points <- 1e4
p_grid <- seq(from = 0, to = 1, length.out = n_points)
# Prior
alpha <- 1
beta <- 1
prior <- dbeta(p_grid, alpha, beta) / sum(dbeta(p_grid, alpha, beta))
# Likelihood
k <- 7
n <- 12
likelihood <- dbinom(k, size = n, prob = p_grid)
# Unstandardized posterior
unstd_posterior <- likelihood * prior
# Posterior distribution
posterior <- unstd_posterior / sum(unstd_posterior)

n_samples <- 1e5
samples <- sample(p_grid, prob = posterior, size = n_samples, replace = TRUE)

dens(
  samples, 
  col = rangi2, 
  lwd = 3, 
  xlab = "Proporzione di acqua",
  ylab = "Densità"
)

sum(posterior[p_grid < 0.5])
sum(samples < 0.5) / n_samples

sum(posterior[p_grid > 0.8])
sum(samples > 0.8) / n_samples


sum(samples > 0.25 & samples < 0.5) / n_samples

quantile(samples, 0.8)

quantile(samples, c(0.025, 0.975))

HPDI(samples, prob = 0.66)

p_grid[which.max(posterior)]

chainmode(samples, adj=0.01 )

mean(samples)
median(samples)


#-----------------------------------------------------------

birth1 <- c(1,0,0,0,1,1,0,1,0,1,0,0,1,1,0,1,1,0,0,0,1,0,0,0,1,0,
            0,0,0,1,1,1,0,1,0,1,1,1,0,1,0,1,1,0,1,0,0,1,1,0,1,0,0,0,0,0,0,0,
            1,1,0,1,0,0,1,0,0,0,1,0,0,1,1,1,1,0,1,0,1,1,1,1,1,0,0,1,0,1,1,0,
            1,0,1,1,1,0,1,1,1,1)

birth2 <- c(0,1,0,1,0,1,1,1,0,0,1,1,1,1,1,0,0,1,1,1,0,0,1,1,1,0,
            1,1,1,0,1,1,1,0,1,0,0,1,1,1,1,0,0,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,
            1,1,1,0,1,1,0,1,1,0,1,1,1,0,0,0,0,0,0,1,0,0,0,1,1,0,0,1,0,0,1,1,
            0,0,0,1,1,1,0,0,0,0)

sum(birth1 + birth2)
length(birth1) + length(birth2)

# Grid
n_points <- 1e4
p_grid <- seq(from = 0, to = 1, length.out = n_points)
# Prior
alpha <- 1
beta <- 1
prior <- dbeta(p_grid, alpha, beta) / sum(dbeta(p_grid, alpha, beta))
# Likelihood
k <- sum(birth1 + birth2)
n <- length(birth1) + length(birth2)
likelihood <- dbinom(k, size = n, prob = p_grid)
# Unstandardized posterior
unstd_posterior <- likelihood * prior
# Posterior distribution
posterior <- unstd_posterior / sum(unstd_posterior)

n_samples <- 1e6
samples <- sample(p_grid, prob = posterior, size = n_samples, replace = TRUE)

chainmode(samples, adj = 0.01)
HPDI(samples, prob = 0.89)
