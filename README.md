# ModelKappa
Calculate model-based kappa of agreement and association and their standard errors for multiple raters each assessing multiple cases, as seen in:
- Mitani, A. A., & Nelson, K. P. (2017). Modeling Agreement between Binary Classifications of Multiple Raters in R and SAS. Journal of Modern Applied Statistical Methods, 16(2), 277-309. doi: [10.22237/jmasm/1509495300](https://digitalcommons.wayne.edu/jmasm/vol16/iss2/15/)
- Mitani, A. A., Freer, P. E. & Nelson, K. P. (2017) Summary measures of agreement and association between many raters' ordinal classifications. Annals of Epidemiology, 27(10), 677-685. doi: [10.1016/j.annepidem.2017.09.001](http://www.sciencedirect.com/science/article/pii/S1047279717303447)
- Nelson, K. P., and Edwards, D. (2015) Measures of agreement between many raters for ordinal classifications. Statistics in Medicine, 34: 3116–3132. doi: [10.1002/sim.6546](https://onlinelibrary.wiley.com/doi/abs/10.1002/sim.6546) 
- Nelson, K. P. and Edwards, D. (2008), On population‐based measures of agreement for binary classifications. Canadian Journal of Statistics, 36: 411-426. doi: [10.1002/cjs.5550360306](https://onlinelibrary.wiley.com/action/showCitFormats?doi=10.1002%2Fcjs.5550360306)

### R installation Instructions
Copy and paste the following code to install modelkappa package in R.
```
install.packages("devtools")
library(devtools)
devtools::install_github("AyaMitani/ModelKappa")
library(ModelKappa)
```
### About the data sets
#### 'bcdata': Data from Bladder Cancer Screening Study
This is a dataset containing evaluations by eight genitourinary pathologists reviewing 25 bladder cancer specimens.
Each pathologist provided a binary classification for each specimen according to whether or not they considered the sample to be non-invasive or invasive bladder cancer. More details of the study are available from: Compérat, E. et. al. (2013) An interobserver reproducibility study on invasiveness of bladder cancer using virtual microscopy and heatmaps. Histopathology, 63, 756– 766. doi: [org/10.1111/his.12214](https://doi.org/10.1111/his.12214)

To view the data dictionary, see the documentation by typing
```
?bcdata
```

#### 'holmdata': Classification of carcinoma in situ of the uterine cervix
This is a dataset containing evaluations by seven pathologists each independently classifying 118 histologic slides into one of the five ordinal categories of increasing disease severity. This data set is regarded as a classic example to evaluate agreement between multiple raters each classifying a sample of subjects' test results according to an ordinal classification scale. More details of the study are available from: Holmquist, N.D., McMahan, C.A., and Williams, O.D. (1967) Variability in classification of carcinoma in situ of the uterine cervix. Arch. Pathol, 84: 334-345. PMID: [6045446](https://www.ncbi.nlm.nih.gov/pubmed/6045443)

To view the data dictionary, see the documentation by typing
```
?holmdata
```

### Use ModelKappa function to calculate model-based agreement (and association)
```
?ModelKappa 
ModelKappa(data=holmdata, cat=Cat, item=Item, rater=Rater)
```
The output will include Number of observations, Number of categories, Number of items, Number of raters, Model-based kappa for agreement, its standard errors and 95% confidence intervals. If number of categories is >2, then will also output Model-based kappa for association, its standard errors and 95% confidence intervals. Enjoy!
