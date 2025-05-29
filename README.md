# Cyclistic Bike-Share Analysis

This project analyzes bike-share data from Cyclistic — a fictional bike-share company in Chicago — with the goal of identifying behavioral differences between **casual riders** and **annual members**. The insights are intended to help design a marketing strategy to **convert casual riders into members**.

---

## Project Overview

- **Business Task**: How do casual riders and annual members use Cyclistic bikes differently?
- **Goal**: Identify patterns in ride behavior (duration, frequency, time of day, etc.) and recommend strategies to grow the number of annual members.

---

## Repository Structure
```
cyclistic_analysis/
├── data/
│ ├── raw/ # Raw trip data (not pushed to GitHub)
│ └── clean/ # Cleaned dataset used in analysis
├── code/
│ ├── data_preprocessing.R # Data cleaning and preprocessing
│ └── exploratory_analysis.R # EDA and visualizations
├── output/ # Visuals generated from analysis
├── Cyclist_Analysis_Report.Rmd # Markdown report
├── Cyclist_Analysis_Report.pdf # PDF report
└── README.md # This file
```

---

## Tools Used

-  R with the `tidyverse` ecosystem
- `ggplot2` for visualizations
- `lubridate` for time/date features
- RMarkdown for the final report

---

## Data Source

Trip data from [Divvy's public dataset](https://divvy-tripdata.s3.amazonaws.com/index.html), covering **April 2022 to March 2023**.

Due to size, raw data files are excluded from this repo. You can download and store them in `data/raw/`.

---

## How to Run the Project

1. Clone this repository:

    ```
    git clone https://github.com/sarim-bit/cyclist_analysis.git
    cd cyclistic_analysis
    ```
    
2. Open the project in RStudio.

3. Run the cleaning script:

    ```
    source("code/data_preprocessing.R")
    ```

4. Run the analysis:

    ```
    source("code/exploratory_analysis.R")
    ```

5. Or knit the full R Markdown report:

    ```
    rmarkdown::render("Cyclist_Analysis_Report.Rmd")
    ```

---
## Contact

Created by Sarim Rizvi – for questions, please reach out via GitHub [sarim-bit](https://github.com/sarim-bit).

 
