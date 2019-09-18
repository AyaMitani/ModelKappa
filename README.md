# ModelKappa
Calculate model-based kappa of agreement and association and their standard errors.

#### R installation Instructions
Copy and paste the following code to install modelkappa package in R.
```
install.packages("devtools")
library(devtools)
devtools::install_github("AyaMitani/ModelKappa")
library(ModelKappa)
```
#### Use ModelKappa function to calculate model-based agreement (and association) for multiple raters each assessing multiple cases
```
?ModelKappa 
data(holmdata)
ModelKappa(data=holmdata, cat=Cat, item=Item, rater=Rater)
```
