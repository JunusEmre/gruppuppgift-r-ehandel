library(dplyr)
library(ggplot2)

# Använd den städade datan
df <- data_clean

# Analys 1: försäljning per produktkategori
forsaljning_per_kategori <- df %>%
  group_by(product_category) %>%
  summarise(
    total_forsaljning = sum(ordervarde, na.rm = TRUE),
    medel_ordervarde = mean(ordervarde, na.rm = TRUE),
    antal_ordrar = n()
  ) %>%
  arrange(desc(total_forsaljning))

print(forsaljning_per_kategori)

# Skapa figur
plot_forsaljning <- ggplot(
  forsaljning_per_kategori,
  aes(
    x = reorder(product_category, total_forsaljning),
    y = total_forsaljning
  )
) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Total försäljning per produktkategori",
    x = "Produktkategori",
    y = "Total försäljning"
  )

print(plot_forsaljning)

# Skapa mapp om den inte finns
dir.create("resultat/figurer", showWarnings = FALSE, recursive = TRUE)

# Spara figur
ggsave(
  filename = "resultat/figurer/forsaljning_per_kategori.png",
  plot = plot_forsaljning,
  width = 8,
  height = 5
)