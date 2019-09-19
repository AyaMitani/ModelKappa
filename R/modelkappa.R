#' Function to calculate model-based kappa of agreement and association and their standard errors.
#'
#' The \code{data} must be provided in case level or equivalently in `long' format that includes item (or patient) identifiers, rater identifiers, and ratings (or categories).
#'
#' @param data an optional data frame containing the variables providing \code{category}, \code{item}, and \code{rater}.
#' @param category a numerical vector that identifies the ratings or results (binary or >2 categories).
#' @param item a numerical vector that identifies the items to be rated (e.g. mammogram ids).
#' @param rater a numerical vector that identifies the raters (e.g. radiologist ids).
#'
#' @return Outputs the estimated summary measures containing
#' Number of observations, Number of categories, Number of items, Number of raters, Model-based kappa for agreement, its standard errors and 95% confidence intervals.
#' If number of categories is >2, then will also output Model-based kappa for association, its standard errors and 95% confidence intervals.
#' @author Aya Mitani
#' @examples
#' data(holmdata)
#' modelkappa(data=holmdata, cat=Cat, item=Item, rater=Rater)
#' @export
#'
#'


modelkappa <- function(data, category, item, rater){

  names(data)[names(data) == deparse(substitute(item))] <- "item"
  names(data)[names(data) == deparse(substitute(rater))] <- "rater"
  names(data)[names(data) == deparse(substitute(category))] <- "category"

  modout <- (clmm(as.factor(category) ~ 1 + (1|item) + (1|rater),
                  link = "probit", threshold = "flexible", data=data))

  numobs <- modout$dims$n
  numcat <- modout$dims$nalpha + 1
  numitems <- modout$dims$nlev.re["item"]
  numraters <- modout$dims$nlev.re["rater"]

  sigma2u <- (as.numeric(modout$ST$item))^2
  sigma2v <- (as.numeric(modout$ST$rater))^2

  alphavec <- as.numeric(modout$coefficients)

  ### compute rho and its variance
  rho <- sigma2u/(sigma2u + sigma2v + 1)
  var.rho <- (2*sigma2u^2*(sigma2v+1)^2)/(numitems*(sigma2u+sigma2v+1)^4) +
    (2*sigma2v^2*sigma2u^2)/(numraters*(sigma2u+sigma2v+1)^4)

  ### if number of categories = 2, compute agreement only
  ### if number of categories > 2, compute agreement and association
  if(numcat == 2){

    agrout <- binagr(rho, sigma2u, sigma2v, numitems, numraters, numcat)
    kappam <- agrout[1]
    se.kappam <- agrout[2]
    lcl.kappam <- agrout[3]
    ucl.kappam <- agrout[4]

    ### OUTPUTS
    output <- function(){
      cat("\n"," ESTIMATED SUMMARY MEASURES","\n","---------------------------",
          "\n","Number of observations:", numobs,
          "\n","Number of categories:", numcat,
          "\n","Number of items:", numitems,
          "\n","Number of raters:", numraters,
          "\n","Model-based kappa for agreement:", round(kappam,3),"(s.e. =",round(se.kappam,3),")", "95% CI =", round(lcl.kappam,3),",",round(ucl.kappam,3),
          "\n",
          "\n")
    }

  }else{

    agrout <- ordagr(rho, sigma2u, sigma2v, numitems, numraters, numcat)
    kappam <- agrout[1]
    se.kappam <- agrout[2]
    lcl.kappam <- agrout[3]
    ucl.kappam <- agrout[4]

    assocout <- ordassoc(rho, sigma2u, sigma2v, numitems, numraters, numcat)
    kappawm <- assocout[1]
    se.kappawm <- assocout[2]
    lcl.kappawm <- assocout[3]
    ucl.kappawm <- assocout[4]

    ### OUTPUTS
    output <- function(){
      cat("\n"," ESTIMATED SUMMARY MEASURES","\n","---------------------------",
          "\n","Number of observations:", numobs,
          "\n","Number of categories:", numcat,
          "\n","Number of items:", numitems,
          "\n","Number of raters:", numraters,
          "\n","Model-based kappa for agreement:", round(kappam,3),"(s.e. =",round(se.kappam,3),")", "95% CI =", round(lcl.kappam,3),",",round(ucl.kappam,3),
          "\n","MOdel-based Kappa for association:" ,round(kappawm,3),"(s.e. =",round(se.kappawm,3),")", "95% CI =", round(lcl.kappawm,3),",",round(ucl.kappawm,3),
          "\n",
          "\n")
    }

  }

  output()
}
