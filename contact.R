library(tidyr)
library(dplyr)
library(shellpipes)

commandEnvironments()

pars <- crossing(NULL
	, meanR = c(1.1, 1.6)
	, reps = 5e3
	, kappa_t = 0
	, kappa_c = seq(0, 3, length.out=16)
)

sims <- (pars
	%>% rowwise
	%>% mutate(prob = estProb(reps, meanR, kappa_t, kappa_c))
	%>% ungroup
)

print(sims)

rdsSave(sims)
