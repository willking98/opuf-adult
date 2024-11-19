
# TODO: Experimental kmeans analysis
for(i in 1:300){
    valueset_x <- ind_value_sets[,i]
}

set.seed(3)
kmeans_data <- matrix(NA, nrow = length(anchored_coef_array), ncol = 35)
kmeans_data <- as.data.frame(kmeans_data)

# Use anchored results list as there is much more variation! 
# Tip from Paul
for (i in 1:length(anchored_coef_array)) {
  v_results <- as.vector(anchored_coef_array[[i]])
  kmeans_data[i, ] <- v_results
}
# Choose the number of clusters
wcss <- sapply(1:20, function(k) {
  kmeans(kmeans_data, centers = k, nstart = 20)$tot.withinss
})

# Create a data frame for plotting
wcss_data <- data.frame(k = 1:20, WCSS = wcss)

ggplot(wcss_data, aes(x = k, y = WCSS)) +
  geom_point(color = "#0073C2", size = 1.5) +  # Adjust point size and color
  geom_line(color = "#0073C2", size = 1.2) +  # Thicker line for better visibility
  labs(
    # title = "Elbow Method for Determining Optimal k",
    # subtitle = "Finding the number of clusters with the smallest WCSS drop",
    x = "Number of Clusters (k)",
    y = "Within-Cluster Sum of Squares (WCSS)"
  ) +
  theme_minimal(base_size = 14) +  # Slightly larger base font size for readability
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5),  # Bold and centered title
    plot.subtitle = element_text(hjust = 0.5, margin = margin(b = 10)),  # Center subtitle with spacing
    axis.title = element_text(face = "bold"),  # Bold axis titles
    panel.grid.major = element_line(color = "gray90"),  # Softer gridlines
    panel.grid.minor = element_blank(),  # Remove minor gridlines for clarity
    axis.line = element_line(color = "gray70")  # Add axis lines for definition
  ) +
  scale_x_continuous(breaks = scales::pretty_breaks(n = 10))  # Adjust x-axis breaks

# ggplot(wcss_data, aes(x = k, y = WCSS)) +
#   geom_point(color = "blue", size = 1) +
#   geom_line(color = "blue") +
#   labs(
#     title = "Elbow Method for Optimal k",
#     x = "Number of Clusters (k)",
#     y = "Total Within-Cluster Sum of Squares (WCSS)"
#   ) +
#   theme_minimal() +
#   theme(text = element_text(size = 12))

# Define number of clusters = k
k = 6 
# Run k-means clustering
kmeans_result <- kmeans(kmeans_data, centers = k, nstart = 20)

# Add the cluster assignment to the dataset
kmeans_data$kmeans_cluster <- as.factor(kmeans_result$cluster)
# Cluster size
table(kmeans_data$kmeans_cluster)

# estimate mean latent coefs for each cluster
kmeans_data %>%
  group_by(kmeans_cluster) %>%
  summarise(across(everything(), mean, na.rm = TRUE))

# join back to data to have demographic info
data <- cbind(data, kmeans_data)
c1 <- filter(data, kmeans_cluster == 1)
c2 <- filter(data, kmeans_cluster == 2)
c3 <- filter(data, kmeans_cluster == 3)
summary(c1$AdditionalDemographicQuestions_age_value)
summary(c2$AdditionalDemographicQuestions_age_value)
summary(c3$AdditionalDemographicQuestions_age_value)
table(c1$AdditionalDemographicQuestions_gender_value)
table(c2$AdditionalDemographicQuestions_gender_value)
table(c3$AdditionalDemographicQuestions_gender_value)

data %>%
  group_by(kmeans_cluster) %>%
  summary()
summarise(across(c(AdditionalDemographicQuestions_age_value, AdditionalDemographicQuestions_gender_value), mean, na.rm = TRUE))
#


#TODO: kmeans on pits
# Choose the number of clusters
set.seed(3)
wcss <- sapply(1:10, function(k) {
  kmeans(data$PITS, centers = k, nstart = 20)$tot.withinss
})

# Create a data frame for plotting
wcss_data <- data.frame(k = 1:10, WCSS = wcss)

# Plot with ggplot2
library(ggplot2)
ggplot(wcss_data, aes(x = k, y = WCSS)) +
  geom_point(color = "blue", size = 1) +
  geom_line(color = "blue") +
  labs(
    title = "Elbow Method for Optimal k",
    x = "Number of Clusters (k)",
    y = "Total Within-Cluster Sum of Squares (WCSS)"
  ) +
  theme_minimal() +
  theme(text = element_text(size = 12))

# Define number of clusters = k
set.seed(3)
k = 4 
# Run k-means clustering
kmeans_result <- kmeans(data$PITS, centers = k, nstart = 20)

kmeans_pits_data <- data.frame(pits = data$PITS)
# Add the cluster assignment to the dataset
kmeans_pits_data$kmeans_cluster <- as.factor(kmeans_result$cluster)
# Cluster size
table(kmeans_pits_data$kmeans_cluster)

data <- cbind(data, kmeans_pits_data)

c1 <- filter(data, kmeans_cluster == 1)
c2 <- filter(data, kmeans_cluster == 2)
c3 <- filter(data, kmeans_cluster == 3)
c4 <- filter(data, kmeans_cluster == 4)

table(c1$AdditionalDemographicQuestions_ethnicity_value)
table(c2$AdditionalDemographicQuestions_ethnicity_value)
table(c3$AdditionalDemographicQuestions_ethnicity_value)
table(c4$AdditionalDemographicQuestions_ethnicity_value)

data %>%
  group_by(kmeans_cluster) %>%
  summarise(across(c(PITS), mean, na.rm = TRUE))
#


