# ----------------------------
# OPUF ADULT 3. Value set estimation
# Will King
# Newcastle University
# 22 August 2024
# ----------------------------
# source(here("scripts", "2_anchoring.R"))

# ------------------------------------------------------
# Generating the social value set for each health state
# ------------------------------------------------------
# Function to calculate health state score
calculate_score <- function(code, score_matrix) {
  # Convert code string into numeric vector (one digit per dimension)
  levels <- as.numeric(strsplit(code, "")[[1]])
  
  # Lookup scores in the score matrix
  scores <- mapply(function(level, dim) score_matrix[level, dim], levels, 1:7)
  
  # Calculate health state score
  health_state_score <- 1 - sum(scores)
  return(health_state_score)
}

# Example
calculate_score("5555555", anchored_matrix)
calculate_score("5555555", average_matrix)
calculate_score("5555555", results_list[[1]]) # Estimate health state score for person 1 this is unanchored and just based upon their individual latent coefficients

# Generate all possible health state codes
levels <- 1:5
dimensions <- 7
combinations <- expand.grid(rep(list(levels), dimensions))
health_state_codes <- apply(combinations, 1, paste0, collapse = "")
codes_df <- cbind(combinations, health_state_codes)

# Estimating the final value set
social_valueset <- sapply(health_state_codes, calculate_score, anchored_matrix)
social_valueset <- as.vector(social_valueset)

# Estimating the unanchored social valueset for EUD graph
unanchored_social_valueset <- sapply(health_state_codes, calculate_score, average_matrix)
unanchored_social_valueset <- as.vector(unanchored_social_valueset)


# -----------------------------------------------------------
# Generating value sets for each different waite study
# -----------------------------------------------------------
# Define the data
dcetto_matrix <- c(0, 0.064, 0.064, 0.064, 0.148, 0, 0.015,
          0.015, 0.054, 0.106, 0, 0.021, 0.021, 0.021,
          0.058, 0, 0.009, 0.053, 0.067, 0.130, 0, 0.007,
          0.025, 0.056, 0.069, 0, 0.001, 0.039, 0.076,
          0.145, 0, 0.010, 0.030, 0.075, 0.114)

# Create the matrix with 5 rows and 7 columns
dcetto_matrix <- matrix(dcetto_matrix, nrow = 5, ncol = 7, byrow = F)

# Column and row names
colnames(dcetto_matrix) <- colnames(average_matrix)
rownames(dcetto_matrix) <- rownames(average_matrix)

# Define the data
dcevas_matrix <- c(0, 0.059, 0.059, 0.059, 0.137, 0, 0.013,
            0.013, 0.050, 0.098, 0, 0.019, 0.019, 0.019,
            0.053, 0, 0.008, 0.049, 0.062, 0.120, 0, 0.007,
            0.023, 0.051, 0.064, 0, 0.001, 0.036, 0.070,
            0.134, 0, 0.009, 0.028, 0.069, 0.105)

# Create the matrix with 5 rows and 7 columns
dcevas_matrix <- matrix(dcevas_matrix, nrow = 5, ncol = 7, byrow = F)

# Column and row names
colnames(dcevas_matrix) <- colnames(average_matrix)
rownames(dcevas_matrix) <- rownames(average_matrix)


# mapping_valueset <- sapply(health_state_codes, calculate_score, mapping_matrix)
dcetto_valueset <- sapply(health_state_codes, calculate_score, dcetto_matrix)
dcevas_valueset <- sapply(health_state_codes, calculate_score, dcevas_matrix)

# -----------------------------------------------------------
# Generating the individual value sets for each health state
# -----------------------------------------------------------
latent_coeff_array <- as.array(results_list)
if (run_long_functions == 1) {
    # ------ Individually Anchored ----------

    # Anchor all individual latent coefficient matrices with individual pits utility values
    latent_coeff_array <- as.array(results_list)
    anchored_coef_array <- latent_coeff_array
    for(i in 1:300){
        anchored_coef_array[[i]] <- latent_coeff_array[[i]] * (1-data$PITS[i]) 
    }

    ind_value_sets <- matrix(NA, nrow = 78125, ncol = 300)
    colnames(ind_value_sets) <- data$userId

    # 12.5 minute run time on MacOS
    for(i in 1:300){
        ind_value_sets[,i] <- sapply(health_state_codes, calculate_score, anchored_coef_array[[i]])
        print(paste(round(i/3, 2), "%", sep = ""))
    }
    save(ind_value_sets, file = here("data", "processed", "ind_value_sets.RData"))
    # ------ Socially Anchored ----------

    # Anchor all individual latent coefficient matrices with social pits utility value
    latent_coeff_array <- as.array(results_list)
    s_anchored_coef_array <- latent_coeff_array
    for(i in 1:300){
        s_anchored_coef_array[[i]] <- latent_coeff_array[[i]] * (1-anchor) 
    }

    s_ind_value_sets <- matrix(NA, nrow = 78125, ncol = 300)
    colnames(s_ind_value_sets) <- data$userId

    # 12.5 minute run time on MacOS
    for(i in 1:300){
        s_ind_value_sets[,i] <- sapply(health_state_codes, calculate_score, s_anchored_coef_array[[i]])
        print(paste(round(i/3, 2), "%", sep = ""))
    }
    save(s_ind_value_sets, file = here("data", "processed", "s_ind_value_sets.RData"))
    # ------ Unanchored ----------

    # Unanchored
    utils_list <- matrix(NA, nrow = 78125, ncol = 300)
    for(i in 1:length(results_list)){
        utils_list[,i] <- sapply(health_state_codes, calculate_score, results_list[[i]])
        print(paste(i/3, "%", sep = ""))
    }
    save(utils_list, file = here("data", "processed", "utils_list.RData"))
}
load(here("data", "processed", "ind_value_sets.RData"))
load(here("data", "processed", "s_ind_value_sets.RData"))
load(here("data", "processed", "utils_list.RData"))

# -----------------------------------------------------------
# Generating the individual value sets for each health state
# -----------------------------------------------------------
############################################################################
############################################################################
# Objects from this script are:
# social_valueset which is the social utility value set for waite anchored at 0.282
# anchored_matrix containing anchored mean coefficient matrix
############################################################################
############################################################################
print("Valueset Script Successfully Run")
