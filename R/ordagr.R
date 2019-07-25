#' @export

ordagr <- function(rho, sigma2u, sigma2v, numitems, numraters, numcat){

  rho <- sigma2u/(sigma2u + sigma2v + 1)
  var.rho <- (2*sigma2u^2*(sigma2v+1)^2)/(numitems*(sigma2u+sigma2v+1)^4) + (2*sigma2v^2*sigma2u^2)/(numraters*(sigma2u+sigma2v+1)^4)


  ### kappa for agreement
  integrand <- function(z)
  {
    addup <- 0
    for (c in 1:numcat){
      addup <- (addup + (pnorm((qnorm(c/numcat) - z*sqrt(rho))/sqrt(1-rho))- pnorm((qnorm((c-1)/numcat) - z*sqrt(rho))/sqrt(1-rho)))^2)
    }
    addup * dnorm(z)
  }
  integral <- integrate(integrand,lower=-800,upper=800)
  kappam <- (numcat/(numcat-1)) * integral$value - 1/(numcat-1)

  ### standard error for agreement
  integrand <- function(z)
  {
    addup <- 0
    addup  <- 2*(pnorm((qnorm(1/numcat)-z*sqrt(rho))/sqrt(1-rho)))*
      (dnorm((qnorm(1/numcat)-z*sqrt(rho))/sqrt(1-rho))*(-z/(2*sqrt(rho*(1-rho)))+(qnorm(1/numcat)-z*sqrt(rho))/(2*(1-rho)^(3/2))))

    for (c in 2:(numcat-1))
    {
      addup <- addup +
        2*(pnorm((qnorm(c/numcat)-z*sqrt(rho))/sqrt(1-rho))-pnorm((qnorm((c-1)/numcat)-z*sqrt(rho))/sqrt(1-rho)))*
        (dnorm((qnorm(c/numcat)-z*sqrt(rho))/sqrt(1-rho))*(-z/(2*sqrt(rho*(1-rho)))+(qnorm(c/numcat)-z*sqrt(rho))/(2*(1-rho)^(3/2)) -
                                                             dnorm((qnorm((c-1)/numcat)-z*sqrt(rho))/sqrt(1-rho))*(-z/(2*sqrt(rho*(1-rho)))+(qnorm((c-1)/numcat)-z*sqrt(rho))/(2*(1-rho)^(3/2)))))
    }
    addup <- addup +
      2*(1-pnorm((qnorm((numcat-1)/numcat)-z*sqrt(rho))/sqrt(1-rho)))*
      (0-dnorm((qnorm((numcat-1)/numcat)-z*sqrt(rho))/sqrt(1-rho))*(-z/(2*sqrt(rho*(1-rho)))+(qnorm((numcat-1)/numcat)-z*sqrt(rho))/(2*(1-rho)^(3/2))))

    addup * dnorm(z)
  }
  integral <- integrate(integrand,lower=-10,upper=10)
  var.kappam <- (numcat/(numcat-1))^2 * var.rho * (integral$value)^2
  se.kappam <- sqrt(var.kappam)
  lcl.kappam <- kappam - qnorm(0.975)*se.kappam
  ucl.kappam <- kappam + qnorm(0.975)*se.kappam

  output <- c(kappam, se.kappam, lcl.kappam, ucl.kappam)
  output

}
