#' Data from Bladder Cancer Screening Study
#'
#' A dataset containing evaluations by eight genitourinary pathologists reviewing 25 bladder cancer specimens.
#' Each pathologist provided a binary classification for each specimen according to whether or not they considered
#' the sample to be non-invasive or invasive bladder cancer. More details of the study are available at \url{https://doi.org/10.1111/his.12214}.
#'
#' @format A data frame with 200 rows and 3 variables:
#' \describe{
#'   \item{case}{unique patient identifier (1 - 8)}
#'   \item{rater}{unique pathologist identifier (1 - 25)}
#'   \item{cat}{assessment of cancer, 0: non-invasive, 1: invasive}
#' }
#' @source \url{https://doi.org/10.1111/his.12214}
"bcdata"
