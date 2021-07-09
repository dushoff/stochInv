library(shellpipes)

# generalized random gamma (understands kappa=0, underlying mean is always 1)
grgam <- function(num, kappa){
	if (kappa==0) return(rep(1, num))
	return(rgamma(num, scale=kappa, shape=1/kappa))
}

generation <- function(num, meanR, kappa_t, kappa_c){
	trans <- grgam(num, kappa_t)
	mix <- grgam(num, kappa_c)*(1+kappa_c)
	inf <- rpois(num, meanR*trans*mix)
	return(sum(inf))
}

establish <- function(start, meanR, kappa_t, kappa_c, maxGens=20, maxPop=10*start){
	n <- start
	gens <- 0
	while(n>0){
		gens <- gens + 1
		if (gens>maxGens){
			if (n>start) return(TRUE)
			return(as.logical(NA))
		}
		n <- generation(n, meanR, kappa_t, kappa_c)
		if (n>maxPop) return(TRUE)
	}
	return(FALSE)
}

estProb <- function(reps, meanR, kappa_t, kappa_c, start=1, maxGens=20, maxPop=10*start){
	return(mean(
		replicate(reps, establish(
			1, meanR, kappa_t, kappa_c, maxGens, maxPop
		))
	))
}

saveEnvironment()
