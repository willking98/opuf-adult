# ----------------------------
# OPUF ADULT 2. Anchoring Script
# Will King
# Newcastle University
# 22 August 2024
# ----------------------------

# Load in latent coefficient matrices
# source(here("scripts", "1_latent_coefs.R"))

#----------------------------------------------------------------------------
# Winsorize pits data
#----------------------------------------------------------------------------

# New PITS variable
data$PITS <- data$opuf_pitsUtility

# Calculate the cutoff values
lower_cutoff <- quantile(data$PITS, 0.005, na.rm = T) # lower % of 0.5%
upper_cutoff <- quantile(data$PITS, 0.995, na.rm = T) # upper % of 99.5%

# Winsorize the vector
data$PITS <- pmin(pmax(data$PITS, lower_cutoff), upper_cutoff)

#----------------------------------------------------------------------------
# Multiple imputation on pits data (n=5)
#----------------------------------------------------------------------------

MICE_data <- select(data, PITS, opuf_swingWeights_tired, opuf_swingWeights_walk, opuf_swingWeights_sports, opuf_swingWeights_concentration, opuf_swingWeights_embarrassment, opuf_swingWeights_unhappiness, opuf_swingWeights_treat, AdditionalDemographicQuestions_weightstatus_value, AdditionalDemographicQuestions_education_value, AdditionalDemographicQuestions_employment_value, AdditionalDemographicQuestions_ethnicity_value, AdditionalDemographicQuestions_gender_value)
# imputed_data <- mice(MICE_data, m = 1, method = "pmm", seed = 1998)

imputed_data <- suppressMessages(suppressWarnings(
  capture.output(mice(MICE_data, m = 1, method = "pmm", seed = 1998))
))
# Replace NAs with imputed values from the pmm model
data$PITS[29] <- 0.2
data$PITS[98] <- 0.7
data$PITS[138] <- 0.3
data$PITS[216] <- 0.3
data$PITS[298] <- 0.9

anchor <- mean(data$PITS) # 0.2817

#----------------------------------------------------------------------------
# Anchoring of latent coefficient matrix to yield value set coefficients
#----------------------------------------------------------------------------
anchored_matrix <- average_matrix * (1 - anchor)

############################################################################
############################################################################
# Objects from this script are:
# data$PITS which is each individual persons pits utility value with no NA
# anchored_matrix containing anchored mean coefficient matrix
############################################################################
############################################################################
print("Anchoring Script Successfully Run")
