# ---------------------------------------------
# OPUF ADULT 5. Latex Tables Script
# Will King
# Newcastle University
# 24 August 2024
# ---------------------------------------------
source("5_latex_graphs.R")
library(xtable)
# ---------------------------------------------
# Tables
# ---------------------------------------------

# Big mean latent coefficients table
xtable(t(average_matrix), digits = 3)

# Value set table
xtable(anchored_matrix, digits = 3)

# PERMANOVA table
xtable(permanova_main, digits = 3)

# Time
# Convert start time from milliseconds to POSIXct
data$start_time <- as.POSIXct(data$timeTracker_surveyStartTime / 1000, origin = "1970-01-01", tz = "Europe/London")

data$start_time_minutes <- as.POSIXct(((data$timeTracker_surveyStartTime)/1000), origin="1970-01-01", tz="Europe/London")
data$time_taken_minutes <- as.numeric(as.POSIXct(((data$timeTracker_surveyEndTime)/1000), origin="1970-01-01", tz="Europe/London") - as.POSIXct(((data$timeTracker_surveyStartTime)/1000), origin="1970-01-01", tz="Europe/London"))

# Calculate time taken in seconds
data$time_taken <- as.numeric(
  as.POSIXct(data$timeTracker_surveyEndTime / 1000, origin = "1970-01-01", tz = "Europe/London") -
  as.POSIXct(data$timeTracker_surveyStartTime / 1000, origin = "1970-01-01", tz = "Europe/London"),
  units = "secs"
)

time_tab <- matrix(NA, nrow = 9, ncol = 5)
    
time_tab[1,] <- c(
  "WAItE",
  paste(round(mean(data$timeTracker_EPRO1_seconds), 1), " (", round(sd(data$timeTracker_EPRO1_seconds), 1), ")", sep = ""),
  paste(round(median(data$timeTracker_EPRO1_seconds), 1), " (", round(quantile(data$timeTracker_EPRO1_seconds, 0.25), 1), "; ", round(quantile(data$timeTracker_EPRO1_seconds, 0.75), 1), ")", sep = ""),
  round(min(data$timeTracker_EPRO1_seconds), 1),
  round(max(data$timeTracker_EPRO1_seconds), 1)
)

time_tab[2,] <- c(
  "Dimension ranking",
  paste(round(mean(data$timeTracker_OPUFRanking1_seconds), 1), " (", round(sd(data$timeTracker_OPUFRanking1_seconds), 1), ")", sep = ""),
  paste(round(median(data$timeTracker_OPUFRanking1_seconds), 1), " (", round(quantile(data$timeTracker_OPUFRanking1_seconds, 0.25), 1), "; ", round(quantile(data$timeTracker_OPUFRanking1_seconds, 0.75), 1), ")", sep = ""),
  round(min(data$timeTracker_OPUFRanking1_seconds), 1),
  round(max(data$timeTracker_OPUFRanking1_seconds), 1)
)

time_tab[3,] <- c(
  "Dimension weighting",
  paste(round(mean(data$timeTracker_OPUFSwingWeight1_seconds), 1), " (", round(sd(data$timeTracker_OPUFSwingWeight1_seconds), 1), ")", sep = ""),
  paste(round(median(data$timeTracker_OPUFSwingWeight1_seconds), 1), " (", round(quantile(data$timeTracker_OPUFSwingWeight1_seconds, 0.25), 1), "; ", round(quantile(data$timeTracker_OPUFSwingWeight1_seconds, 0.75), 1), ")", sep = ""),
  round(min(data$timeTracker_OPUFSwingWeight1_seconds), 1),
  round(max(data$timeTracker_OPUFSwingWeight1_seconds), 1)
)

time_tab[4,] <- c(
  "Level rating",
  paste(round(mean(data$timeTracker_OPUFLevelRating_seconds, na.rm=T), 1), " (", round(sd(data$timeTracker_OPUFLevelRating_seconds, na.rm=T), 1), ")", sep = ""),
  paste(round(median(data$timeTracker_OPUFLevelRating_seconds, na.rm=T), 1), " (", round(quantile(data$timeTracker_OPUFLevelRating_seconds, 0.25, na.rm=T), 1), "; ", round(quantile(data$timeTracker_OPUFLevelRating_seconds, 0.75, na.rm=T), 1), ")", sep = ""),
  round(min(data$timeTracker_OPUFLevelRating_seconds, na.rm=T), 1),
  round(max(data$timeTracker_OPUFLevelRating_seconds, na.rm=T), 1)
)

