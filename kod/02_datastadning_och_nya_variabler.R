# ==========================================
# 02_datastadning_och_nya_variabler.R
# Städar data och skapar nya variabler
# ==========================================

# Ladda paket
library(readr)
library(dplyr)
library(janitor)
library(stringr)

# Läs in data
data_clean <- read_csv("data/raw/ecommerce_orders.csv", show_col_types = FALSE)

# Städning av kolumnnamn
data_clean <- data_clean %>%
  clean_names()

# Städning av textvärden
data_clean <- data_clean %>%
  mutate(
    payment_method = str_trim(payment_method),
    campaign_source = str_trim(campaign_source),
    product_category = str_trim(product_category),
    customer_segment = str_trim(customer_segment),
    region = str_trim(region),
    city = str_trim(city),

    payment_method = str_to_title(payment_method),
    campaign_source = str_to_title(campaign_source),
    product_category = str_to_title(product_category),
    customer_segment = str_to_title(customer_segment),
    region = str_to_title(region),
    city = str_to_title(city)
  )

# Hantera saknade värden
# Här sätter vi saknad rabatt till 0
data_clean <- data_clean %>%
  mutate(
    discount_pct = if_else(is.na(discount_pct), 0, discount_pct)
  )

# Skapa nya variabler
data_clean <- data_clean %>%
  mutate(
    pris_efter_rabatt = unit_price * (1 - discount_pct),
    ordervarde = quantity * pris_efter_rabatt,
    retur_binart = if_else(returned == "Yes", 1, 0),

    leveransgrupp = case_when(
      shipping_days <= 2 ~ "Kort",
      shipping_days <= 4 ~ "Medel",
      shipping_days >= 5 ~ "Lang",
      TRUE ~ NA_character_
    )
  )

# Visa snabb kontroll
cat("----- STÄDAD DATA -----\n")
cat("Kolumnnamn efter städning:\n")
print(names(data_clean))

cat("\nFörsta 6 raderna efter städning:\n")
print(head(data_clean))

cat("\nSaknade värden efter städning:\n")
print(colSums(is.na(data_clean)))

# Skapa mapp om den inte finns
dir.create("data/bearbetad", recursive = TRUE, showWarnings = FALSE)

# Spara städad data
write_csv(data_clean, "data/bearbetad/ecommerce_orders_stadad.csv")

cat("\nStädad fil sparad i: data/bearbetad/ecommerce_orders_stadad.csv\n")