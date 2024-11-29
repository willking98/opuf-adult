# ---------------------------------------------
# OPUF ADULT 5. Latex Tables and Graphs Script
# Will King
# Newcastle University
# 22 August 2024
# ---------------------------------------------
#source("4_heterogeneity.R")

# ---------------------------------------------
# Graphs
# ---------------------------------------------
# -------------------------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------------------------

n_states = 100 # Change this to show a different number of health states on the x axis and give the graph more colour and homogeneity

# OPUF single line graph

# Number of levels and dimensions
levels <- 1:5
dimensions <- 7

# Generate all combinations of levels across dimensions
combinations <- expand.grid(rep(list(levels), dimensions))

# Combine the levels into a single string for each combination
health_state_codes <- apply(combinations, 1, paste0, collapse = "")

df <- data.frame(HealthState = health_state_codes, Score = social_valueset)

social_values <- df[,2]
healthstate_labels <- df[,1]

# limit the number of health states to 100
sample_hs <- round(seq(1,length(social_values), length.out = n_states))
hs_ranks = rank(-social_values, ties.method = "random")
indices = hs_ranks %in% sample_hs

simple_chart <- ggplot() +
  geom_hline(yintercept = 0, size = 0.5, color = "gray") +
  geom_point(aes(x = hs_ranks[indices], y= social_values[indices]),shape = 10, col = "cadetblue", fill ="red") +
  geom_line(aes(x = hs_ranks[indices], y= social_values[indices]), col = "cadetblue")  +
  scale_x_continuous(
    breaks = sample_hs, 
    labels = healthstate_labels[sample_hs], 
    minor_breaks = NULL, name = "Health state indices") +
  ylab("Personal utility values") +
  theme_minimal()+ 
  scale_color_viridis_b(begin = 1,end = 0) +
  coord_cartesian(ylim=c(-0.5,1)) +
  theme(legend.position = "none", axis.text.x = element_text(angle = 45))

# -------------------------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------------------------

# OPUF all lines graph

# Assuming individual_utilities is a matrix of size 78125x300
# Subset the matrix to get the utility values for the selected 25 health states
individual_utilities_subset <- ind_value_sets[indices, ]

# Convert the matrix to a long-format data frame for ggplot
individual_utilities_df <- data.frame(
  HealthState = rep(healthstate_labels[indices], ncol(individual_utilities_subset)),
  Score = as.vector(individual_utilities_subset),
  Individual = rep(1:ncol(individual_utilities_subset), each = length(sample_hs))
)

sample_hs_labels <- round(seq(1,length(social_values), length.out = 10))
hs_ranks_labels = rank(-social_values, ties.method = "random")
indices_labels = hs_ranks_labels %in% sample_hs_labels

plain_chart <- ggplot() +
  # Add individual lines for each person in light grey
  geom_line(data = individual_utilities_df, aes(x = rep(hs_ranks[indices], ncol(individual_utilities_subset)), y = Score, group = Individual), 
            color = "black", size = 0.1, alpha = 0.2) +
  
  # Add the mean line (as before)
  geom_hline(yintercept = 0, size = 0.5, color = "gray") +
  #geom_point(aes(x = hs_ranks[indices], y = social_values[indices]), shape = 10, col = "cadetblue", fill = "red") +
  geom_line(aes(x = hs_ranks[indices], y = social_values[indices]), col = "#000000", size = 1) +
  
  # Customize x-axis with selected labels
scale_x_continuous(
  breaks = sample_hs_labels, 
  labels = healthstate_labels[indices_labels], 
  minor_breaks = NULL, 
  name = "WAItE health states"
) +

  
  # Customize y-axis
  ylab("Social and individual utility") +
  
  # Apply minimal theme
  theme_minimal() +
  
  # Set y-axis limits
  coord_cartesian(ylim = c(0, 1)) +
  
  # Customize theme
  theme(legend.position = "bottom", axis.text.x = element_text(angle = 22.5)) +
  # Adjust the axis labels' position
  theme(
    axis.title.x = element_text(size = 10, margin = margin(t = 10, r = 0, b = 0, l = 0)),
    axis.title.y = element_text(size = 10, margin = margin(t = 0, r = 10, b = 0, l = 0))
  ) 