time_tab[5,] <- c(
  "PITS vs death",
  paste(round(mean(data$timeTracker_OPUFDeadChoice_seconds), 1), " (", round(sd(data$timeTracker_OPUFDeadChoice_seconds), 1), ")", sep = ""),
  paste(round(median(data$timeTracker_OPUFDeadChoice_seconds), 1), " (", round(quantile(data$timeTracker_OPUFDeadChoice_seconds, 0.25), 1), "; ", round(quantile(data$timeTracker_OPUFDeadChoice_seconds, 0.75), 1), ")", sep = ""),
  round(min(data$timeTracker_OPUFDeadChoice_seconds), 1),
  round(max(data$timeTracker_OPUFDeadChoice_seconds), 1)
)

time_tab[6,] <- c(
  "PITS-VAS",
  paste(round(mean(data$timeTracker_OPUFVasAnchoring_seconds), 1), " (", round(sd(data$timeTracker_OPUFVasAnchoring_seconds), 1), ")", sep = ""),
  paste(round(median(data$timeTracker_OPUFVasAnchoring_seconds), 1), " (", round(quantile(data$timeTracker_OPUFVasAnchoring_seconds, 0.25), 1), "; ", round(quantile(data$timeTracker_OPUFVasAnchoring_seconds, 0.75), 1), ")", sep = ""),
  round(min(data$timeTracker_OPUFVasAnchoring_seconds), 1),
  round(max(data$timeTracker_OPUFVasAnchoring_seconds), 1)
)

time_tab[7,] <- c(
  "PITS-VAS",
  paste(round(mean(data$timeTracker_OPUFVasAnchoring_seconds), 1), " (", round(sd(data$timeTracker_OPUFVasAnchoring_seconds), 1), ")", sep = ""),
  paste(round(median(data$timeTracker_OPUFVasAnchoring_seconds), 1), " (", round(quantile(data$timeTracker_OPUFVasAnchoring_seconds, 0.25), 1), "; ", round(quantile(data$timeTracker_OPUFVasAnchoring_seconds, 0.75), 1), ")", sep = ""),
  round(min(data$timeTracker_OPUFVasAnchoring_seconds), 1),
  round(max(data$timeTracker_OPUFVasAnchoring_seconds), 1)
)

time_tab[8,] <- c(
  "Total",
  paste(round(mean(data$time_taken), 1), " (", round(sd(data$time_taken), 1), ")", sep = ""),
  paste(round(median(data$time_taken), 1), " (", round(quantile(data$time_taken, 0.25), 1), "; ", round(quantile(data$time_taken, 0.75), 1), ")", sep = ""),
  round(min(data$time_taken), 1),
  round(max(data$time_taken), 1)
)

time_tab[9,] <- c(
  "Total",
  paste(round(mean(data$time_taken_minutes), 2), " (", round(sd(data$time_taken_minutes), 2), ")", sep = ""),
  paste(round(median(data$time_taken_minutes), 2), " (", round(quantile(data$time_taken_minutes, 0.25), 2), "; ", round(quantile(data$time_taken_minutes, 0.75), 2), ")", sep = ""),
  round(min(data$time_taken_minutes), 2),
  round(max(data$time_taken_minutes), 2)
)

# Optionally, set the column names
colnames(time_tab) <- c("Section", "Mean (SD)", "Median (Q1; Q3)", "Min", "Max")  # adjusted the column name

xtable(time_tab)


# level ratings

level_tab <- matrix(NA, nrow = 21, ncol = 5)
    
