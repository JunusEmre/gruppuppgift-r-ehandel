# Gruppuppgift i R – E-handelsanalys

## Syfte
Det här projektet handlar om att göra en utforskande dataanalys i R på ett e-handelsdataset.

Målet är att undersöka försäljning, returgrad och leveranstid för att få fram insikter som kan vara användbara för företaget.

## Valda frågeställningar
Gruppen har valt att arbeta med följande frågor:

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
│
├── kod/
│   ├── 01_las_in_data.R
│   ├── 02_datastadning_och_nya_variabler.R
│   ├── 03_analys_forsaljning_per_kategori.R
│   ├── 04_analys_returgrad_mellan_grupper.R
│   ├── 05_analys_leveranstid_och_returer.R
│   ├── 06_visualiseringar.R
│   └── 99_kor_hela_projektet.R
│
├── rapport-presentation/
│   ├── rapport_gruppuppgift.md
│   └── presentation_gruppuppgift.pptx
│
├── resultat/
│
├── .gitignore
└── README.md
```

## Beskrivning av mappar och filer

### `data/`
Här ligger datat som används i projektet.

- `raw/` innehåller originalfilen
- `bearbetad/` kan användas för städad eller bearbetad data

### `kod/`
Här ligger all R-kod för projektet.

- `01_las_in_data.R` läser in datat och visar en första översikt
- `02_datastadning_och_nya_variabler.R` städar datat och skapar nya variabler
- `03_analys_forsaljning_per_kategori.R` innehåller analys av fråga 1
- `04_analys_returgrad_mellan_grupper.R` innehåller analys av fråga 2
- `05_analys_leveranstid_och_returer.R` innehåller analys av fråga 3
- `06_visualiseringar.R` används för figurer och diagram
- `99_kor_hela_projektet.R` används för att köra projektet i rätt ordning

### `rapport-presentation/`
Här ligger den skriftliga rapporten och presentationen.

- `rapport_gruppuppgift.md` är gruppens rapport
- `presentation_gruppuppgift.pptx` är gruppens PowerPoint-presentation

### `resultat/`
Här kan gruppen spara resultat från analysen, till exempel figurer, tabeller och andra filer.

## Ansvarsfördelning

- **Yunus:** case, syfte, dataset, dataimport, datastädning, nya variabler och projektstruktur
- **Abdullah:** analys 1
- **Irfan:** analys 2
- **Nora:** analys 3
- **Biljana:** sammanfattning, slutsatser och presentation

## Hur projektet körs
Projektet öppnas i RStudio.

För att köra hela projektet från början till slut används filen:

`kod/99_kor_hela_projektet.R`

## Dataset
Datasetet som används i projektet är:

`data/raw/ecommerce_orders.csv`