# ggsave("plain_plot.png", plot = plain, width = 12, height = 8)

# -------------------------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------------------------

# OPUF all lines graph with mean lines from all valuation studies thus far

# Assuming individual_utilities is a matrix of size 78125x300
# Subset the matrix to get the utility values for the selected 25 health states
individual_utilities_subset <- ind_value_sets[indices, ]

# Convert the matrix to a long-format data frame for ggplot
individual_utilities_df <- data.frame(
  HealthState = rep(healthstate_labels[indices], ncol(individual_utilities_subset)),
  Score = as.vector(individual_utilities_subset),
  Individual = rep(1:ncol(individual_utilities_subset), each = length(sample_hs))
)

sample_hs_labels <- round(seq(1,length(social_values), length.out = 10))
hs_ranks_labels = rank(-social_values, ties.method = "random")
indices_labels = hs_ranks_labels %in% sample_hs_labels

waite_comparisons <- ggplot() +
  # Add individual lines for each person in light grey
  geom_line(data = individual_utilities_df, aes(x = rep(hs_ranks[indices], ncol(individual_utilities_subset)), y = Score, group = Individual), 
            color = "#6e6d6d", size = 0.1, alpha = 0.2) +
  
  # Add the mean line (as before)
  geom_hline(yintercept = 0, size = 0.5, color = "gray") +
  #geom_point(aes(x = hs_ranks[indices], y = social_values[indices]), shape = 10, col = "cadetblue", fill = "red") +
  geom_line(aes(x = hs_ranks[indices], y = social_values[indices]), col = "#000000", size = 1.25) +
  geom_line(aes(x = hs_ranks[indices], y = dcetto_valueset[indices]), col ="#ca0000", size = 1.25) +
  #geom_line(aes(x = hs_ranks[indices], y = dcevas_valueset[indices]), col ="green", size = 1.25) +
  
  # Customize x-axis with selected labels
scale_x_continuous(
  breaks = sample_hs_labels, 
  labels = healthstate_labels[indices_labels], 
  minor_breaks = NULL, 
  name = "WAItE health states"
) +

  
  # Customize y-axis
  ylab("Social and individual utility") +
  
  # Apply minimal theme
  theme_minimal() +
  
  # Set y-axis limits
  coord_cartesian(ylim = c(0, 1)) +
  
  # Customize theme
  theme(legend.position = "bottom", axis.text.x = element_text(angle = 0)) +
  # Adjust the axis labels' position
  theme(
    axis.title.x = element_text(size = 10, margin = margin(t = 10, r = 0, b = 0, l = 0)),
    axis.title.y = element_text(size = 10, margin = margin(t = 0, r = 10, b = 0, l = 0))
  ) 
library(viridis)

# Get Viridis colors
viridis_colors <- viridis(3)


# Create a data frame for the lines and map the grouping variable
comparison_df <- data.frame(
  hs_ranks = rep(hs_ranks[indices], 3),
  values = c(social_values[indices], dcetto_valueset[indices], dcevas_valueset[indices]),
  group = factor(rep(c("OPUF", "DCE-TTO", "DCE-VAS"), each = length(hs_ranks[indices])))
)

# Get Viridis colors
viridis_colors <- viridis(3)

