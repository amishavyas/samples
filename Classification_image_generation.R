##--------------------------------------
## Reverse correlation Classification Image Generation

## We generate visual prototypes (aka Classification Images) for each subject by condition (i.e., morally good and warm)
## A total of 264 CIs are obtained 

##---------------------------------------

setwd("/Users/amisha/Desktop/thesis/")
library(rcicr)

# Base image name used during stimulus generation
baseimage <- 'face'

# File containing the contrast parameters (this file was created during stimulus generation)
rdata <- 'stim_info.Rdata'

# Load response data: moral, warm, both 
moraldata <- read.csv('moral_CI_data.csv')
warmdata <- read.csv('warm_CI_data.csv')
responsedata <- read.csv('final_CI_data.csv')

# Batch generate classification images by subject
# We get moral + warm CI per subject 

cis <- batchGenerateCI2IFC(moraldata, by='subjid', 'stimulus', 'response', baseimage, rdata, targetpath ='/Users/amisha/Desktop/thesis/CIs/subject/moral/')
cis <- batchGenerateCI2IFC(warmdata, by='subjid', 'stimulus', 'response', baseimage, rdata, targetpath ='/Users/amisha/Desktop/thesis/CIs/subject/warm/')

# Batch generate classification images by condition
# Not to be used in the study, but computed out of interest 

cis <- batchGenerateCI2IFC(responsedata, 'condition', 'stimulus', 'response', baseimage, rdata, targetpath ='/Users/amisha/Desktop/thesis/CIs/condition/') 




