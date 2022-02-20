
a <- 3
b <- 6

integrand <- function(p) {p^{a-1}*(1-p)^{b-1}}
integrate(integrand, lower = 0, upper = 1)

1 / (gamma(a + b) / (gamma(a)*gamma(b)))
