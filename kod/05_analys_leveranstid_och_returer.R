library(dplyr)

library(ggplot2)

source("99_kör_hela_projektet.R")

str(data_raw)

summary(data_raw$leveranstid)

table(data_raw$returstatus)

data <- data_raw

library(dplyr)

data_clean <- data %>%
  
  filter(
    
    !is.na(shipping_days),
    
    !is.na(returned)
    
  ) %>%
  
  mutate(
    
    retur = ifelse(returned == "Yes", 1, 0)
    
  )


data_clean %>%
  
  group_by(retur) %>%
  
  summarise(
    
    antal = n(),
    
    medel_leveranstid = mean(shipping_days),
    
    median_leveranstid = median(shipping_days)
    
  )


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

retur_tabell

names(data)


library(ggplot2)

ggplot(retur_tabell,
       
       aes(x = leveranstidsgrupp, y = returandel)) +
  
  geom_col(fill = "steelblue") +
  
  scale_y_continuous(labels = scales::percent) +
  
  labs(
    
    title = "Returandel per leveranstidsgrupp",
    
    x = "Leveranstidsgrupp",
    
    y = "Andel returer"
    
  )


