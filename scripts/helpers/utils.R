# Define a function to calculate and format the statistics
calculate_stats <- function(data_column, digits) {
  mean_sd <- paste(format(round(mean(data_column), digits), nsmall = digits), " (", format(round(sd(data_column), digits), nsmall = digits), ")", sep = "")
  median_q <- paste(format(round(median(data_column), digits), nsmall = digits), " (", format(round(quantile(data_column, 0.25), digits), nsmall = digits), "; ", format(round(quantile(data_column, 0.75), digits), nsmall = digits), ")", sep = "")
  c(mean_sd, median_q, round(min(data_column), digits), round(max(data_column), digits))
}


