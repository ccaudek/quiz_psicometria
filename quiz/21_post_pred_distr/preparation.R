a <- sample(1:5, 1)
b <- sample(4:10, 1)
n <- 20
y <- sample(1:n, 1)

out <- bayesrules::summarize_beta_binomial(
  alpha = a, 
  beta = b, 
  y = y, 
  n = n
)

shape1_post <- out[2, 2]
shape2_post <- out[2, 3]

# quantile
q <- sample(1:n, 1) # ignore the value 0
# This is the probability of p(y <= q)
extraDistr::pbbinom(q, n, alpha = shape1_post, beta = shape2_post)

prob <- extraDistr::dbbinom(0:n, n, shape1_post, shape2_post)
# the vector prob starts with p(y == 0), so when q is 1 the index of the
# elements in the vector is 2.
sum(prob[1:(q+1)])


# Test

y <- 10
n <- 20
a <- 1
b <- 8
m <- 25
q <- 12

out <- bayesrules::summarize_beta_binomial(
  alpha = a, 
  beta = b, 
  y = y, 
  n = n
)

shape1_post <- out[2, 2]
shape2_post <- out[2, 3]
extraDistr::pbbinom(q, m, alpha = shape1_post, beta = shape2_post)


#---------------

a <- sample(1:5, 1)
b <- sample(4:10, 1)
n <- 20
y <- sample(1:n, 1)

out <- bayesrules::summarize_beta_binomial(
  alpha = a, 
  beta = b, 
  y = y, 
  n = n
)

shape1_post <- out[2, 2]
shape2_post <- out[2, 3]

## solution

# This is the probability of p(y <= q)
m <- sample(15:30, 1)

prob <- extraDistr::dbbinom(0:m, m, alpha = shape1_post, beta = shape2_post)

d <- tibble(
  y_tilde = 0:m,
  p_y_tilde = prob
)

ev <- sum(d$y_tilde * d$p_y_tilde)

