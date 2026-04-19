# ==========================================
# 99_kor_hela_projektet.R
# Kör hela projektet i rätt ordning
# ==========================================

cat("Startar projektet...\n\n")

# 1. Läs in data och visa första översikt
cat("Kör 01_las_in_data.R ...\n")
source("kod/01_las_in_data.R")

cat("\n----------------------------------------\n")

# 2. Datastädning och skapande av nya variabler
cat("Kör 02_datastadning_och_nya_variabler.R ...\n")
source("kod/02_datastadning_och_nya_variabler.R")

cat("\n----------------------------------------\n")

# 3. Analys av försäljning
cat("Kör 03_analys_forsaljning_och_returgrad.R ...\n")
source("kod/03_analys_forsaljning_och_returgrad.R")

cat("\n----------------------------------------\n")

# 4. Analys av returgrad mellan grupper
cat("Kör 04_analys_returgrad_mellan_grupper.R ...\n")
source("kod/04_analys_returgrad_mellan_grupper.R")

cat("\n----------------------------------------\n")

# 5. Analys av leveranstid och returer
cat("Kör 05_analys_leveranstid_och_returer.R ...\n")
source("kod/05_analys_leveranstid_och_returer.R")

cat("\n----------------------------------------\n")
cat("Hela projektet är klart.\n")