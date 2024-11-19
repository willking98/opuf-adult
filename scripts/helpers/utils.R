# Define a function to calculate and format the statistics
calculate_stats <- function(data_column) {
  mean_sd <- paste(round(mean(data_column), 3), " (", round(sd(data_column), 3), ")", sep = "")
  median_q <- paste(round(median(data_column), 1), " (", round(quantile(data_column, 0.25), 1), "; ", round(quantile(data_column, 0.75), 1), ")", sep = "")
  c(mean_sd, median_q, round(min(data_column), 1), round(max(data_column), 1))
}


