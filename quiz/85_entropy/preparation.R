
library("prob")

S <- rolldie(2, nsides = 6, makespace = TRUE)
S <- addrv(S, Y = X1 + X2)
YY <- sort(unique(S$Y))
max_y <- max(YY)
p_y <- table(S$Y) / 36

d <- tibble(
  y = YY,
  p_y = p_y
)
# sum(d$p_y)

entropy <- function(p) {
  -sum(p * log2(p))
}

entropy(d$p_y)

px <- c(.2, .1, .3, .4)
x <- 1:4

entropy(px)

sum(px * log2(1/px))



n1 <- sample(1:5, 1)
n2 <- 6 - n1
x <- c(sample(1:2, 1), rep(3, n1), rep(5, n2), sample(6: 9, 1))
XX <- sort(unique(x))
tab <- table(x) / length(x)
pmf <- tibble(
  x = XX,
  px =tab
)
pmf

# sum(d$p_y)

entropy <- function(p) {
  -sum(p * log2(p))
}

sol <- entropy(pmf$px)






