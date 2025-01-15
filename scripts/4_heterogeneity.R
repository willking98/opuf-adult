# ----------------------------
# OPUF ADULT 4. Preference heterogeneity
# Will King
# Newcastle University
# 22 August 2024
# ----------------------------
# source("3_valueset.R")
# library(vegan)

# Merging in prolific data
prolific <- read.csv(here("data", "raw", "PROLIFIC_DATA.csv")) # Replace this with the final data download from PROLIFIC
prolific <- rename(prolific, userId = Participant.id)
data <- left_join(data, prolific, by = "userId") # All data together now with all variables and on n=300 sample

# Load in the big files
load(here("data", "processed", "ind_value_sets.RData"))
load(here("data", "processed", "s_ind_value_sets.RData"))
load(here("data", "processed", "utils_list.RData"))

if(run_long_functions==1){
  # EUD
  # Calculate the Euclidean distances between individual valuesets anchored with their own pits
  distance_vector <- dist(t(ind_value_sets), method = "euclidean")
  distance_matrix <- as.matrix(distance_vector)
  mean_eud <- mean(distance_vector)
  sd_eud <- sd(distance_vector)
  median_eud <- median(distance_vector)
  q1_eud <- quantile(distance_vector, prob = 0.25)
  q3_eud <- quantile(distance_vector, prob = 0.75)

  eud_summary <- c(mean_eud, sd_eud, median_eud, q1_eud, q3_eud)

  # EUD2
  # Calculate the Euclidean distances between individual valuesets anchored with the social pits
  distance_vector2 <- dist(t(s_ind_value_sets), method = "euclidean")
  distance_matrix2 <- as.matrix(distance_vector2)
  mean_eud2 <- mean(distance_vector2)
  sd_eud2 <- sd(distance_vector2)
  median_eud2 <- median(distance_vector2)
  q1_eud2 <- quantile(distance_vector2, prob = 0.25)
  q3_eud2 <- quantile(distance_vector2, prob = 0.75)

  eud2_summary <- c(mean_eud2, sd_eud2, median_eud2, q1_eud2, q3_eud2)

  save(distance_vector, distance_vector2, eud_summary, eud2_summary, file = here("data", "processed", "distance_objects.RData"))

}

load(here("data", "processed", "distance_objects.RData"))
### Code for the graphs
# Calculate the Euclidean distances between individual valuesets and the social valueset
EUD_from_mean <- rep(0, length = 300)
for(i in 1:300){
    x <- ind_value_sets[,i]
    y <- social_valueset
    EUD_from_mean[i] <- sqrt(sum((x - y)^2))
}

# Calculate the Euclidean distances between socially anchored individual valuesets and the social valueset 
EUD_socially_anchored_from_mean <- rep(0, 300)
for(i in 1:300){
    x <- s_ind_value_sets[,i]
    y <- social_valueset
    EUD_socially_anchored_from_mean[i] <- sqrt(sum((x - y)^2))
}

# Calculate the Euclidean distances between unanchored individual valuesets and the unanchored social valueset 
EUD_unanchored_from_mean <- rep(0, 300)
for(i in 1:300){
    x <- utils_list[,i]
    y <- unanchored_social_valueset
    EUD_unanchored_from_mean[i] <- sqrt(sum((x - y)^2))
}


# Calculate EUD2 from latent coefficients
latent_matrix <- matrix(NA, nrow = 300, ncol = 35)
for(i in 1:300){
  latent_matrix[i,] <- as.vector(latent_coeff_array[[i]] * (1-anchor))

}

# Calculate the Euclidean distances between latent coefficients
distance_vector3 <- dist(latent_matrix, method = "euclidean")
distance_matrix3 <- as.matrix(distance_vector3)


# --------------------------------
# Cleaning covariates in permanova 
# --------------------------------

# Age groups
data <- data %>%
  mutate(A18_24 = ifelse(Age < 25 & Age > 17, 1, 0),
         A25_34 = ifelse(Age < 35 & Age > 24, 1, 0),
         A35_44 = ifelse(Age < 45 & Age > 34, 1, 0),
         A45_54 = ifelse(Age < 55 & Age > 44, 1, 0),
         A55_64 = ifelse(Age < 65 & Age > 54, 1, 0),
         A65_90 = ifelse(Age <= 90 & Age > 64, 1, 0))

age_df <- cbind(data$A18_24, data$A25_34, data$A35_44, data$A45_54, data$A55_64, data$A65_90)

age_df$age_factor <- max.col(age_df)
age_df$age_factor <- ifelse(is.na(age_df$age_factor), 7, age_df$age_factor)
age_factor <- as.factor(age_df$age_factor)

weightdata <- as.factor(ifelse(data$AdditionalDemographicQuestions_weightstatus_value=="normal",1,0))
# weightdata <- as.factor(data$AdditionalDemographicQuestions_weightstatus_value)
educationdata <- as.factor(data$AdditionalDemographicQuestions_education_value)
occupationdata <- as.factor(data$AdditionalDemographicQuestions_employment_value)
genderdata <- as.factor(data$AdditionalDemographicQuestions_gender_value)
ethnicitydata <- as.factor(data$AdditionalDemographicQuestions_ethnicity_value)

