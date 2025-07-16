# List of required packages
required_packages <- c("ggplot2", "gganimate", "gifski")

# Check if packages are installed, and install them if not
for (pkg in required_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg, repos = "https://cran.rstudio.com/")
  }
}

# Load packages
library(ggplot2)
library(gganimate)

# Create the base static ggplot graph for the animation
# Use the iris dataset, setting Sepal.Length and Sepal.Width to x and y axes
# Color-code by Species
p <- ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_point(alpha = 0.7, size = 4) + # Plot points. Make them slightly transparent
  labs(
    title = "Iris Dataset: Sepal Length vs. Width",
    subtitle = "Sepal.Length: {frame_along}", # Subtitle that changes during animation
    x = "Sepal Length (cm)",
    y = "Sepal Width (cm)",
    caption = "Created with gganimate"
  ) +
  theme_minimal(base_size = 14) + # Set a minimal theme
  theme(plot.title = element_text(face = "bold"))

# Add animation rules with gganimate
anim <- p +
  # Reveal data along Sepal.Length
  transition_reveal(Sepal.Length) +
  # Smooth the animation movement
  ease_aes("linear") +
  # Leave a trail of past points
  shadow_wake(wake_length = 0.1, alpha = FALSE)

# Run the animation and save as a GIF
# You can adjust the number of frames with nframes (more frames = smoother and longer)
# fps is frames per second
animate(anim, nframes = 200, fps = 10, width = 800, height = 600, renderer = gifski_renderer("iris_animation.gif"))

# Running the line above will save the GIF animation as "iris_animation.gif"
# in your working directory.
