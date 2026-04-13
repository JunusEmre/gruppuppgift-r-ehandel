# ==========================================
# 04_analys_returgrad_mellan_grupper.R
# Analys av returgrad mellan olika grupper
# Fråga: Hur skiljer sig returgrad mellan
# kategorier, regioner och kundgrupper?
# ==========================================

# Paket
library(readr)
library(dplyr)
library(ggplot2)
library(stringr)

# Läs in den städade datan
data_analys <- read_csv("data/bearbetad/ecommerce_orders_stadad.csv", show_col_types = FALSE)

# Skapa mapp för figurer om den inte finns
dir.create("resultat/figurer", recursive = TRUE, showWarnings = FALSE)

cat("----- Analys: returgrad mellan grupper -----\n")
cat("Antal rader i datat:", nrow(data_analys), "\n\n")

# ==================================================
# 1. Returgrad per produktkategori
# ==================================================
cat("--- 1. Returgrad per produktkategori ---\n")

returgrad_kategori <- data_analys %>%
  group_by(product_category) %>%
  summarise(
    antal_ordrar = n(),
    antal_returer = sum(retur_binart, na.rm = TRUE),
    returgrad_pct = round(mean(retur_binart, na.rm = TRUE) * 100, 1),
    .groups = "drop"
  ) %>%
  arrange(desc(returgrad_pct))

print(returgrad_kategori)

fig1 <- ggplot(returgrad_kategori,
               aes(x = reorder(product_category, returgrad_pct),
                   y = returgrad_pct,
                   fill = returgrad_pct)) +
  geom_col(show.legend = FALSE) +
  geom_text(aes(label = paste0(returgrad_pct, "%")),
            hjust = -0.15, size = 3.5) +
  coord_flip() +
  scale_fill_gradient(low = "#90caf9", high = "#ef6c00") +
  scale_y_continuous(limits = c(0, max(returgrad_kategori$returgrad_pct) * 1.15)) +
  labs(
    title = "Returgrad per produktkategori",
    subtitle = "Andel ordrar som har returnerats (%)",
    x = "Produktkategori",
    y = "Returgrad (%)"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold")
  )

print(fig1)

ggsave("resultat/figurer/fig1_returgrad_kategori.png",
       plot = fig1, width = 8, height = 5, dpi = 150)

cat("Figur 1 sparad i resultat/figurer.\n\n")

cat("TOLKNING figur 1:\n")
cat("Kategorin med högst returgrad är:",
    returgrad_kategori$product_category[1],
    "(", returgrad_kategori$returgrad_pct[1], "%).\n")

cat("Kategorin med lägst returgrad är:",
    tail(returgrad_kategori$product_category, 1),
    "(", tail(returgrad_kategori$returgrad_pct, 1), "%).\n\n")


# ==================================================
# 2. Returgrad per region
# ==================================================
cat("--- 2. Returgrad per region ---\n")

returgrad_region <- data_analys %>%
  group_by(region) %>%
  summarise(
    antal_ordrar = n(),
    antal_returer = sum(retur_binart, na.rm = TRUE),
    returgrad_pct = round(mean(retur_binart, na.rm = TRUE) * 100, 1),
    .groups = "drop"
  ) %>%
  arrange(desc(returgrad_pct))

print(returgrad_region)

fig2 <- ggplot(returgrad_region,
               aes(x = reorder(region, returgrad_pct),
                   y = returgrad_pct,
                   fill = region)) +
  geom_col(show.legend = FALSE) +
  geom_text(aes(label = paste0(returgrad_pct, "%")),
            hjust = -0.15, size = 3.5) +
  coord_flip() +
  scale_y_continuous(limits = c(0, max(returgrad_region$returgrad_pct) * 1.15)) +
  labs(
    title = "Returgrad per region",
    subtitle = "Andel ordrar som har returnerats (%)",
    x = "Region",
    y = "Returgrad (%)"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold")
  )

print(fig2)

ggsave("resultat/figurer/fig2_returgrad_region.png",
       plot = fig2, width = 7, height = 4, dpi = 150)

cat("Figur 2 sparad i resultat/figurer.\n\n")

cat("TOLKNING figur 2:\n")
cat("Regionen med högst returgrad är:",
    returgrad_region$region[1],
    "(", returgrad_region$returgrad_pct[1], "%).\n")

cat("Regionen med lägst returgrad är:",
    tail(returgrad_region$region, 1),
    "(", tail(returgrad_region$returgrad_pct, 1), "%).\n\n")


