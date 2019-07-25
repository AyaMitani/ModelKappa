#' @export

ordassoc <- function(rho, sigma2u, sigma2v, numitems, numraters, numcat){

  rho <- sigma2u/(sigma2u + sigma2v + 1)
  var.rho <- (2*sigma2u^2*(sigma2v+1)^2)/(numitems*(sigma2u+sigma2v+1)^4) + (2*sigma2v^2*sigma2u^2)/(numraters*(sigma2u+sigma2v+1)^4)


  denom <- sqrt(sigma2u + sigma2v + 1)

  # ### COMPUTE OBSERVED ASSOCIATION
  # integrand=function(z)
  # {
  #   addup = 0
  #   for (r in 2:(numcat+1))
  #     for (s in 2:(numcat+1))
  #     {
  #       quadwgt = 1- (((r-1)-(s-1))^2)/((numcat-1)^2)
  #       linearwgt = 1- abs((r-1)-(s-1))/(numcat-1)
  #       addup = addup + quadwgt*(pnorm((fullalphavec[r]/denom - z*sqrt(rho))/sqrt(1-rho))- pnorm((fullalphavec[r-1]/denom - z*sqrt(rho))/sqrt(1-rho)))*(pnorm((fullalphavec[s]/denom - z*sqrt(rho))/sqrt(1-rho))- pnorm((fullalphavec[s-1]/denom - z*sqrt(rho))/sqrt(1-rho))) }
  #   addup*dnorm(z)
  # }
  # result = integrate(integrand,lower=-10,upper=10)
  # obsassoc = result$value

  ### weighted kappa for association
  alpha0 <- -50000
  alphaC <- 50000
  alphavec <- c(alpha0, seq(from=1, to=numcat-1)/1000000, alphaC)

  integrand <- function(z)
  {
    addup <- 0
    for (r in 2:(numcat+1))
      for (s in 2:(numcat+1))
      {
        quadwgt <- 1- (((r-1)-(s-1))^2)/((numcat-1)^2)
        linearwgt <- 1- abs((r-1)-(s-1))/(numcat-1)
        addup <- addup + quadwgt*(pnorm((alphavec[r]/denom - z*sqrt(rho))/sqrt(1-rho))- pnorm((alphavec[r-1]/denom - z*sqrt(rho))/sqrt(1-rho)))*(pnorm((alphavec[s]/denom - z*sqrt(rho))/sqrt(1-rho))- pnorm((alphavec[s-1]/denom - z*sqrt(rho))/sqrt(1-rho))) }
    fullintegrand <- addup*dnorm(z)
  }
  integral <- integrate(integrand,lower=-10,upper=10)
  kappawm <- 2 * integral$value - 1

  ### standard error of weighted kappa
  integrand <- function(z)
  {
    addup <- 0
    for (r in 2:(numcat+1))
      for (s in 2:(numcat+1))
      {
        quadwgt <- 1- (((r-1)-(s-1))^2)/((numcat-1)^2)
        linearwgt <- 1- abs((r-1)-(s-1))/(numcat-1)
        addup <- addup + quadwgt*( (pnorm((alphavec[s] - z*sqrt(rho))/sqrt(1-rho))*dnorm((alphavec[r] - z*sqrt(rho))/sqrt(1-rho))*(-z/(2*sqrt(rho*(1-rho))) + (alphavec[r] - z*sqrt(rho))/(2*(1-rho)^(3/2))) +
                                      pnorm((alphavec[r] - z*sqrt(rho))/sqrt(1-rho))*dnorm((alphavec[s] - z*sqrt(rho))/sqrt(1-rho))*(-z/(2*sqrt(rho*(1-rho))) + (alphavec[s] - z*sqrt(rho))/(2*(1-rho)^(3/2))) ) -

                                     (pnorm((alphavec[s] - z*sqrt(rho))/sqrt(1-rho))*dnorm((alphavec[r-1] - z*sqrt(rho))/sqrt(1-rho))*(-z/(2*sqrt(rho*(1-rho))) + (alphavec[r-1] - z*sqrt(rho))/(2*(1-rho)^(3/2))) +
                                        pnorm((alphavec[r-1] - z*sqrt(rho))/sqrt(1-rho))*dnorm((alphavec[s] - z*sqrt(rho))/sqrt(1-rho))*(-z/(2*sqrt(rho*(1-rho))) + (alphavec[s] - z*sqrt(rho))/(2*(1-rho)^(3/2))) ) -

                                     (pnorm((alphavec[s-1] - z*sqrt(rho))/sqrt(1-rho))*dnorm((alphavec[r] - z*sqrt(rho))/sqrt(1-rho))*(-z/(2*sqrt(rho*(1-rho))) + (alphavec[r] - z*sqrt(rho))/(2*(1-rho)^(3/2))) +
                                        pnorm((alphavec[r] - z*sqrt(rho))/sqrt(1-rho))*dnorm((alphavec[s-1] - z*sqrt(rho))/sqrt(1-rho))*(-z/(2*sqrt(rho*(1-rho))) + (alphavec[s-1] - z*sqrt(rho))/(2*(1-rho)^(3/2))) ) +

                                     (pnorm((alphavec[s-1] - z*sqrt(rho))/sqrt(1-rho))*dnorm((alphavec[r-1] - z*sqrt(rho))/sqrt(1-rho))*(-z/(2*sqrt(rho*(1-rho))) + (alphavec[r-1] - z*sqrt(rho))/(2*(1-rho)^(3/2))) +
                                        pnorm((alphavec[r-1] - z*sqrt(rho))/sqrt(1-rho))*dnorm((alphavec[s-1] - z*sqrt(rho))/sqrt(1-rho))*(-z/(2*sqrt(rho*(1-rho))) + (alphavec[s-1] - z*sqrt(rho))/(2*(1-rho)^(3/2))) ))

      }
    addup*dnorm(z)
  }

  integral <- integrate(integrand,lower=-10,upper=10)
  var.kappawm <- 4 * var.rho * (integral$value)^2
  se.kappawm <- sqrt(var.kappawm)
  lcl.kappawm <- kappawm - qnorm(0.975)*se.kappawm
  ucl.kappawm <- kappawm + qnorm(0.975)*se.kappawm

  output <- c(kappawm, se.kappawm, lcl.kappawm, ucl.kappawm)
  output

}
