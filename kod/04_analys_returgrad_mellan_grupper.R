# ==========================================
# 04_analys_returgrad_mellan_grupper.R
# Analys av returgrad mellan olika grupper.
# Fråga: Hur skiljer sig returgrad mellan.
# kategorier, regioner och kundgrupper?
# ==========================================

# Paket
library(readr)
library(dplyr)
library(ggplot2)
library(stringr)
#
# Läs in den städade datan
data_analys <- read_csv("data/bearbetad/ecommerce_orders_stadad.csv", show_col_types = FALSE)

# Skapa mapp för figurer om den inte finns
dir.create("resultat/figurer", recursive = TRUE, showWarnings = FALSE)

cat("----- Analys: returgrad mellan grupper -----\n")
cat("Antal rader i datat:", nrow(data_analys), "\n\n")


total_returgrad <- round(mean(data_analys$retur_binart, na.rm = TRUE) * 100, 1)
cat("Total returgrad (hela datasetet):", total_returgrad, "\n\n")

berakna_returgrad <- function(data, grupperingskol){
  data %>%
    group_by(across(all_of(grupperingskol))) %>%
      summarise(
        antal_ordrar = n(),
        antal_returer = sum(as.numeric(retur_binart), na.rm = TRUE),
        returgrad_pct = round(mean(as.numeric(retur_binart), na.rm = TRUE) * 100, 1),
        .groups = "drop"
      ) %>%
      arrange(desc(returgrad_pct))
}

# ==================================================
# 1. Returgrad per produktkategori
# ==================================================
cat("--- 1. Returgrad per produktkategori ---\n")

returgrad_kategori <- berakna_returgrad(data_analys, "product_category")
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
  scale_y_continuous(limits = c(0, max(returgrad_kategori$returgrad_pct) * 1.2)) +
  labs(
    title = "Returgrad per produktkategori",
    subtitle = "Andel ordrar som har returnerats (%)",
    x = "Produktkategori",
    y = "Returgrad (%)"
  ) +
  
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold"))

print(fig1)

ggsave("resultat/figurer/fig1_returgrad_kategori.png",
       plot = fig1, width = 8, height = 5, dpi = 150)

#cat("Figur 1 sparad i resultat/figurer.\n\n")

#Tolkning
cat("TOLKNING figur 1:\n")
cat("Kategorin med HÖGST returgrad är:",
    returgrad_kategori$product_category[1],
    "(", returgrad_kategori$returgrad_pct[1], "%).\n")

cat("Kategorin med LÄGST returgrad är:",
    tail(returgrad_kategori$product_category, 1),
    "(", tail(returgrad_kategori$returgrad_pct, 1), "%).\n\n")
cat("Differens (max - min);",
returgrad_kategori$returgrad_pct[1] - tail(returgrad_kategori$returgrad_pct, 1), "procentenheter.\n\n")


# ==================================================
# 2. Returgrad per region
# ==================================================
cat("--- 2. Returgrad per region ---\n")

returgrad_region <- berakna_returgrad(data_analys, "region")

print(returgrad_region)


fig2 <- ggplot(returgrad_region,
               aes(x = reorder(region, returgrad_pct),
                   y = returgrad_pct,
                   fill = region)) +
  geom_col(show.legend = FALSE) +
  geom_text(aes(label = paste0(returgrad_pct, "%")),
            hjust = -0.15, size = 3.5) +
  coord_flip() +
  scale_y_continuous(limits = c(0, max(returgrad_region$returgrad_pct) * 1.2)) +
  labs(
    title = "Returgrad per region",
    subtitle = "Andel ordrar som har returnerats (%)",
    x = "Region",
    y = "Returgrad (%)"
  ) +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold"))

print(fig2)

ggsave("resultat/figurer/fig2_returgrad_region.png",
       plot = fig2, width = 7, height = 4, dpi = 150)
#Tolkning
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

# customer_segment = Consumer / Corporate / Small Business
# customer_type = New / Returning / VIP

returgrad_segment <- berakna_returgrad(data_analys, "customer_segment")
print(returgrad_segment) 

returgrad_kundtyp <- berakna_returgrad(data_analys, "customer_type")
print(returgrad_kundtyp)


