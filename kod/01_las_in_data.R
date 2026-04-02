# ===============================
# 01_las_in_data.R
# Läser in data och visar en första översikt
# ===============================

# Ladda paket
library(readr)
library(dplyr)
library(janitor)

# Läs in data
data_raw <- read_csv("data/raw/ecommerce_orders.csv", show_col_types = FALSE)

# Visa grundläggande information
cat("----- DATAÖVERSIKT -----\n")
cat("Antal rader och kolumner:\n")
print(dim(data_raw))

cat("\nKolumnnamn:\n")
print(names(data_raw))

cat("\nFörsta 6 raderna:\n")
print(head(data_raw))

cat("\nStruktur:\n")
str(data_raw)

cat("\nSaknade värden per kolumn:\n")
print(colSums(is.na(data_raw)))