waite_comparisons <- ggplot() +
  # Add individual lines for each person in light grey
  geom_line(data = individual_utilities_df, aes(x = rep(hs_ranks[indices], ncol(individual_utilities_subset)), y = Score, group = Individual), 
            color = "#6e6d6d", size = 0.1, alpha = 0.2) +
  
  # Add the mean line (as before)
  geom_hline(yintercept = 0, size = 0.5, color = "gray") +
  
  # Add the main lines for social, dcetto, and dcevas values with grouping
  geom_line(data = comparison_df, aes(x = hs_ranks, y = values, color = group), size = 1.25) +
  
  # Customize x-axis with selected labels
  scale_x_continuous(
    breaks = sample_hs_labels, 
    labels = healthstate_labels[indices_labels], 
    minor_breaks = NULL, 
    name = "WAItE health states"
  ) +

  # Customize y-axis
  ylab("Social and individual utility") +
  
  # Set color palette for the lines
  scale_color_manual(values = viridis_colors) +

  # Apply minimal theme
  theme_minimal() +

  # Adjust legend and set position at the bottom
  theme(
    legend.position = "bottom", # Places the legend at the bottom
    legend.title = element_blank(), # Removes the title of the legend
    legend.text = element_text(size = 10),
    plot.margin = unit(c(1, 1, 2, 1), "lines") # Adjust margins if needed
  ) +
  
  # Customize y-axis limits
  coord_cartesian(ylim = c(0, 1))





# ggsave("Plots/waite_comparisons_plot.png", plot = waite_comparisons, width = 12, height = 8)
# -------------------------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------------------------

# EUD line graph with each individual valueset anchored using their own pits value (messy)

# Assuming euclidean_distances is a vector with length equal to the number of individuals (300)
# Add the Euclidean distance as a new column to the data frame
individual_utilities_df$Distance <- rep(EUD_from_mean, each = length(sample_hs))




eud_chart <- ggplot() +
  # Add individual lines for each person, colored by Euclidean distance
  geom_line(data = individual_utilities_df, aes(x = rep(hs_ranks[indices], ncol(individual_utilities_subset)), 
                                                y = Score, group = Individual, color = Distance), 
            size = 0.4, alpha = 0.5) +
  
  # Add the mean line (as before)
  geom_hline(yintercept = 0, size = 0.5, color = "gray") +
  geom_point(aes(x = hs_ranks[indices], y = social_values[indices]), shape = 10, col = "cadetblue", fill = "red") +
  geom_line(aes(x = hs_ranks[indices], y = social_values[indices]), col = "#000000", size = 1) +
  
# Customize x-axis with selected labels
scale_x_continuous(
  breaks = sample_hs_labels, 
  labels = healthstate_labels[indices_labels], 
  minor_breaks = NULL, 
  name = "WAItE health states"
) +

  
  # Customize y-axis
  ylab("Social and individual utility") +
  
  # Apply minimal theme
  theme_minimal() +
  
  # Set y-axis limits
  coord_cartesian(ylim = c(0, 1)) +
  
  # Customize theme
  theme(legend.position = "bottom", axis.text.x = element_text(angle = 22.5)) +
  # Adjust the axis labels' position
  theme(
    axis.title.x = element_text(size = 10, margin = margin(t = 10, r = 0, b = 0, l = 0)),
    axis.title.y = element_text(size = 10, margin = margin(t = 0, r = 10, b = 0, l = 0))
  ) +

scale_color_viridis_c(
    name = "Euclidean Distance",
    limits = c(0, 70),  # Set the boundaries for the color scale
    direction = -1,
    oob = scales::squish  # Handle out of bounds by squishing values to the nearest boundary
  )

  # ggsave("EUD_plot.png", plot = p, width = 12, height = 8)



# -------------------------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------------------------

# Weight status subgroups plot

# Assuming individual_utilities is a matrix of size 78125x300
# Subset the matrix to get the utility values for the selected 25 health states
individual_utilities_subset <- ind_value_sets[indices, ]

# Convert the matrix to a long-format data frame for ggplot
individual_utilities_df <- data.frame(
  HealthState = rep(healthstate_labels[indices], ncol(individual_utilities_subset)),
  Score = as.vector(individual_utilities_subset),
  Individual = rep(1:ncol(individual_utilities_subset), each = length(sample_hs))
)

