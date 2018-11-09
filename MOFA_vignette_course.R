## This protocol is taken from:
## http://htmlpreview.github.io/?https://github.com/PMBio/MOFA/blob/master/MOFAtools/vignettes/MOFA_example_CLL.html

## first we load the MOFA library:
```{r, warning=FALSE, message=FALSE}
library(MOFAtools)
```
## Attaching package: ‘MOFAtools’
## The following object is masked from ‘package:stats’:
## predict

# cleaning all old variables from the system: 
rm(list=ls())
# loading the example data files:
data("CLL_data")

## If you wish you can save these files to csv:
#write.csv(CLL_data$mRNA, file="mRNA.csv")
dim(CLL_data$mRNA)
# 5000  200
#write.csv(CLL_data$Mutations, file="mutations.csv")
#dim(CLL_data$Mutations)
# 69 200

##################################################################
## In order to add your own samples I suggest using the magrittr package to create data list
## for example if we have 3 sets of omics data: 
# library(magrittr)

# GEdata <- read.csv("GeneExpression_Data.csv", row.names=1, comment.char="" , 
#                 colClasses=c("character",rep("numeric",9)), 
#                 strip.white=FALSE)

# MetabData <- read.csv("Metabolomics_data.csv", row.names=1, comment.char="" , 
#                 colClasses=c("character",rep("numeric",9)), 
#                 strip.white=FALSE)

#ProteomicsData <- read.csv("Proteomics_data.csv", row.names=1, comment.char="" , 
#                 colClasses=c("character",rep("numeric",9)), 
#                 strip.white=FALSE)

# MATS <- list (GEdata, MetabData, ProteomicsData)
## Below is a function for RData as matrix using a %>% function from yhe magrittr package:
#MATS2 <- list(GEdata=MATS$GEdata %>% as.matrix, MetabData=MATS$MetabData %>% as.matrix, ProteomicsData=MATS$ProteomicsData %>% as.matrix)
#ls(MATS2)
#str(MATS2)
##################################################################

MOFAobject <- createMOFAobject(CLL_data)
## Creating MOFA object from list of matrices,
##  please make sure that samples are columns and features are rows...

MOFAobject
# Untrained MOFA model with the following characteristics: 
#   Number of views: 4 
# View names: Drugs Methylation mRNA Mutations 
# Number of features per view: 310 4248 5000 69 
# Number of samples: 200
plotTilesData(MOFAobject)

# define I/O options:
# DirOptions <- list(
#   "dataDir" = tempdir(), # Folder to store the input matrices as .txt files, it can be a simple temporary folder
#   "outFile" = "/MOFAtest/test.hdf5" # Output file of the model (use hdf5 extension)
# )

#
# define the model: changed!!
DataOptions <- getDefaultDataOptions()
DataOptions 
## $scaleViews
## [1] FALSE
## 
## $removeIncompleteSamples
## [1] FALSE

## Next, we define model options. The most important are:
## numFactors: number of factors (default is 0.5 times the number of samples). By default, the model will only remove a factor if it explains exactly zero variance in the data. 
## You can increase this threshold on minimum variance explained by setting  TrainOptions$dropFactorThreshold to a value higher than zero.

## likelihoods: likelihood for each view. Usually we recommend gaussian for continuous data, 
## bernoulli for binary data and poisson for count data. By default, the model tries to guess it from the data.

## sparsity: do you want to use sparsity? This makes the interpretation easier so it is recommended (Default is TRUE).
ModelOptions <- getDefaultModelOptions(MOFAobject)
ModelOptions$numFactors <- 25
ModelOptions
## $likelihood
##       Drugs Methylation        mRNA   Mutations 
##  "gaussian"  "gaussian"  "gaussian" "bernoulli" 
## 
## $numFactors
## [1] 25
## 
## $sparsity
## [1] TRUE

## Next, we define training options. The most important are:
## maxiter: maximum number of iterations. 
## Ideally set it large enough and use the convergence criterion TrainOptions$tolerance.

## tolerance: convergence threshold based on change in the evidence lower bound. 
## For an exploratory run you can use a value between 1.0 and 0.1, but for a “final” model we recommend a value of 0.01.

## DropFactorThreshold: hyperparameter to automatically learn the number of factors based on a minimum variance explained criteria. 
## Factors explaining less than  DropFactorThreshold fraction of variation in all views will be removed. For example, a value of 0.01 means that factors that explain less than 1% of variance in all views will be discarded. By default this it zero, meaning that all factors are kept unless they explain no variance at all.
TrainOptions <- getDefaultTrainOptions()
# Automatically drop factors that explain less than 2% of variance in all omics
TrainOptions$DropFactorThreshold <- 0.02
TrainOptions$seed <- 2017
## $maxiter
## [1] 5000
## 
## $tolerance
## [1] 0.1
## 
## $DropFactorThreshold
## [1] 0.02
## 
## $verbose
## [1] FALSE
## 
## $seed
## [1] 2017

