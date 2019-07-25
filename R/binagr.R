#' @export

binagr <- function(rho, sigma2u, sigma2v, numitems, numraters, numcat){

  integrand <- function(z){
    pnorm(z*sqrt(rho)/sqrt(1-rho)) * (1-pnorm(z*sqrt(rho)/sqrt(1-rho))) * dnorm(z)
  }
  result <- integrate(integrand,lower=-100,upper=100)
  kappam <- 1-4*result$value

  ### compute standard error for agreement

  # 1. compute variance of estrho
  sigma2t <- sigma2u+sigma2v+1
  varrho <- ((2*sigma2u^2*(sigma2v+1)^2/(numitems*(sigma2t)^4) + (2*sigma2v^2*sigma2u^2/(numraters*(sigma2t)^4))))

  # 2. compute the inside of the integral
  integrand <- function(z){
    (z/(2*(1-rho)*sqrt(rho*(1-rho)))) * dnorm(z*sqrt(rho)/sqrt(1-rho)) * (1-2*pnorm(z*sqrt(rho)/sqrt(1-rho))) * dnorm(z)
  }
  result <- integrate(integrand,lower=-50,upper=50)

  # 3. combine (delta method)
  var.kappam <- 16 * (result$value)^2 * varrho
  se.kappam <- sqrt(var.kappam)
  lcl.kappam <- kappam - qnorm(0.975)*se.kappam
  ucl.kappam <- kappam + qnorm(0.975)*se.kappam

  output <- c(kappam, se.kappam, lcl.kappam, ucl.kappam)
  output

}