weight_chart <- ggplot() +
  # Add individual lines for each person in light grey
  geom_line(data = individual_utilities_df, aes(x = rep(hs_ranks[indices], ncol(individual_utilities_subset)), y = Score, group = Individual), 
            color = "#000000", size = 0.1, alpha = 0.1) +
  
  # Add the mean line (as before)
  geom_hline(yintercept = 0, size = 0.5, color = "gray") +
  
  # Add lines for different weight status subgroups with a color aesthetic for the legend
  geom_line(aes(x = hs_ranks[indices], y = normal_valueset[indices], color = "Normal"), size = 0.75) +
  geom_line(aes(x = hs_ranks[indices], y = social_values[indices]), col = "#000000", size =1) +
  geom_line(aes(x = hs_ranks[indices], y = over_valueset[indices], color = "Overweight"), size = 0.75) +
  #geom_line(aes(x = hs_ranks[indices], y = obese_valueset[indices], color = "Obese"), size = 1) +
  
 # Customize x-axis with selected labels
scale_x_continuous(
  breaks = sample_hs_labels, 
  labels = healthstate_labels[indices_labels], 
  minor_breaks = NULL, 
  name = "WAItE health states"
) +

  
  # Customize y-axis
  ylab("Social and individual utility") +
  
  # Apply minimal theme
  theme_minimal() +
  
  # Adjust the axis labels' position
  theme(
    axis.title.x = element_text(size = 10, margin = margin(t = 10, r = 0, b = 0, l = 0)),
    axis.title.y = element_text(size = 10, margin = margin(t = 0, r = 10, b = 0, l = 0))
  ) +

  # Use viridis colors for the legend
  scale_color_viridis_d(
    name = "Weight status: ",
    option = "C", # Choose a viridis color palette option ("A", "B", "C", "D", "E")
    labels = c("Normal" = "Normal Weight (n=154)", "Overweight" = "Overweight (n=104)")
  ) +
  
  coord_cartesian(ylim = c(0, 1)) +
  
  # Adjust theme to show the legend
  theme(
    legend.position = "bottom", 
    axis.text.x = element_text(angle = 22.5)
  )

  # ggsave("weight_plot.png", plot = weight_plot, width = 12, height = 8)

# -------------------------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------------------------

# Age group subgroups plot

# Assuming individual_utilities is a matrix of size 78125x300
# Subset the matrix to get the utility values for the selected 25 health states
individual_utilities_subset <- ind_value_sets[indices, ]

# Convert the matrix to a long-format data frame for ggplot
individual_utilities_df <- data.frame(
  HealthState = rep(healthstate_labels[indices], ncol(individual_utilities_subset)),
  Score = as.vector(individual_utilities_subset),
  Individual = rep(1:ncol(individual_utilities_subset), each = length(sample_hs))
)

age_chart <- ggplot() +
  # Add individual lines for each person in light grey
  geom_line(data = individual_utilities_df, aes(x = rep(hs_ranks[indices], ncol(individual_utilities_subset)), y = Score, group = Individual), 
            color = "#000000", size = 0.1, alpha = 0.1) +
  
  # Add the mean line (as before)
  geom_hline(yintercept = 0, size = 0.5, color = "gray") +
  
  # Add lines for different weight status subgroups with a color aesthetic for the legend
  geom_line(aes(x = hs_ranks[indices], y = social_values[indices]), col = "#000000", size = 1) +
  geom_line(aes(x = hs_ranks[indices], y = age18_valueset[indices], color = "18"), size = 0.75) +
  geom_line(aes(x = hs_ranks[indices], y = age25_valueset[indices], col = "25"), size =0.75) +
  geom_line(aes(x = hs_ranks[indices], y = age35_valueset[indices], color = "35"), size = 0.75) +
  geom_line(aes(x = hs_ranks[indices], y = age45_valueset[indices], color = "45"), size = 0.75) +
  geom_line(aes(x = hs_ranks[indices], y = age55_valueset[indices], color = "55"), size = 0.75) +
  geom_line(aes(x = hs_ranks[indices], y = age65_valueset[indices], color = "65"), size = 0.75) +
  
 # Customize x-axis with selected labels
