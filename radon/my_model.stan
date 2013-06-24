data {
    int<lower=0> N;                                             // no. of observations
    int<lower=1> J;                                             // no. of counties
    int<lower=1,upper=J> j[N];                                  // vector containing county index for each observation
    real x[N];                                                  // vector for floor level; 0 for basemenet, 1 for first floor
    real y[N];
}

parameters {
    real b;                                                     // beta coefficient of model
    real<lower=0,upper=100> sigma_y;                            // regression error variance; give it uniform prior on [0,100]
    real alpha[J];                                              // intercepts for each county (group level parameters)
    real mu_a;                                                  // mean of county intercepts
    real<lower=0,upper=100> sigma_a;                            // standard of county intercepts
}

model {
    b ~ normal(0,100);                                          // assign (non-informative) prior to beta coefficient
    mu_a ~ normal(0,100);                                       // assign (non-informative) prior to mean of county intercepts
    for (i in 1:J)                                              // assign distribution to each group level intercept
        alpha[i] ~ normal(mu_a,sigma_a);
    for (n in 1:N)                                              // assign probability distribution to each data point
        y[n] ~ normal(alpha[j[n]]+b*x[n],sigma_y);
}