# Kombinerad figur: kundsegment x kundtyp -> Visar om mönstret skiljer sig
returgrad_komb <- data_analys %>%
  group_by(customer_segment, customer_type) %>%
  summarise(
    antal_ordrar = n(),
    returgrad_pct = round(mean(as.numeric(retur_binart), na.rm = TRUE) * 100, 1),
    .groups = "drop"
  )

cat(" Kombination segment x kundtyp --\n")
print(returgrad_komb)

# position_dodge() placerar staplarna sida vid sida inom varje segment

fig3 <- ggplot(returgrad_komb,
               aes(x = customer_segment,
                   y = returgrad_pct,
                   fill = customer_type)) +
  geom_col(position = position_dodge(width = 0.75), width = 0.70) +
  geom_text(aes(label = paste0(returgrad_pct, "%")),
            position = position_dodge(width = 0.75),
            vjust = -0.4, size = 3) +
  scale_fill_brewer(palette = "Set2") +
  labs(
    title = "Varje grupp av staplar = ett segment; färg = kundtyp",
    subtitle = "Andel returer (%)",
    x = "Kundsegment",
    y = "Returgrad (%)",
    fill = "Kundtyp"
  ) +
  
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold"))

print(fig3)

ggsave("resultat/figurer/fig3_returgrad_segment_kundtyp.png",
       plot = fig3, width = 9, height = 5, dpi = 150)

cat("TOLKNING figur 3:\n")

cat("Kundtypen med HÖGST returgrad totalt:",
    returgrad_kundtyp$customer_type[1],
    "(", returgrad_kundtyp$returgrad_pct[1], "%).\n")

cat("Kundtypen med LÄGST returgrad är:",
    tail(returgrad_kundtyp$customer_type, 1),
    "(", tail(returgrad_kundtyp$returgrad_pct, 1), "%).\n\n")


# ==================================================
# 4. Heatmap: returgrad per kategori och region
# ==================================================
cat("--- 4. Heatmap - kategori x region ---\n")

returgrad_heat <- data_analys %>%
  group_by(product_category, region) %>%
  summarise(
    returgrad_pct = round(mean(as.numeric(retur_binart), na.rm = TRUE) * 100, 1),
    .groups = "drop"
  )

print(returgrad_heat)

fig4 <- ggplot(returgrad_heat,
               aes(x = region,
                   y = product_category,
                   fill = returgrad_pct)) +
  geom_tile(color = "white", linewidth = 0.6) +
  geom_text(aes(label = paste0(returgrad_pct, "%")), size = 3.2) +
  scale_fill_gradient(low = "#e8f5e9", high = "#c62828",
                      name = "Returgrad (%)") +
  labs(
    title = "Returgrad per produktkategori och region",
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
       plot = fig4, width = 9, height = 5.5, dpi = 150)

cat("TOLKNING figur 4:\n")

worst <- returgrad_heat %>% slice_max(returgrad_pct, n = 1)
best <- returgrad_heat %>% slice_min(returgrad_pct, n = 1)

cat("\nKombination med HÖGST returgrad:",
    worst$product_category, "x", worst$region,
    "(", worst$returgrad_pct, "%)\n")

cat("\nKombination med LÄGST returgrad:",
    best$product_category, "x", best$region,
    "(", best$returgrad_pct, "%)\n\n")


# ==================================================
# 5. Sammanfattning
# ==================================================
cat("--- Sammanfattning ---\n")

cat("Total returgrad:", total_returgrad, "%\n\n")

cat("Top 3 kategorier med HÖGST returgrad:\n")
print(head(returgrad_kategori[, c("product_category", "antal_ordrar", "returgrad_pct")], 3))

cat("\nRegion med HÖGST returgrad:\n")
print(returgrad_region[1, c("region", "antal_ordrar", "returgrad_pct")])

cat("\nKundtyp med HÖGST returgrad:\n")
print(returgrad_kundtyp[1, c("customer_type", "antal_ordrar", "returgrad_pct")])

cat("\nKundsegment med HÖGST returgrad:\n")
print(returgrad_segment[1, c("customer_segment", "antal_ordrar", "returgrad_pct")])

cat("\nAlla figurer sparade i: resultat/figurer/\n")
cat(" fig1_returgrad_kategori.png\n")
cat(" fig2_returgrad_region.png\n")
cat(" fig3_returgrad_segment_kundtyp.png\n")
cat(" fig4_returgrad_kategori_region.png\n")