scale_x_continuous(
  breaks = sample_hs_labels, 
  labels = healthstate_labels[indices_labels], 
  minor_breaks = NULL, 
  name = "WAItE health states"
) +

  
  # Customize y-axis
  ylab("Social and individual utility") +
  
  # Apply minimal theme
  theme_minimal() +
  
  # Adjust the axis labels' position
  theme(
    axis.title.x = element_text(size = 10, margin = margin(t = 10, r = 0, b = 0, l = 0)),
    axis.title.y = element_text(size = 10, margin = margin(t = 0, r = 10, b = 0, l = 0))
  ) +

  # Use viridis colors for the legend
  scale_color_viridis_d(
    name = "Age group: ",
    option = "C", # Choose a viridis color palette option ("A", "B", "C", "D", "E")
    labels = c("18" = "18-24 (n=32)", "25" = "25-34 (n=50)", "35" = "35-44 (n=48)", "45" = "45-54 (n=49)", "55" = "55-64 (n=81)", "65" = "65-90 (n=34)")
  ) +
  
  coord_cartesian(ylim = c(0, 1)) +
  
  # Adjust theme to show the legend
  theme(
    legend.position = "bottom", 
    axis.text.x = element_text(angle = 22.5)
  )

  # ggsave("age_plot.png", plot = age_plot, width = 12, height = 8)

# -------------------------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------------------------

hist <- filter(data, PITS>-5.01)
hist <- ggplot(hist, aes(x = PITS, fill = PITS < -0.05)) +
  geom_histogram(binwidth = 0.15, color = "black", alpha = 0.9) +
  scale_fill_manual(values = c("FALSE" = "#f2db0d", "TRUE" = "#625e5e"), 
                    labels = c("FALSE" = "PITS-VAS", "TRUE" = "Dead-VAS"),
                    name = "Anchoring task") +
  labs(x = "WAItE PITS utility",
       y = "Frequency") +
  theme_minimal() +
  theme(
    axis.title.x = element_text(size = 10),
    axis.title.y = element_text(size = 10),
    legend.text = element_text(size = 10)
  ) +
  theme(
    axis.title.x = element_text(size = 10, margin = margin(t = 10, r = 0, b = 0, l = 0)),
    axis.title.y = element_text(size = 10, margin = margin(t = 0, r = 10, b = 0, l = 0)),
    
  )


# ggsave("hist.png", plot = hist, width = 10, height = 6)




# -------------------------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------------------------
# Producing likert plots for the task acceptability questions
# Load necessary libraries
library(ggplot2)
library(dplyr)
library(tidyr)
library(scales)



# -------------------------------------------------------------------------------------------------------------------
# Understand
feedback_understand_value <- data$feedback_understand_value

# Sample data

# Convert data to a factor with specified levels
feedback_understand_value <- factor(feedback_understand_value, 
                                    levels = c("stronglydisagree", "somewhatdisagree", "neither", "somewhatagree", "stronglyagree"),
                                    labels = c("Strongly disagree", "Somewhat disagree", "Neither agree nor disagree", "Somewhat agree", "Strongly agree"))


# Create a data frame for plotting
df <- data.frame(response = feedback_understand_value)

# Summarize the data by category
summary_df <- df %>%
  group_by(response) %>%
  summarise(count = n()) %>%
  mutate(percentage = count / sum(count))

# Updated ggplot code using viridis colors
understand <- ggplot(summary_df, aes(x = response, y = percentage, fill = response)) +
  geom_bar(stat = "identity") +
  scale_y_continuous(labels = percent_format()) +
  scale_fill_viridis_d(option = "viridis") +  # Using viridis colors for discrete scale
  labs(title = "It was easy to understand the questions I was asked",
       x = "Likert response",
       y = "Percentage",
       fill = "Likert response") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 1.5, size = 20),
    axis.title.x = element_text(size = 16),
    axis.title.y = element_text(size = 16),
    axis.text.x = element_text(size = 12, angle = 30),
    legend.text = element_text(size = 12)
    #legend.position = "top"
  )


# -------------------------------------------------------------------------------------------------------------------
# Decide
# Sample data
feedback_decide_value <- data$feedback_decide_value

