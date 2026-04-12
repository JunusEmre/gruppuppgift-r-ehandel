# Analys returgrad mellan grupper.
# Fråga: Hur skiljer sig returgraade mellan olika 
#Kategorier regioner och grupper?

# Paketer
library(readr)
library(ggplot2)
library(tidyverse)

# Läs in den städade datan som skapades i fil 02
data_analys <- read_csv("data/bearbetad/ecommerce_orders_stadad.csv", show_col_types = FALSE)


# Visa hur många rader vi har i datan
cat("----- Analys returgrad mellan grupper -----\n")
cat("Antal rader:", nrow(data_analys), "\n\n")

# Returgrad per produktkategori
cat("---1. Returgrad per produktkategori---\n")


# Vi grupperar datan efter kategori och räknar ut hur många ordrar
# som returnerades i varje grupp

returgrad_kategori <- data_analys %>%
group_by(product_category) %>%
summarise(
  antal_ordrar  = n(),
  antal_returer = sum(retur_binart, na.rm = TRUE),
  returgrad_pct = round(mean(retur_binart, na.rm = TRUE) * 100, 1)
) %>%
  # Sortera så att högst returgrad hamnar överst
  arrange(desc(returgrad_pct))

print(returgrad_kategori)
  
  # Figur 1: Stapeldiagram: för att lätt jämföra kategorier
fig1 <- ggplot(returgrad_kategori,
               aes(x=reorder(product_category, returgrad_pct),
                   y=returgrad_pct,
                   fill=returgrad_pct)) +
  geom_col(show.legend = FALSE) +
  # Skriv ut procent bredvide varje stapel
  geom_text(aes(label = paste0(returgrad_pct, "%")), 
            hjust=-0.15, size = 3.5) +
  # vänd diagrammet så kategorinamnen syns bättre
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

# Spara diagrammet som en bildfil
dir.create("output/figurer", recursive = TRUE, showWarnings = FALSE)
ggsave("output/figurer/fig1_returgrad_kategori.png",
       plot = fig1, width = 8, height = 5, dpi = 150)
cat("Figur 1 sparad.\n\n")

#Tolkning
cat("TOLKNING fig 1:\n")
cat("kategorin med högst returgrad är:",
    returgrad_kategori$product_category[1],
    "(", returgrad_kategori$returgrad_pct[1], "%).\n")

cat("kategorin med lägst returgrad är:",
   tail(returgrad_kategori$product_category, 1),
    "(", tail(returgrad_kategori$returgrad_pct, 1), "%).\n\n")

# Returgrad per region
cat("---2. Returgrad per region---\n")

# Vi gör samma beräkning som ovan, men grupperar vi region istället för kategori
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

# Spara figur 2
ggsave("output/figurer/fig2_returgrad_region.png",
       plot = fig2, width = 7, height = 4, dpi = 150)
cat("Figur 2 sparad.\n\n")

#Tolkning
cat("TOLKNING fig 2:\n")
cat("Regionen med högst returgrad är:",
returgrad_region$region[1],
"(", returgrad_region$returgrad_pct[1], "%).\n\n")

  
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

# Spara figur 3
ggsave("output/figurer/fig3_returgrad_segment_kund.typ.png",
       plot = fig3, width = 9, height = 5, dpi = 150)
cat("Figur 3 sparad.\n\n")

#Tolkning
cat("TOLKNING fig 3:\n")
cat("Jämförelsen visar om VIP- eller nya kunder returnerar mer\n")
cat("inom respektive segment, vilket kan styra riktade åtgärder.\n\n")


# Heatmap - Kategori x Region
# Visar returgraden för varje kombination av kategori och region
cat("---4. Returgrad: kategori x region(heatmap)---\n")

# Vi grupperar nu både kategori och region samtidigt
returgrad_heat <- data_analys %>%
  group_by(product_category, region) %>%
  summarise(
    returgrad_pct = round(mean(retur_binart, na.rm = TRUE) * 100, 1),
    .groups = "drop"
  )


# Figur 4: Stapeldiagram: ret
fig4 <- ggplot(returgrad_heat, 
               aes(x=region, 
                   y=returgrad_pct, 
                   fill=returgrad_pct)) +
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
  theme(
    plot.title = element_text(face = "bold"),
  axis.text.x = element_text(angle = 30, hjust = 1))

print(fig4)
  
# Spara figur 4
ggsave("output/figurer/fig4_heatmap_kategori_region.png",
       plot = fig4, width = 10, height = 6, dpi = 150)
cat("Figur 4 sparad.\n\n")

cat("TOLKNING fig 4:\n")
cat("Heatmapen identifierar kombinationer av kategori och region\n")
cat("med särskilt hög returgrad - användbara för riktade åtgärder.\n\n")
  
# Sammanfattning - de viktigaste sifrorna

cat("--- Sammanfattning ---\n")

overgripande_returgrad <- round(mean(data_analys$retur_binart, na.rm = TRUE) * 100, 1)
cat("Övergripande returgrad:", overgripande_returgrad, "%\n\n")

cat("Top 3 kategorier med HÖGST returgrad:\n")
print(head(returgrad_kategori[, c("product_category", "returgrad_pct")], 3))

cat("\nTop 3 kategorier med LÄGST returgrad:\n")
print(tail(returgrad_kategori[, c("product_category", "returgrad_pct")], 3))


cat("\nRegion med högst returgrad:\n")
print(returgrad_region[1, c("region", "returgrad_pct")])

cat("\nSegment med högst returgrad:\n")
print(returgrad_segment[1, c("customer_segment", "returgrad_pct")])