level_tab[1,] <- c(
  "Almost never",
  paste(round(mean(data$opuf_levelRatings_tired_1), 1), " (", round(sd(data$opuf_levelRatings_tired_1), 1), ")", sep = ""),
  paste(round(median(data$opuf_levelRatings_tired_1), 1), " (", round(quantile(data$opuf_levelRatings_tired_1, 0.25), 1), "; ", round(quantile(data$opuf_levelRatings_tired_1, 0.75), 1), ")", sep = ""),
  round(min(data$opuf_levelRatings_tired_1), 1),
  round(max(data$opuf_levelRatings_tired_1), 1)
)
level_tab[2,] <- c(
  "Sometimes",
  paste(round(mean(data$opuf_levelRatings_tired_2), 1), " (", round(sd(data$opuf_levelRatings_tired_2), 1), ")", sep = ""),
  paste(round(median(data$opuf_levelRatings_tired_2), 1), " (", round(quantile(data$opuf_levelRatings_tired_2, 0.25), 1), "; ", round(quantile(data$opuf_levelRatings_tired_2, 0.75), 1), ")", sep = ""),
  round(min(data$opuf_levelRatings_tired_2), 1),
  round(max(data$opuf_levelRatings_tired_2), 1)
)
level_tab[3,] <- c(
  "Often",
  paste(round(mean(data$opuf_levelRatings_tired_3), 1), " (", round(sd(data$opuf_levelRatings_tired_3), 1), ")", sep = ""),
  paste(round(median(data$opuf_levelRatings_tired_3), 1), " (", round(quantile(data$opuf_levelRatings_tired_3, 0.25), 1), "; ", round(quantile(data$opuf_levelRatings_tired_3, 0.75), 1), ")", sep = ""),
  round(min(data$opuf_levelRatings_tired_3), 1),
  round(max(data$opuf_levelRatings_tired_3), 1)
)
level_tab[4,] <- c(
  "Almost never",
  paste(round(mean(data$opuf_levelRatings_walk_1), 1), " (", round(sd(data$opuf_levelRatings_walk_1), 1), ")", sep = ""),
  paste(round(median(data$opuf_levelRatings_walk_1), 1), " (", round(quantile(data$opuf_levelRatings_walk_1, 0.25), 1), "; ", round(quantile(data$opuf_levelRatings_walk_1, 0.75), 1), ")", sep = ""),
  round(min(data$opuf_levelRatings_walk_1), 1),
  round(max(data$opuf_levelRatings_walk_1), 1)
)
level_tab[5,] <- c(
  "Sometimes",
  paste(round(mean(data$opuf_levelRatings_walk_2), 1), " (", round(sd(data$opuf_levelRatings_walk_2), 1), ")", sep = ""),
  paste(round(median(data$opuf_levelRatings_walk_2), 1), " (", round(quantile(data$opuf_levelRatings_walk_2, 0.25), 1), "; ", round(quantile(data$opuf_levelRatings_walk_2, 0.75), 1), ")", sep = ""),
  round(min(data$opuf_levelRatings_walk_2), 1),
  round(max(data$opuf_levelRatings_walk_2), 1)
)
level_tab[6,] <- c(
  "Often",
  paste(round(mean(data$opuf_levelRatings_walk_3), 1), " (", round(sd(data$opuf_levelRatings_walk_3), 1), ")", sep = ""),
  paste(round(median(data$opuf_levelRatings_walk_3), 1), " (", round(quantile(data$opuf_levelRatings_walk_3, 0.25), 1), "; ", round(quantile(data$opuf_levelRatings_walk_3, 0.75), 1), ")", sep = ""),
  round(min(data$opuf_levelRatings_walk_3), 1),
  round(max(data$opuf_levelRatings_walk_3), 1)
)
level_tab[7,] <- c(
  "Almost never",
  paste(round(mean(data$opuf_levelRatings_sports_1), 1), " (", round(sd(data$opuf_levelRatings_sports_1), 1), ")", sep = ""),
  paste(round(median(data$opuf_levelRatings_sports_1), 1), " (", round(quantile(data$opuf_levelRatings_sports_1, 0.25), 1), "; ", round(quantile(data$opuf_levelRatings_sports_1, 0.75), 1), ")", sep = ""),
  round(min(data$opuf_levelRatings_sports_1), 1),
  round(max(data$opuf_levelRatings_sports_1), 1)
)
level_tab[8,] <- c(
  "Sometimes",
  paste(round(mean(data$opuf_levelRatings_sports_2), 1), " (", round(sd(data$opuf_levelRatings_sports_2), 1), ")", sep = ""),
  paste(round(median(data$opuf_levelRatings_sports_2), 1), " (", round(quantile(data$opuf_levelRatings_sports_2, 0.25), 1), "; ", round(quantile(data$opuf_levelRatings_sports_2, 0.75), 1), ")", sep = ""),
  round(min(data$opuf_levelRatings_sports_2), 1),
  round(max(data$opuf_levelRatings_sports_2), 1)
)
level_tab[9,] <- c(
  "Often",
  paste(round(mean(data$opuf_levelRatings_sports_3), 1), " (", round(sd(data$opuf_levelRatings_sports_3), 1), ")", sep = ""),
  paste(round(median(data$opuf_levelRatings_sports_3), 1), " (", round(quantile(data$opuf_levelRatings_sports_3, 0.25), 1), "; ", round(quantile(data$opuf_levelRatings_sports_3, 0.75), 1), ")", sep = ""),
  round(min(data$opuf_levelRatings_sports_3), 1),
  round(max(data$opuf_levelRatings_sports_3), 1)
)
level_tab[10,] <- c(
  "Almost never",
  paste(round(mean(data$opuf_levelRatings_concentration_1), 1), " (", round(sd(data$opuf_levelRatings_concentration_1), 1), ")", sep = ""),
  paste(round(median(data$opuf_levelRatings_concentration_1), 1), " (", round(quantile(data$opuf_levelRatings_concentration_1, 0.25), 1), "; ", round(quantile(data$opuf_levelRatings_concentration_1, 0.75), 1), ")", sep = ""),
  round(min(data$opuf_levelRatings_concentration_1), 1),
  round(max(data$opuf_levelRatings_concentration_1), 1)
)
level_tab[11,] <- c(
  "Sometimes",
  paste(round(mean(data$opuf_levelRatings_concentration_2), 1), " (", round(sd(data$opuf_levelRatings_concentration_2), 1), ")", sep = ""),
  paste(round(median(data$opuf_levelRatings_concentration_2), 1), " (", round(quantile(data$opuf_levelRatings_concentration_2, 0.25), 1), "; ", round(quantile(data$opuf_levelRatings_concentration_2, 0.75), 1), ")", sep = ""),
  round(min(data$opuf_levelRatings_concentration_2), 1),
  round(max(data$opuf_levelRatings_concentration_2), 1)
)
level_tab[12,] <- c(
  "Often",
  paste(round(mean(data$opuf_levelRatings_concentration_3), 1), " (", round(sd(data$opuf_levelRatings_concentration_3), 1), ")", sep = ""),
  paste(round(median(data$opuf_levelRatings_concentration_3), 1), " (", round(quantile(data$opuf_levelRatings_concentration_3, 0.25), 1), "; ", round(quantile(data$opuf_levelRatings_concentration_3, 0.75), 1), ")", sep = ""),
  round(min(data$opuf_levelRatings_concentration_3), 1),
  round(max(data$opuf_levelRatings_concentration_3), 1)
)
level_tab[13,] <- c(
  "Almost never",
  paste(round(mean(data$opuf_levelRatings_embarrassment_1), 1), " (", round(sd(data$opuf_levelRatings_embarrassment_1), 1), ")", sep = ""),
  paste(round(median(data$opuf_levelRatings_embarrassment_1), 1), " (", round(quantile(data$opuf_levelRatings_embarrassment_1, 0.25), 1), "; ", round(quantile(data$opuf_levelRatings_embarrassment_1, 0.75), 1), ")", sep = ""),
  round(min(data$opuf_levelRatings_embarrassment_1), 1),
  round(max(data$opuf_levelRatings_embarrassment_1), 1)
)
level_tab[14,] <- c(
  "Sometimes",
  paste(round(mean(data$opuf_levelRatings_embarrassment_2), 1), " (", round(sd(data$opuf_levelRatings_embarrassment_2), 1), ")", sep = ""),
  paste(round(median(data$opuf_levelRatings_embarrassment_2), 1), " (", round(quantile(data$opuf_levelRatings_embarrassment_2, 0.25), 1), "; ", round(quantile(data$opuf_levelRatings_embarrassment_2, 0.75), 1), ")", sep = ""),
  round(min(data$opuf_levelRatings_embarrassment_2), 1),
  round(max(data$opuf_levelRatings_embarrassment_2), 1)
)
level_tab[15,] <- c(
  "Often",
  paste(round(mean(data$opuf_levelRatings_embarrassment_3), 1), " (", round(sd(data$opuf_levelRatings_embarrassment_3), 1), ")", sep = ""),
  paste(round(median(data$opuf_levelRatings_embarrassment_3), 1), " (", round(quantile(data$opuf_levelRatings_embarrassment_3, 0.25), 1), "; ", round(quantile(data$opuf_levelRatings_embarrassment_3, 0.75), 1), ")", sep = ""),
  round(min(data$opuf_levelRatings_embarrassment_3), 1),
  round(max(data$opuf_levelRatings_embarrassment_3), 1)
)
level_tab[16,] <- c(
  "Almost never",
  paste(round(mean(data$opuf_levelRatings_unhappiness_1), 1), " (", round(sd(data$opuf_levelRatings_unhappiness_1), 1), ")", sep = ""),
  paste(round(median(data$opuf_levelRatings_unhappiness_1), 1), " (", round(quantile(data$opuf_levelRatings_unhappiness_1, 0.25), 1), "; ", round(quantile(data$opuf_levelRatings_unhappiness_1, 0.75), 1), ")", sep = ""),
  round(min(data$opuf_levelRatings_unhappiness_1), 1),
  round(max(data$opuf_levelRatings_unhappiness_1), 1)
)
level_tab[17,] <- c(
  "Sometimes",
  paste(round(mean(data$opuf_levelRatings_unhappiness_2), 1), " (", round(sd(data$opuf_levelRatings_unhappiness_2), 1), ")", sep = ""),
  paste(round(median(data$opuf_levelRatings_unhappiness_2), 1), " (", round(quantile(data$opuf_levelRatings_unhappiness_2, 0.25), 1), "; ", round(quantile(data$opuf_levelRatings_unhappiness_2, 0.75), 1), ")", sep = ""),
  round(min(data$opuf_levelRatings_unhappiness_2), 1),
  round(max(data$opuf_levelRatings_unhappiness_2), 1)
)
level_tab[18,] <- c(
  "Often",
  paste(round(mean(data$opuf_levelRatings_unhappiness_3), 1), " (", round(sd(data$opuf_levelRatings_unhappiness_3), 1), ")", sep = ""),
  paste(round(median(data$opuf_levelRatings_unhappiness_3), 1), " (", round(quantile(data$opuf_levelRatings_unhappiness_3, 0.25), 1), "; ", round(quantile(data$opuf_levelRatings_unhappiness_3, 0.75), 1), ")", sep = ""),
  round(min(data$opuf_levelRatings_unhappiness_3), 1),
  round(max(data$opuf_levelRatings_unhappiness_3), 1)
)
level_tab[19,] <- c(
  "Almost never",
  paste(round(mean(data$opuf_levelRatings_treat_1), 1), " (", round(sd(data$opuf_levelRatings_treat_1), 1), ")", sep = ""),
  paste(round(median(data$opuf_levelRatings_treat_1), 1), " (", round(quantile(data$opuf_levelRatings_treat_1, 0.25), 1), "; ", round(quantile(data$opuf_levelRatings_treat_1, 0.75), 1), ")", sep = ""),
  round(min(data$opuf_levelRatings_treat_1), 1),
  round(max(data$opuf_levelRatings_treat_1), 1)
)
level_tab[20,] <- c(
  "Sometimes",
  paste(round(mean(data$opuf_levelRatings_treat_2), 1), " (", round(sd(data$opuf_levelRatings_treat_2), 1), ")", sep = ""),
  paste(round(median(data$opuf_levelRatings_treat_2), 1), " (", round(quantile(data$opuf_levelRatings_treat_2, 0.25), 1), "; ", round(quantile(data$opuf_levelRatings_treat_2, 0.75), 1), ")", sep = ""),
  round(min(data$opuf_levelRatings_treat_2), 1),
  round(max(data$opuf_levelRatings_treat_2), 1)
)
level_tab[21,] <- c(
  "Often",
  paste(round(mean(data$opuf_levelRatings_treat_3), 1), " (", round(sd(data$opuf_levelRatings_treat_3), 1), ")", sep = ""),
  paste(round(median(data$opuf_levelRatings_treat_3), 1), " (", round(quantile(data$opuf_levelRatings_treat_3, 0.25), 1), "; ", round(quantile(data$opuf_levelRatings_treat_3, 0.75), 1), ")", sep = ""),
  round(min(data$opuf_levelRatings_treat_3), 1),
  round(max(data$opuf_levelRatings_treat_3), 1)
)