# ==================================================
# 3. Returgrad per kundsegment och kundtyp
# ==================================================
cat("--- 3. Returgrad per kundsegment ---\n")

returgrad_segment <- data_analys %>%
  group_by(customer_segment) %>%
  summarise(
    antal_ordrar = n(),
    antal_returer = sum(retur_binart, na.rm = TRUE),
    returgrad_pct = round(mean(retur_binart, na.rm = TRUE) * 100, 1),
    .groups = "drop"
  ) %>%
  arrange(desc(returgrad_pct))

print(returgrad_segment)

cat("\n--- Returgrad per kundtyp ---\n")

returgrad_kundtyp <- data_analys %>%
  group_by(customer_type) %>%
  summarise(
    antal_ordrar = n(),
    antal_returer = sum(retur_binart, na.rm = TRUE),
    returgrad_pct = round(mean(retur_binart, na.rm = TRUE) * 100, 1),
    .groups = "drop"
  ) %>%
  arrange(desc(returgrad_pct))

print(returgrad_kundtyp)

# Kombinerad figur: kundsegment x kundtyp
returgrad_komb <- data_analys %>%
  group_by(customer_segment, customer_type) %>%
  summarise(
    returgrad_pct = round(mean(retur_binart, na.rm = TRUE) * 100, 1),
    .groups = "drop"
  )

fig3 <- ggplot(returgrad_komb,
               aes(x = customer_segment,
                   y = returgrad_pct,
                   fill = customer_type)) +
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
    fill = "Kundtyp"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold")
  )

print(fig3)

ggsave("resultat/figurer/fig3_returgrad_segment_kundtyp.png",
       plot = fig3, width = 9, height = 5, dpi = 150)

cat("Figur 3 sparad i resultat/figurer.\n\n")

cat("TOLKNING figur 3:\n")
cat("Figuren visar om vissa kundtyper, till exempel VIP eller nya kunder,\n")
cat("har högre returgrad inom olika kundsegment.\n\n")


# ==================================================
# 4. Heatmap: returgrad per kategori och region
# ==================================================
cat("--- 4. Returgrad per kategori och region ---\n")

returgrad_heat <- data_analys %>%
  group_by(product_category, region) %>%
  summarise(
    returgrad_pct = round(mean(retur_binart, na.rm = TRUE) * 100, 1),
    .groups = "drop"
  )

print(returgrad_heat)

fig4 <- ggplot(returgrad_heat,
               aes(x = region,
                   y = product_category,
                   fill = returgrad_pct)) +
  geom_tile(color = "white", linewidth = 0.5) +
  geom_text(aes(label = paste0(returgrad_pct, "%")), size = 3) +
  scale_fill_gradient(low = "#e8f5e9", high = "#c62828",
                      name = "Returgrad (%)") +
  labs(
    title = "Returgrad per kategori och region",
    subtitle = "Mörkare färg = högre returgrad",
    x = "Region",
    y = "Produktkategori"
  ) +
  theme_minimal(base_size = 11) +
  theme(
    plot.title = element_text(face = "bold"),
    axis.text.x = element_text(angle = 30, hjust = 1)
  )

print(fig4)

ggsave("resultat/figurer/fig4_heatmap_kategori_region.png",
       plot = fig4, width = 10, height = 6, dpi = 150)

cat("Figur 4 sparad i resultat/figurer.\n\n")

cat("TOLKNING figur 4:\n")
cat("Heatmapen visar vilka kombinationer av produktkategori och region\n")
cat("som har särskilt hög eller låg returgrad.\n\n")


# ==================================================
# 5. Sammanfattning
# ==================================================
cat("--- Sammanfattning ---\n")

overgripande_returgrad <- round(mean(data_analys$retur_binart, na.rm = TRUE) * 100, 1)
cat("Övergripande returgrad:", overgripande_returgrad, "%\n\n")

cat("Top 3 kategorier med högst returgrad:\n")
print(head(returgrad_kategori[, c("product_category", "returgrad_pct")], 3))

cat("\nTop 3 kategorier med lägst returgrad:\n")
print(tail(returgrad_kategori[, c("product_category", "returgrad_pct")], 3))

cat("\nRegion med högst returgrad:\n")
print(returgrad_region[1, c("region", "returgrad_pct")])

cat("\nKundsegment med högst returgrad:\n")
print(returgrad_segment[1, c("customer_segment", "returgrad_pct")])