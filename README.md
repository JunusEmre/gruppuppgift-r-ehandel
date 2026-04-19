# Gruppuppgift i R – E-handelsanalys

## Syfte
Det här projektet innehåller en utforskande dataanalys i R av ett e-handelsdataset.

Målet är att undersöka:
- vilka produktkategorier som driver högst försäljning
- hur returgrad skiljer sig mellan olika grupper
- om längre leveranstid verkar hänga ihop med fler returer

## Valda frågeställningar
1. Vilka produktkategorier driver högst försäljning?
2. Hur skiljer sig returgrad mellan olika grupper?
3. Finns det tecken på att längre leveranstid hänger ihop med fler returer?

## Projektstruktur

```text
gruppuppgift-r-ehandel/
│
├── data/
│   ├── raw/
│   │   └── ecommerce_orders.csv
│   └── bearbetad/
│       └── ecommerce_orders_stadad.csv
│
├── kod/
│   ├── 01_las_in_data.R
│   ├── 02_datastadning_och_nya_variabler.R
│   ├── 03_analys_forsaljning_och_returgrad.R
│   ├── 04_analys_returgrad_mellan_grupper.R
│   ├── 05_analys_leveranstid_och_returer.R
│   └── 99_kor_hela_projektet.R
│
├── rapport-presentation/
│   ├── rapport_gruppuppgift.Rmd
│   ├── rapport_gruppuppgift.html
│   └── presentation_gruppuppgift.pdf
│
├── resultat/
│   ├── figurer/
│   │   ├── forsaljning_per_kategori.png
│   │   ├── fig1_returgrad_kategori.png
│   │   ├── fig2_returgrad_region.png
│   │   ├── fig3_returgrad_segment_kundtyp.png
│   │   ├── fig4_heatmap_kategori_region.png
│   │   └── fig5_returgrad_per_leveranstidsgrupp.png
│   └── tabeller/
│
├── README.md
├── .gitignore
└── gruppuppgift-r-ehandel.Rproj
```

## Kort beskrivning av mapparna

### `data/`
Här ligger datat som används i projektet.
- `raw/` innehåller originalfilen
- `bearbetad/` innehåller den städade filen som används i analyserna

### `kod/`
Här ligger all R-kod.
- `01_las_in_data.R` läser in datat och visar en första översikt
- `02_datastadning_och_nya_variabler.R` städar datat och skapar nya variabler
- `03_analys_forsaljning_och_returgrad.R` innehåller analys av försäljning
- `04_analys_returgrad_mellan_grupper.R` innehåller analys av returgrad mellan grupper
- `05_analys_leveranstid_och_returer.R` innehåller analys av leveranstid och returer
- `99_kor_hela_projektet.R` kör hela projektet i rätt ordning

### `rapport-presentation/`
Här ligger rapporten och presentationen.
- `rapport_gruppuppgift.Rmd` är rapportfilen i R Markdown
- `rapport_gruppuppgift.html` är den renderade HTML-versionen
- `presentation_gruppuppgift.pdf` är presentationen

### `resultat/`
Här sparas resultat från analyserna.
- `figurer/` innehåller diagram som används i rapporten och presentationen
- `tabeller/` kan användas om gruppen vill spara tabeller separat

## Nya variabler som skapats
För att underlätta analysen skapades följande variabler:
- `pris_efter_rabatt`
- `ordervarde`
- `retur_binart`
- `leveransgrupp`

## Hur projektet körs

### Kör hela projektet
Öppna projektet i RStudio eller VS Code och kör:

```r
source("kod/99_kor_hela_projektet.R")
```

Det går också att köra från terminal:

```powershell
Rscript kod\99_kor_hela_projektet.R
```

### Rendera rapporten till HTML
Om du vill skapa HTML-rapporten, kör:

```r
rmarkdown::render("rapport-presentation/rapport_gruppuppgift.Rmd")
```

## Figurer som används i rapporten
Exempel på figurer som tas fram i projektet:
- total försäljning per produktkategori
- returgrad per produktkategori
- returgrad per region
- returgrad per kundsegment och kundtyp
- heatmap för returgrad per produktkategori och region
- returandel per leveranstidsgrupp

## Ansvarsfördelning
- **Yunus:** case, syfte, dataset, dataimport, datastädning, nya variabler och projektstruktur
- **Abdullahi:** analys 1
- **Irfan:** analys 2
- **Nora:** analys 3
- **Biljana:** sammanfattning, slutsatser och presentation

## Övrigt
Filen `gruppuppgift-r-ehandel.Rproj` är en projektfil för RStudio. Den är inte själva analysen, men den kan vara praktisk om man vill öppna hela projektet direkt i RStudio.