xtable(level_tab)

# Define a function to calculate and format the statistics
calculate_stats <- function(data_column) {
  mean_sd <- paste(round(mean(data_column), 3), " (", round(sd(data_column), 3), ")", sep = "")
  median_q <- paste(round(median(data_column), 1), " (", round(quantile(data_column, 0.25), 1), "; ", round(quantile(data_column, 0.75), 1), ")", sep = "")
  c(mean_sd, median_q, round(min(data_column), 1), round(max(data_column), 1))
}


# Initialize the level_tab matrix
level_tab <- matrix(NA, nrow = 21, ncol = 5)

# List of categories
categories <- c("tired", "walk", "sports", "concentration", "embarrassment", "unhappiness", "treat")

# Fill the matrix using loops
row_index <- 1
for (category in categories) {
  for (i in 1:3) {
    level_tab[row_index, ] <- c(c("Almost never", "Sometimes", "Often")[i], calculate_stats(data[[paste0("opuf_levelRatings_", category, "_", i)]]))
    row_index <- row_index + 1
  }
}

# domain weighting table
domain_tab <- matrix(NA, nrow = 13, ncol = 5)
domain_tab[1,] <- c("Tired", calculate_stats(data$opuf_swingWeights_tired))
domain_tab[2,] <- c("Walking", calculate_stats(data$opuf_swingWeights_walk))
domain_tab[3,] <- c("Sports", calculate_stats(data$opuf_swingWeights_sports))
domain_tab[4,] <- c("Concentration", calculate_stats(data$opuf_swingWeights_concentration))
domain_tab[5,] <- c("Embarrassment", calculate_stats(data$opuf_swingWeights_embarrassment))
domain_tab[6,] <- c("Unhappiness", calculate_stats(data$opuf_swingWeights_unhappiness))
domain_tab[7,] <- c("Treated differently", calculate_stats(data$opuf_swingWeights_treat))

