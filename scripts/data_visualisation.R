# dodgy axes and scales

# clean script for truncated axis
truncated_axis_plot <- penguins_clean |> 
  ggplot(aes(x = species)) +
  geom_bar() +
  theme_minimal() +
  coord_cartesian(ylim = c(30,125))

ggsave("data_visualisation_figures/truncated_axis_plot.pdf",
       plot = truncated_axis_plot, 
       width = 15,
       height = 10, 
       units = "cm", 
       device = "pdf")

#__________________________----

# inconsistent scales

# simulate Data
set.seed(123)
data1 <- data.frame(Category = c("A", "B", "C"), Value = c(10, 12, 15))
data2 <- data.frame(Category = c("A", "B", "C"), Value = c(100, 120, 150))

# plot 1 (smaller Scale)
plot1 <- ggplot(data1, aes(x = Category, y = Value)) +
  geom_bar(stat = "identity") +
  ggtitle("Dataset 1")

ggsave("data_visualisation_figures/plot1_inconsistant_scales.pdf",
       plot = plot1, 
       width = 15,
       height = 10, 
       units = "cm", 
       device = "pdf")

# plot 2 (larger Scale)
plot2 <- ggplot(data2, aes(x = Category, y = Value)) +
  geom_bar(stat = "identity") +
  ggtitle("Dataset 2")

ggsave("data_visualisation_figures/plot2_inconsistant_scales.pdf",
       plot = plot2, 
       width = 15,
       height = 10, 
       units = "cm", 
       device = "pdf")

plot1 + plot2

#__________________________----

# logarithmic scales misuse

# simulating data
set.seed(123)
data <- data.frame(
  Time = 1:10,
  Value = c(1, 10, 100, 1000, 10000, 100000, 1000000, 10000000, 100000000, 1000000000) # Exponential growth
)
 
# clean script presenting log. scales
log_scale_plot <- ggplot(data, aes(x = Time, y = Value)) +
  geom_line() +
  scale_y_log10(labels = scales::label_log()) +
  theme_minimal()+
  annotation_logticks()+
  labs(y = "Log10 scale")

ggsave("data_visualisation_figures/log_scale_plot.pdf",
       plot = log_scale_plot, 
       width = 15,
       height = 10, 
       units = "cm", 
       device = "pdf")

#__________________________----