# Convert data to a factor with specified levels
feedback_decide_value <- factor(feedback_decide_value, 
                                    levels = c("stronglydisagree", "somewhatdisagree", "neither", "somewhatagree", "stronglyagree"),
                                    labels = c("Strongly disagree", "Somewhat disagree", "Neither agree nor disagree", "Somewhat agree", "Strongly agree"))


# Create a data frame for plotting
df <- data.frame(response = feedback_decide_value)

# Summarize the data by category
summary_df <- df %>%
  group_by(response) %>%
  summarise(count = n()) %>%
  mutate(percentage = count / sum(count))

# Updated ggplot code using viridis colors
decide <- ggplot(summary_df, aes(x = response, y = percentage, fill = response)) +
  geom_bar(stat = "identity") +
  scale_y_continuous(labels = percent_format()) +
  scale_fill_viridis_d(option = "viridis") +  # Using viridis colors for discrete scale
  labs(title = "I found it difficult to decide on my answers to the questions",
       x = "Likert response",
       y = "Percentage",
       fill = "Likert response") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 1.5, size = 20),
    axis.title.x = element_text(size = 16),
    axis.title.y = element_text(size = 16),
    axis.text.x = element_text(size = 12, angle = 30),
    legend.text = element_text(size = 12)
    #legend.position = "top"
  )


# -------------------------------------------------------------------------------------------------------------------
# Differences
# Sample data
feedback_differences_value <- data$feedback_differences_value

# Convert data to a factor with specified levels
feedback_differences_value <- factor(feedback_differences_value, 
                                    levels = c("stronglydisagree", "somewhatdisagree", "neither", "somewhatagree", "stronglyagree"),
                                    labels = c("Strongly disagree", "Somewhat disagree", "Neither agree nor disagree", "Somewhat agree", "Strongly agree"))


# Create a data frame for plotting
df <- data.frame(response = feedback_differences_value)

# Summarize the data by category
summary_df <- df %>%
  group_by(response) %>%
  summarise(count = n()) %>%
  mutate(percentage = count / sum(count))

# Updated ggplot code using viridis colors
differences <- ggplot(summary_df, aes(x = response, y = percentage, fill = response)) +
  geom_bar(stat = "identity") +
  scale_y_continuous(labels = percent_format()) +
  scale_fill_viridis_d(option = "viridis") +  # Using viridis colors for discrete scale
  labs(title = "I found it easy to tell the differences between the health states I was asked to think about",
       x = "Likert response",
       y = "Percentage",
       fill = "Likert response") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16),
    axis.title.x = element_text(size = 16),
    axis.title.y = element_text(size = 16),
    axis.text.x = element_text(size = 12, angle = 30),
    legend.text = element_text(size = 12)
    #legend.position = "top"
  )


# ggsave("Plots/understand.png", plot = understand, width = 8, height = 10)
# ggsave("Plots/decide.png", plot = decide, width = 8, height = 10)
# ggsave("Plots/differences.png", plot = differences, width = 8, height = 10)


# -------------------------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------------------------
# thinking about pref heterogeneity in anchoring simple bivariate model

# Clean age to be numeric
data$Age <- as.numeric(data$Age)
# OLS linear regression
ols_pits_age <- lm(data$PITS ~ as.numeric(data$Age))

# Add a constant to shift the data so all values are positive
data$PITS_shifted <- data$PITS + abs(min(data$PITS)) + 1 # 15.3 constant added

# Now fit the Gamma model with the shifted data
gamma_model <- glm(PITS_shifted ~ Age, data = data, family = Gamma(link = "log"))

# Fit an Inverse Gaussian regression with log link
inv_gaussian_model <- glm(PITS_shifted ~ Age, data = data, family = inverse.gaussian(link = "log"))

# Compare models using AIC and BIC
aic_values <- AIC(gamma_model, inv_gaussian_model)
bic_values <- BIC(gamma_model, inv_gaussian_model)
print(aic_values)
print(bic_values)