# fix anchorpoint data
data$preferred_pits[data$opuf_anchorPoint==""] <- NA
data$preferred_pits[data$opuf_anchorPoint=="dead"] <- 1
data$preferred_pits[data$opuf_anchorPoint=="pits"] <- 0
preferred_pits <- data$preferred_pits[!is.na(data$preferred_pits)]

pits_vas <- ifelse(data$opuf_anchorPoint=="dead", data$opuf_anchorVal, NA)
pits_vas <- pits_vas[!is.na(pits_vas)]
dead_vas <- ifelse(data$opuf_anchorPoint=="pits", data$opuf_anchorVal, NA)
dead_vas <- dead_vas[!is.na(dead_vas)]
opuf_pitsUtility <- data$opuf_pitsUtility
opuf_pitsUtility <- opuf_pitsUtility[!is.na(opuf_pitsUtility)]
censored_opuf_pitsUtility <- ifelse(opuf_pitsUtility < -1, -1, opuf_pitsUtility) 


domain_tab[8,] <- c("PITS preferred to death", calculate_stats(preferred_pits))
domain_tab[9,] <- c("PITS-VAS", calculate_stats(pits_vas))
domain_tab[10,] <- c("Dead-VAS", calculate_stats(dead_vas))
domain_tab[11,] <- c("PITS VAS uncensored", calculate_stats(opuf_pitsUtility))
domain_tab[12,] <- c("PITS VAS censored", calculate_stats(censored_opuf_pitsUtility))