##Prepare MOFA:
MOFAobject <- prepareMOFA(
  MOFAobject, 
  DataOptions = DataOptions,
  ModelOptions = ModelOptions,
  TrainOptions = TrainOptions
)
## Checking data options...
## Checking training options...
## Checking model options...

MOFAobject <- runMOFA(MOFAobject)
####################ERRORR!!!!!
#[1] "No output file provided, using a temporary file..."
#Error in py_module_import(module, convert = convert) : 
#  ModuleNotFoundError: No module named 'mofa'
####################ERRORR!!!!!
# Run MOFA:
#This step can take some time (around 20 min with default parameters), 
#for illustration we provide an existing trained model
#### MOFAobject <- runMOFA(MOFAobject, DirOptions)
# Loading an existing trained model
filepath <- system.file("extdata", "model15.hdf5", package = "MOFAtools")
MOFAobject <- loadModel(filepath, MOFAobject)
MOFAobject
## Trained MOFA model with the following characteristics: 
##  Number of views: 4 
##  View names: Drugs Methylation Mutations mRNA 
##  Number of features per view: 310 4248 69 5000 
##  Number of samples: 200 
##  Number of factors: 10

##################### Step 3: Analyse a trained MOFA model #####################
# a semi-automated pipeline to disentangle and characterize the sources of variation (the factors) identified by MOFA.

# Part 1: Disentangling the heterogeneity, calculation of variance explained by each factor in each view
r2 <- calculateVarianceExplained(MOFAobject)
r2
# plotting interesting factors:
plotWeightsHeatmap(MOFAobject, "Mutations", factors=1:5, show_colnames=F)
plotWeightsHeatmap(MOFAobject, "mRNA", factors=1:5, show_colnames=F)
plotWeightsHeatmap(MOFAobject, "Methylation", factors=1:5, show_colnames=F)
# or plotting single factor at a time: 
plotWeights(MOFAobject, view = "mRNA", factor = 4)
plotWeights(MOFAobject, view = "Mutations", factor = 1)

#If you are only interested in looking at the top features you can use the ‘plotTopWeights’ function.
plotTopWeights(MOFAobject, "Mutations", 1)
plotTopWeights(MOFAobject, "mRNA", 1)
plotDataHeatmap(MOFAobject, view="mRNA", factor=1, features=20, show_rownames=FALSE)

# Feature set enrichemnt analysis in the active views
# a function for feature set enrichment analysis method (FeatureSetEnrichmentAnalysis) derived from the PCGSE package.
# The input of this function is a MOFA trained model (MOFAmodel), the factors for which to perform feature set enrichment (a character vector), the feature sets (a binary matrix) and a set of options regarding how the analysis should be performed, see also documentation of ‘FeatureSetEnrichmentAnalysis’
# 
# We illustrate the use of this function using the reactome annotations
# Load reactome annotations, binary matrix with feature sets in rows and feautres in columns
data("reactomeGS")

# perfrom enrichment analysis
fsea.out <- runEnrichmentAnalysis(MOFAobject, "mRNA", reactomeGS, alpha = 0.01)

plotEnrichmentBars(fsea.out, alpha=0.01)

interestingFactors <- 4:5

for (factor in interestingFactors) {
  lineplot <- plotEnrichment(MOFAobject,fsea.out, factor, max.pathways=10)
  print(lineplot)
}

#Ordination of samples by factors to reveal clusters and graadients in the sample space
plotFactorScatter(MOFAobject, factors = 1:2, color_by = "IGHV", shape_by = "trisomy12")
plotFactorScatters(MOFAobject, factors = 1:4, color_by = "IGHV")

#A single factor can be visualised using the ‘FactorBeeswarmPlot’ function
plotFactorBeeswarm(MOFAobject, factors = 1, color_by = "IGHV")

##Customized analysis
## For customized exploration of weights and factors, you can directly fetch the variables from the model using ‘get’ functions: ‘getWeights’, ‘getFactors’ and ‘getTrainData’:
MOFAweights <- getWeights(MOFAobject, views="all", factors="all", as.data.frame = T)
head(MOFAweights)

MOFAfactors <- getFactors(MOFAobject, factors=c(1,2), as.data.frame = F)
head(MOFAfactors)