# Fit the GLM model
gamma_model <- glm(PITS_shifted ~ Age, data = data, family = Gamma(link = "log"))

# Extract model coefficients
model_summary <- summary(gamma_model)$coefficients

# Create a LaTeX table with more decimal places
glm_table <- xtable(model_summary,
                    caption = "Gamma GLM Model Coefficients",
                    label = "tab:glm_coefficients", 
                    digits = 4)


# -------------------------------------------------------------------------------------------------------------------
# K-means to look at the number of clusters present in the age variation
# Assuming you have the data in a data frame called 'data'
data_for_clustering <- data[, c("PITS", "Age")]
# Remove rows with NA values
data_for_clustering <- na.omit(data_for_clustering)

data_standardized <- scale(data_for_clustering)

set.seed(1998) # For reproducibility
wss <- function(k) {
  kmeans(data_standardized, k, nstart = 10)$tot.withinss
}

k_values <- 1:10
wss_values <- sapply(k_values, wss)

# Plot the Elbow Method
plot(k_values, wss_values, type = "b", pch = 19, xlab = "Number of Clusters", ylab = "Within Sum of Squares")

set.seed(1998) # For reproducibility
k <- 3
kmeans_result <- kmeans(data_standardized, centers = k, nstart = 10)
data_for_clustering$Cluster <- kmeans_result$cluster

# Original linear model plot
plot(data_for_clustering$Age, data_for_clustering$PITS, col = data_for_clustering$Cluster, pch = 19, xlab = "Age", ylab = "PITS")

data_for_clustering$Cluster <- as.factor(data_for_clustering$Cluster)
levels(data_for_clustering$Cluster) <- c("Age 18-45", "Age 20-30", "Age 45-83")
# Or using ggplot2 for a more sophisticated plot
ggplot(data_for_clustering, aes(x = Age, y = PITS, color = Cluster)) +
  geom_point() +
  labs(color = "Cluster") +
  theme_minimal() + 
  coord_cartesian(ylim = c(-1, 1))



# Summary statistics for each cluster

data_for_clustering %>%
  group_by(Cluster) %>%
  summarise(
    Mean_Age = mean(Age, na.rm = TRUE),
    Median_Age = median(Age, na.rm = TRUE),
    Mean_PITS = mean(PITS, na.rm = TRUE),
    Median_PITS = median(PITS, na.rm = TRUE),
    Min_Age = min(Age, na.rm = TRUE),
    Max_Age = max(Age, na.rm = TRUE),
    Count = n()
  )

# Plot new glm model with age clusters rather than continuous age for age group effect
data_for_clustering$PITS <- data_for_clustering$PITS + 15.3
gamma_model_clusters <- glm(PITS ~ Cluster, data = data_for_clustering, family = Gamma(link = "log"))
summary(gamma_model_clusters)

# Extract model coefficients
model_summary_clusters <- summary(gamma_model_clusters)$coefficients

# Create a LaTeX table with more decimal places
glm_table_clusters <- xtable(model_summary_clusters,
                    caption = "Gamma GLM Model Coefficients",
                    label = "tab:glm_coefficients", 
                    digits = 4)

# -------------------------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------------------------
# thinking about pref heterogeneity in anchoring simple multivariate model
data_for_glm <- cbind(data$PITS_shifted, m_covariates)
data_for_glm <- na.omit(data_for_glm)
data_for_glm <- data.frame(data_for_glm)
# Convert all columns to numeric (if possible)
data_for_glm[] <- lapply(data_for_glm, function(x) as.numeric(as.character(x)))

names(data_for_glm) <- c("pits", "age", "weightdata", "educationdata", "occupationdata", "genderdata", "ethnicitydata")
# Now fit the Gamma model with the shifted data
gamma_multivar_model <- glm(pits ~ age + educationdata + occupationdata + genderdata + ethnicitydata, 
                   data = data_for_glm,
                   family = Gamma(link = "log"))

AIC(gamma_multivar_model)
BIC(gamma_multivar_model)
# xtable(summary(gamma_multivar_model)$coefficients, digits = 4)