m_covariates <- cbind(data$Age, weightdata, educationdata, occupationdata, genderdata, ethnicitydata)


# save RData to run permanova in R not VSCode
# save.image(file='permanovaworkspace.RData')

if (run_long_functions==1){
  # PERMANOVA
  set.seed(1998)
  permanova_main <- adonis2(distance_vector ~ age_factor + weightdata + educationdata + occupationdata + genderdata + ethnicitydata, permutations = 10000)
  # PERMANOVA2
  set.seed(1998)
  permanova2 <- adonis2(distance_vector2 ~ age_factor + weightdata + educationdata + occupationdata + genderdata + ethnicitydata, permutations = 10000)
  save(permanova_main, permanova2, file = here("data", "processed", "permanova_objects.RData"))
}

load(here("data", "processed", "permanova_objects.RData"))


# --------------------------------
# Filtering data by age group 
# --------------------------------
age18_ids <- data %>%
    mutate(row_position = row_number()) %>%
    filter(A18_24 == 1) %>%
    select(userId, row_position, A18_24, PITS)
age18_selecta <- as.vector(age18_ids$row_position)
age18_coef_m <- latent_coeff_array[age18_selecta]

age18_anchor <- mean(age18_ids$PITS)

# Initialize a matrix to store the sum of all matrices
age18_sum_matrix <- matrix(0, nrow = 5, ncol = 7)
# Sum all matrices
for (m in age18_coef_m) {
  age18_sum_matrix <- age18_sum_matrix + m
}
# Divide the sum by the number of matrices to get the average
age18_average_matrix <- age18_sum_matrix / length(age18_coef_m)
age18_anchored_matrix <- age18_average_matrix * (1-age18_anchor) # Anchoring by social anchor 
age18_valueset <- sapply(health_state_codes, calculate_score, age18_anchored_matrix)

age25_ids <- data %>%
    mutate(row_position = row_number()) %>%
    filter(A25_34 == 1) %>%
    select(userId, row_position, A25_34, PITS)
age25_selecta <- as.vector(age25_ids$row_position)
age25_coef_m <- latent_coeff_array[age25_selecta]

age25_anchor <- mean(age25_ids$PITS)

# Initialize a matrix to store the sum of all matrices
age25_sum_matrix <- matrix(0, nrow = 5, ncol = 7)
# Sum all matrices
for (m in age25_coef_m) {
  age25_sum_matrix <- age25_sum_matrix + m
}
# Divide the sum by the number of matrices to get the average
age25_average_matrix <- age25_sum_matrix / length(age25_coef_m)
age25_anchored_matrix <- age25_average_matrix * (1-age25_anchor) # Anchoring by social anchor 
age25_valueset <- sapply(health_state_codes, calculate_score, age25_anchored_matrix)

age35_ids <- data %>%
    mutate(row_position = row_number()) %>%
    filter(A35_44 == 1) %>%
    select(userId, row_position, A35_44, PITS)
age35_selecta <- as.vector(age35_ids$row_position)
age35_coef_m <- latent_coeff_array[age35_selecta]

age35_anchor <- mean(age35_ids$PITS)

# Initialize a matrix to store the sum of all matrices
age35_sum_matrix <- matrix(0, nrow = 5, ncol = 7)
# Sum all matrices
for (m in age35_coef_m) {
  age35_sum_matrix <- age35_sum_matrix + m
}
# Divide the sum by the number of matrices to get the average
age35_average_matrix <- age35_sum_matrix / length(age35_coef_m)
age35_anchored_matrix <- age35_average_matrix * (1-age35_anchor) # Anchoring by social anchor 
age35_valueset <- sapply(health_state_codes, calculate_score, age35_anchored_matrix)

age45_ids <- data %>%
    mutate(row_position = row_number()) %>%
    filter(A45_54 == 1) %>%
    select(userId, row_position, A45_54, PITS)
age45_selecta <- as.vector(age45_ids$row_position)
age45_coef_m <- latent_coeff_array[age45_selecta]

age45_anchor <- mean(age45_ids$PITS)

# Initialize a matrix to store the sum of all matrices
age45_sum_matrix <- matrix(0, nrow = 5, ncol = 7)
# Sum all matrices
for (m in age45_coef_m) {
  age45_sum_matrix <- age45_sum_matrix + m
}
# Divide the sum by the number of matrices to get the average
age45_average_matrix <- age45_sum_matrix / length(age45_coef_m)
age45_anchored_matrix <- age45_average_matrix * (1-age45_anchor) # Anchoring by social anchor 
age45_valueset <- sapply(health_state_codes, calculate_score, age45_anchored_matrix)

age55_ids <- data %>%
    mutate(row_position = row_number()) %>%
    filter(A55_64 == 1) %>%
    select(userId, row_position, A55_64, PITS)
