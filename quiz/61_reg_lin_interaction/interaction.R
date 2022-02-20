library(sjPlot)
library(sjmisc)
library(rio)
library(tidyverse)
library(here)
library(khroma)
options(crayon.enabled = TRUE)
okabe <- colour("okabe ito")
plot_scheme(okabe(7), colours = TRUE)

d <- rio::import(here("21_reg_lin_interaction", "lin_mod_interaction.txt"))

dat <- data.frame(
  discernment, is_young, pol
)


m <- lm(discernment ~ pol * is_young, data = dat)
summary(m)

plot_model(m, type = "pred", terms = c("pol", "is_young")) +
  scale_colour_okabeito() +
  papaja::theme_apa()

