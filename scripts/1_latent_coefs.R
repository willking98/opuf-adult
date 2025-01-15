# ----------------------------
# OPUF ADULT 1. Latent Coefficient Estimation Script
# Will King
# Newcastle University
# 22 August 2024
# ----------------------------

# Bring in data
data <- read.csv(here("data", "raw", "OPUF_DATA.csv")) # Replace this with the final data download from OPUF

# Remove demo/practice responses
# demo_responses <- read.csv("./Data/Demo_IDs.csv")
demo_responses <- read.csv(here("data", "processed", "Demo_IDs.csv"))
data <- anti_join(data, demo_responses, by = "sessionId")

# Initialize a list to store the resulting matrices
results_list <- list()
domain_weighting <- list()

# Loop through each row of the data
for (i in 1:nrow(data)) {
  # Manipulate data into vectors to take the outer product as per paper
  v_tired <- as.numeric(data[i, c(
    "opuf_levelRatings_tired_0", "opuf_levelRatings_tired_1",
    "opuf_levelRatings_tired_2", "opuf_levelRatings_tired_3",
    "opuf_levelRatings_tired_4"
  )])

  v_walk <- as.numeric(data[i, c(
    "opuf_levelRatings_walk_0", "opuf_levelRatings_walk_1",
    "opuf_levelRatings_walk_2", "opuf_levelRatings_walk_3",
    "opuf_levelRatings_walk_4"
  )])

  v_sport <- as.numeric(data[i, c(
    "opuf_levelRatings_sports_0", "opuf_levelRatings_sports_1",
    "opuf_levelRatings_sports_2", "opuf_levelRatings_sports_3",
    "opuf_levelRatings_sports_4"
  )])

  v_conc <- as.numeric(data[i, c(
    "opuf_levelRatings_concentration_0", "opuf_levelRatings_concentration_1",
    "opuf_levelRatings_concentration_2", "opuf_levelRatings_concentration_3",
    "opuf_levelRatings_concentration_4"
  )])

  v_embarrass <- as.numeric(data[i, c(
    "opuf_levelRatings_embarrassment_0", "opuf_levelRatings_embarrassment_1",
    "opuf_levelRatings_embarrassment_2", "opuf_levelRatings_embarrassment_3",
    "opuf_levelRatings_embarrassment_4"
  )])

  v_unhappy <- as.numeric(data[i, c(
    "opuf_levelRatings_unhappiness_0", "opuf_levelRatings_unhappiness_1",
    "opuf_levelRatings_unhappiness_2", "opuf_levelRatings_unhappiness_3",
    "opuf_levelRatings_unhappiness_4"
  )])

  v_treat <- as.numeric(data[i, c(
    "opuf_levelRatings_treat_0", "opuf_levelRatings_treat_1",
    "opuf_levelRatings_treat_2", "opuf_levelRatings_treat_3",
    "opuf_levelRatings_treat_4"
  )])

  # Assign level labels
  lvl_labels <- c("Never", "Almost Never", "Sometimes", "Often", "Always")
  names(v_tired) <- lvl_labels
  names(v_walk) <- lvl_labels
  names(v_sport) <- lvl_labels
  names(v_conc) <- lvl_labels
  names(v_embarrass) <- lvl_labels
  names(v_unhappy) <- lvl_labels
  names(v_treat) <- lvl_labels

  # Dimension labels
  dim_labels <- c("Tired", "Walking", "Sports", "Concentration", "Embarrassment", "Unhappiness", "Treated Differently")

  # Dimension weights as vector
  dimension_weights <- as.numeric(data[i, c(
    "opuf_swingWeights_tired", "opuf_swingWeights_walk",
    "opuf_swingWeights_sports", "opuf_swingWeights_concentration",
    "opuf_swingWeights_embarrassment", "opuf_swingWeights_unhappiness",
    "opuf_swingWeights_treat"
  )])

  names(dimension_weights) <- dim_labels

  # Rescale levels to 0-1
  v_levels <- list(v_tired, v_walk, v_sport, v_conc, v_embarrass, v_unhappy, v_treat)
  v_scaled <- lapply(v_levels, function(x) x / 100)

  # Normalising dimension weights
  v_dim <- dimension_weights / sum(dimension_weights) # Referred to as w in article
  # sum(v_dim) # Uncomment this if you need to check the sum

  # Combine dimension weights with level ratings
  m <- mapply(function(v, w) as.numeric(v) * as.numeric(w), v_scaled, v_dim)
  colnames(m) <- dim_labels
  rownames(m) <- lvl_labels

  # Store the resulting matrix in the list
  results_list[[i]] <- m

  # Store domain weighting in matrix
  domain_weighting[[i]] <- v_dim
}

domain_matrix <- matrix(0, nrow = 0, ncol = 7)
for (i in domain_weighting) {
  domain_matrix <- domain_matrix + i
}

# Initialize a matrix to store the sum of all matrices
sum_matrix <- matrix(0, nrow = 5, ncol = 7)

# Sum all matrices
for (m in results_list) {
  sum_matrix <- sum_matrix + m
}

# Divide the sum by the number of matrices to get the average
average_matrix <- sum_matrix / length(results_list)

results_list_df <- as.data.frame(t(sapply(results_list, as.vector)))

############################################################################
############################################################################
# Objects from this script are:
# results_list containing each persons individual latent coefficient matrix
# average_matrix mean of all results_list showing mean latent coef matrix
############################################################################
############################################################################
print("Latent Coefs Script Successfully Run")