age55_selecta <- as.vector(age55_ids$row_position)
age55_coef_m <- latent_coeff_array[age55_selecta]

age55_anchor <- mean(age55_ids$PITS)

# Initialize a matrix to store the sum of all matrices
age55_sum_matrix <- matrix(0, nrow = 5, ncol = 7)
# Sum all matrices
for (m in age55_coef_m) {
  age55_sum_matrix <- age55_sum_matrix + m
}
# Divide the sum by the number of matrices to get the average
age55_average_matrix <- age55_sum_matrix / length(age55_coef_m)
age55_anchored_matrix <- age55_average_matrix * (1-age55_anchor) # Anchoring by social anchor 
age55_valueset <- sapply(health_state_codes, calculate_score, age55_anchored_matrix)

age65_ids <- data %>%
    mutate(row_position = row_number()) %>%
    filter(A65_90 == 1) %>%
    select(userId, row_position, A65_90, PITS)
age65_selecta <- as.vector(age65_ids$row_position)
age65_coef_m <- latent_coeff_array[age65_selecta]

age65_anchor <- mean(age65_ids$PITS)

# Initialize a matrix to store the sum of all matrices
age65_sum_matrix <- matrix(0, nrow = 5, ncol = 7)
# Sum all matrices
for (m in age65_coef_m) {
  age65_sum_matrix <- age65_sum_matrix + m
}
# Divide the sum by the number of matrices to get the average
age65_average_matrix <- age65_sum_matrix / length(age65_coef_m)
age65_anchored_matrix <- age65_average_matrix * (1-age65_anchor) # Anchoring by social anchor 
age65_valueset <- sapply(health_state_codes, calculate_score, age65_anchored_matrix)



under34 <- c(age18_ids$PITS, age25_ids$PITS)
over34 <- c(age35_ids$PITS, age45_ids$PITS, age55_ids$PITS, age65_ids$PITS)
mean(over34)
mean(under34)







# --------------------------------
# Filtering data by weight status 
# --------------------------------
normal_ids <- data %>%
    mutate(row_position = row_number()) %>%
    filter(AdditionalDemographicQuestions_weightstatus_value == "normal") %>%
    select(userId, row_position, PITS)
normal_selecta <- as.vector(normal_ids$row_position)
normal_coef_m <- latent_coeff_array[normal_selecta]

normal_anchor <- mean(normal_ids$PITS)

# Initialize a matrix to store the sum of all matrices
normal_sum_matrix <- matrix(0, nrow = 5, ncol = 7)
# Sum all matrices
for (m in normal_coef_m) {
  normal_sum_matrix <- normal_sum_matrix + m
}
# Divide the sum by the number of matrices to get the average
normal_average_matrix <- normal_sum_matrix / length(normal_coef_m)
normal_anchored_matrix <- normal_average_matrix * (1-normal_anchor) # Anchoring by social anchor 
normal_valueset <- sapply(health_state_codes, calculate_score, normal_anchored_matrix)

# --------------------------------
over_ids <- data %>%
    mutate(row_position = row_number()) %>%
    filter(AdditionalDemographicQuestions_weightstatus_value == "over") %>%
    select(userId, row_position, PITS)
over_selecta <- as.vector(over_ids$row_position)
over_coef_m <- latent_coeff_array[over_selecta]

over_anchor <- mean(over_ids$PITS)

# Initialize a matrix to store the sum of all matrices
over_sum_matrix <- matrix(0, nrow = 5, ncol = 7)
# Sum all matrices
for (m in over_coef_m) {
  over_sum_matrix <- over_sum_matrix + m
}
# Divide the sum by the number of matrices to get the average
over_average_matrix <- over_sum_matrix / length(over_coef_m)
over_anchored_matrix <- over_average_matrix * (1-over_anchor) # Anchoring by social anchor 
over_valueset <- sapply(health_state_codes, calculate_score, over_anchored_matrix)
# --------------------------------
obese_ids <- data %>%
    mutate(row_position = row_number()) %>%
    filter(AdditionalDemographicQuestions_weightstatus_value == "obese") %>%
    select(userId, row_position, PITS)
obese_selecta <- as.vector(obese_ids$row_position)
obese_coef_m <- latent_coeff_array[obese_selecta]

obese_anchor <- mean(obese_ids$PITS)

# Initialize a matrix to store the sum of all matrices
obese_sum_matrix <- matrix(0, nrow = 5, ncol = 7)
# Sum all matrices
for (m in obese_coef_m) {
  obese_sum_matrix <- obese_sum_matrix + m
}
# Divide the sum by the number of matrices to get the average
obese_average_matrix <- obese_sum_matrix / length(obese_coef_m)
obese_anchored_matrix <- obese_average_matrix * (1-obese_anchor) # Anchoring by social anchor 
obese_valueset <- sapply(health_state_codes, calculate_score, obese_anchored_matrix)

print("Heterogeneity Script Successfully Run")