domain_tab[13,] <- c("PITS Utility Value", calculate_stats(data$PITS))

xtable(domain_tab)

# Coefficients table
#############################################################################
# Bootstrapping 
#############################################################################
#setseed
#############################################################################
#setseed
set.seed(1998)
# Set the number of bootstrap iterations
n_iterations <- 10000

# Initialize a list to store the mean matrices from each bootstrap iteration
bootstrap_means <- list()

# Bootstrap loop
for (n in 1:n_iterations) {
  # Sample with replacement from the results_list
  sample_indices <- sample(1:length(results_list), replace = TRUE)
  bootstrap_sample <- results_list[sample_indices]
  
  # Initialize a matrix to store the sum of the bootstrap sample matrices
  bootstrap_sum_matrix <- matrix(0, nrow = 7, ncol = 4)  # Adjusted to 4 columns
  
  # Sum all matrices in the bootstrap sample
  for (m in bootstrap_sample) {
    bootstrap_sum_matrix <- bootstrap_sum_matrix + m
  }
  
  # Calculate the mean matrix for this bootstrap sample
  bootstrap_mean_matrix <- bootstrap_sum_matrix / length(bootstrap_sample)
  # Anchor it
  bootstrap_mean_matrix <- bootstrap_mean_matrix * (1-anchor) 
  
  # Store the bootstrap mean matrix
  bootstrap_means[[n]] <- bootstrap_mean_matrix
}

