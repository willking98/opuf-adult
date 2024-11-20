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
library(kableExtra)
library(mice)
library(ggplot2)

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

run_scripts <- 0 # no=0, yes=1

# TODO:
#-------------------------
# Run the files
#-------------------------
if (run_scripts == 1) {
	source(here("scripts", "helpers", "utils.R"))
	source(here("scripts", "1_latent_coefs.R"))
	source(here("scripts", "2_anchoring.R"))
	source(here("scripts", "3_valueset.R"))
	source(here("scripts", "4_heterogeneity.R"))
	source(here("scripts", "5_latex_graphs.R"))
	# source(here("scripts", "6_latex_tables.R"))
	# source(here("scripts", "7_comparison.R"))
	# source(here("scripts", "8_kmeans.R"))
	#TODO: Save image to prevent rerunning scripts
	save.image(here("data", "processed", "image.RData"))
}

# Load final image after running scripts
load(here("data", "processed", "image.RData"))
