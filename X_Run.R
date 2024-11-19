# Adult X_Run.R file
# TODO:
#-------------------------
# Load packages
#-------------------------
library(here) # setwd in root folder
library(dplyr)
library(vegan)
library(xtable)
library(knitr)
library(mice)

#-------------------------
# Global options
#-------------------------
# Set analysis method
method <- "mean"

# Set main or soft launch
launch <- "main"

# Decide whether to run long functions or load from file
# long functs generate individual valuesets for each individual
run_long_functions <- 0 # no=0, yes=1


# TODO:
#-------------------------
# Run the files
#-------------------------
source(here("scripts", "helpers", "utils.R"))
source(here("scripts", "1_latent_coefs.R"))
source(here("scripts", "2_anchoring.R"))
source(here("scripts", "3_valueset.R"))
# source(here("scripts", "4_heterogeneity.R"))
# source(here("scripts", "5_latex_graphs.R"))
# source(here("scripts", "6_latex_tables.R"))
