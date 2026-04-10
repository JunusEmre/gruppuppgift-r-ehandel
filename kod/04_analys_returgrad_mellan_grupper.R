# Analys returgrad mellan grupper. Analyserar returgrad per kategori, region och kundsegment.
# Ladda paket.
library(readr)
library(ggplot2)
library(tidyverse)

# Läs in städad data
data_analys <- read_csv("data/bearbetad/ecommerce_orders_stadad.csv", show_col_types = FALSE)


# Visa grundläggande inför
cat("----- Analys returgrad mellan grupper -----\n")
cat("Antal rader:", nrow(data_analys), "\n\n")

# Returgrad per produktkategori
cat("---1. Returgrad per produktkategori---\n")

returgrad_kategori <- data_analys %>%
group_by(product_category) %>%
summarise(
  antal_ordrar  = n(),
  antal_returer = sum(retur_binart, na.rm = TRUE),
  returgrad_pct = round(mean(retur_binart, na.rm = TRUE) * 100, 1)
) %>%
  arrange(desc(returgrad_pct))

print(returgrad_kategori)
  
  # Figur 1: Stapeldiagram: returgard per kategori
fig1 <- ggplot(returgrad_kategori,
               aes(x=reorder(product_category, returgrad_pct),
                   y=returgrad_pct,
                   fill=returgrad_pct)) +
  geom_col(show.legend = FALSE) +
  geom_text(aes(label = paste0(returgrad_pct, "%")),
            hjust=-0.15, size = 3.5) +
  coord_flip() +
  scale_fill_gradient(low="blue", high="orange")+
  scale_y_continuous(limits = c(0, max(returgrad_kategori$returgrad_pct) * 1.15)) +
  labs(
    title = "Returgrad per produktkategori",
    subtitle = "Andel ordrar som returerats (%)",
    x = "Produktkategori",
    y = "Returgrad (%)"
  ) +

theme_minimal(base_size = 12) +
theme(plot.title = element_text(face = "bold"))

print(fig1)


# Returgrad per Region
cat("---2. Returgrad per region---\n")
returgrad_region <- data_analys %>%
  group_by(region) %>%
  summarise(
    antal_ordrar  = n(),
    antal_returer = sum(retur_binart, na.rm = TRUE),
    returgrad_pct = round(mean(retur_binart, na.rm = TRUE) * 100, 1)
  ) %>%
  arrange(desc(returgrad_pct))

print(returgrad_region)


# Figur 2: Stapeldiagram: returgard per region
fig2 <- ggplot(returgrad_region,
               aes(x=reorder(region, returgrad_pct),
                   y=returgrad_pct,
                   fill=region)) +
  geom_col(show.legend = FALSE) +
  geom_text(aes(label = paste0(returgrad_pct, "%")),
            hjust=-0.15, size = 3.5) +
  coord_flip() +
  scale_y_continuous(limits = c(0, max(returgrad_region$returgrad_pct) * 1.15)) +
  labs(
    title = "Returgrad per region",
    subtitle = "Andel ordrar som returerats (%)",
    x = "Region",
    y = "Returgrad (%)"
  ) +
  
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold"))

print(fig2)

  
  # Returgrad per kundsegment och kundtyp
  cat("---3. Returgrad per kundsegment---\n")
returgrad_segment <- data_analys %>%
  group_by(customer_segment) %>%
  summarise(
    antal_ordrar  = n(),
    antal_returer = sum(retur_binart, na.rm = TRUE),
    returgrad_pct = round(mean(retur_binart, na.rm = TRUE) * 100, 1)
  ) %>%
  arrange(desc(returgrad_pct))

print(returgrad_segment)

cat("\n--- Returgrad per kundtyp (VIP / New / Regular etc.)---\n")

returgrad_kundtyp <- data_analys %>%
  group_by(customer_type) %>%
  summarise(
    antal_ordrar  = n(),
    antal_returer = sum(retur_binart, na.rm = TRUE),
    returgrad_pct = round(mean(retur_binart, na.rm = TRUE) * 100, 1)
  ) %>%
  arrange(desc(returgrad_pct))

print(returgrad_kundtyp)

#Kombinerad analys (fixad pipe)
# Figur 3: Stapeldiagram: returgard per segment x kundtyp

returgrad_komb <- data_analys %>%
  group_by(customer_segment, customer_type) %>%
summarise(
    returgrad_pct = round(mean(retur_binart, na.rm = TRUE) * 100, 1),
    .groups = "drop"
  )

fig3 <- ggplot(returgrad_komb,
               aes(x=customer_segment,
                   y=returgrad_pct,
                   fill=customer_type)) +
  geom_col(position = position_dodge(width = 0.75), width = 0.75) +
  geom_text(aes(label = paste0(returgrad_pct, "%")),
            position = position_dodge(width = 0.75),
            vjust = -0.4, size = 3) +
  scale_fill_brewer(palette = "Set2") +
  
  labs(
    title = "Returgrad per kundsegment och kundtyp",
    subtitle = "Andel returer (%)",
    x = "Kundsegment",
    y = "Returgrad (%)",
    fill = "Kundtyp") +
  
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold"))

print(fig3)


# Heatmap - Kategori x Region
cat("---4. Returgrad: kategori x region(heatmap)---\n")

returgrad_heat <- data_analys %>%
  group_by(product_category, region) %>%
  summarise(
    returgrad_pct = round(mean(retur_binart, na.rm = TRUE) * 100, 1),
    .groups = "drop"
  )



# Figur 4: Stapeldiagram: ret
fig4 <- ggplot(returgrad_heat, aes(x=region, 
                   y=returgrad_pct, fill=returgrad_pct)) +
  geom_tile(color = "white", linewidth = 0.5) +
  geom_text(aes(label = paste0(returgrad_pct, "%")), size =3) +
  scale_fill_gradient(low = "#e8f5e9", high = "#c62828",
                      name = "Returgrad(%)") +
  labs(
    title = "Returgrad per kategori och region",
    subtitle = "Mörkare färg = högre returgrad",
    x = "Region",
    y = "Produktkategori"
  ) +
  
  theme_minimal(base_size = 11) +
  theme(plot.title = element_text(face = "bold"))
  axis.text.x = element_text(angle = 30, hjust = 1)
  
  print(fig4)