# Convert the list of bootstrap mean matrices into a 3D array
bootstrap_array <- simplify2array(bootstrap_means)

# Initialize matrices to store the required statistics
mean_matrix <- apply(bootstrap_array, c(1, 2), mean)
median_matrix <- apply(bootstrap_array, c(1, 2), median)
q1_matrix <- apply(bootstrap_array, c(1, 2), quantile, probs = 0.25)
q3_matrix <- apply(bootstrap_array, c(1, 2), quantile, probs = 0.75)
min_matrix <- apply(bootstrap_array, c(1, 2), min)
max_matrix <- apply(bootstrap_array, c(1, 2), max)

# Calculate 95% confidence intervals
ci_lower <- apply(bootstrap_array, c(1, 2), quantile, probs = 0.025)
ci_upper <- apply(bootstrap_array, c(1, 2), quantile, probs = 0.975)

# Initialize an empty list to store each row of the final table
final_table <- list()

# Define the domain names and the levels
domains <- c("tired", "walk", "sports", "concentrate", "embarrassment", "unhappiness", "treated differently")
levels <- c("almost never", "sometimes", "often", "always")

# Iterate through the rows and columns of the matrices
for (i in 1:nrow(mean_matrix)) {
  for (j in 1:ncol(mean_matrix)) {
    row_label <- paste0(domains[i], ", ", levels[j])
    mean_ci <- paste0(round(mean_matrix[i, j], 3), " (", round(ci_lower[i, j], 3), "; ", round(ci_upper[i, j], 3), ")")
    median_q1_q3 <- paste0(round(median_matrix[i, j], 3), " (", round(q1_matrix[i, j], 3), "; ", round(q3_matrix[i, j], 3), ")")
    min_val <- round(min_matrix[i, j], 3)
    max_val <- round(max_matrix[i, j], 3)
    
    final_table[[length(final_table) + 1]] <- c(row_label, mean_ci, median_q1_q3, min_val, max_val)
  }
}

# Convert the final_table list to a data frame
final_df <- as.data.frame(do.call(rbind, final_table), stringsAsFactors = FALSE)
colnames(final_df) <- c("Dimension Level", "Mean (95% CI)", "Median (Q1; Q3)", "Min", "Max")

# Print the final table
print(final_df)

xtable(final_df)



# Convert the list of bootstrap mean matrices to an array for easy manipulation
bootstrap_array <- array(unlist(bootstrap_means), 
                         dim = c(5, 7, n_iterations))

# Calculate the confidence intervals (e.g., 2.5th and 97.5th percentiles) for each element in the matrix
CI_lower <- apply(bootstrap_array, c(1, 2), quantile, probs = 0.025)
CI_upper <- apply(bootstrap_array, c(1, 2), quantile, probs = 0.975)

# min
min <- apply(bootstrap_array, c(1, 2), min)
# max
max <- apply(bootstrap_array, c(1, 2), max)
# max
median <- apply(bootstrap_array, c(1, 2), median)
# Q1
Q1 <- apply(bootstrap_array, c(1, 2), quantile, probs = 0.25)
Q3 <- apply(bootstrap_array, c(1, 2), quantile, probs = 0.75)


# Rescale CIs and average_matrix using PITS utility
#CI_lower <- CI_lower * (1 - censored_PITS)
#CI_upper <- CI_upper * (1 - censored_PITS)
#average_matrix <- average_matrix * (1 - censored_PITS)

# Combine lower and upper CI bounds into a single matrix for convenience
CI_matrix <- list(lower = CI_lower, upper = CI_upper)

# You now have CI_matrix containing lower and upper confidence intervals for each cell in the matrix.

# Create a new matrix to store the formatted results
formatted_matrix <- matrix(NA, nrow = 5, ncol = 7)

# Loop through each element to format it as "mean (CI_lower to CI_upper)"
for (i in 1:5) {
  for (j in 1:7) {
    formatted_matrix[i, j] <- paste0(
      round(anchored_matrix[i, j], 3), # Round the mean to 3 decimal places for readability
      " (",
      round(CI_lower[i, j], 3), # Round the CI_lower value
      "; ",
      round(CI_upper[i, j], 3), # Round the CI_upper value
      ")"
    )
  }
}

formatted_matrix <- formatted_matrix[2:5,]

# formatted_matrix now contains the mean and confidence intervals in the desired format
xtable(formatted_matrix)


