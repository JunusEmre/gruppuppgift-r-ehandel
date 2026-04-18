# 05_analys_leveranstid_och_returer.R

library(dplyr)
library(ggplot2)
library(readr)

# Läs in den städade datan

data_raw <- read_csv("data/bearbetad/ecommerce_orders_stadad.csv", show_col_types = FALSE)

# Skapa mapp för figurer om den inte finns
dir.create("resultat/figurer", recursive = TRUE, showWarnings = FALSE)

# Kontrollera data - använd rätt kolumnnamn
str(data_raw)

summary(data_raw$shipping_days)       # Ändrat från Leveranstid
table(data_raw$returned)              # Ändrat från nreturstatus

data <- data_raw

data_clean <- data %>%
  
  filter(
    
    !is.na(shipping_days),
    
    !is.na(returned)
    
  ) %>%
  
  mutate(
    
    retur = ifelse(returned == "Yes", 1, 0)
    
  )

# Jämför leversantid mellan retur och icke retur
data_clean %>%
  
  group_by(retur) %>%
  
  summarise(
    
    antal = n(),
    
    medel_leveranstid = mean(shipping_days),
    
    median_leveranstid = median(shipping_days)
    
  )

# Skapa leveranstidsgrupper och beräkna returandel
retur_tabell <- data_clean %>%
  
  mutate(
    
    leveranstidsgrupp = case_when(
      
      shipping_days <= 3 ~ "Snabb",
      
      shipping_days <= 7 ~ "Normal",
      
      TRUE ~ "Lång"
      
    )
    
  ) %>%
  
  group_by(leveranstidsgrupp) %>%
  
  summarise(
    
    antal_ordrar = n(),
    
    returandel = mean(retur)
    
  )

print(retur_tabell)

names(data)

# skapa diagram


fig5 <- ggplot(retur_tabell,
       
       aes(x = leveranstidsgrupp, y = returandel)) +
  
  geom_col(fill = "steelblue") +
  
  scale_y_continuous(labels = scales::percent) +
  
  labs(
    
    title = "Returandel per leveranstidsgrupp",
    
    x = "Leveranstidsgrupp",
    
    y = "Andel returer"
    
  )

ggsave("resultat/figurer/fig5_returgrad_per_leveranstidsgrupp.png", 
       plot = fig5, width = 8, height = 5, dpi = 150)

cat("Figuren sparad i resultat/figurer.\n\n")