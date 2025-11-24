# Steam Online Predictor (ETL & ML Pipeline)

An end-to-end Data Science project that forecasts the number of concurrent players for Steam games one month in advance. It combines a robust ETL pipeline with machine learning and time-series analysis.

## 📊 Project Overview
- **Data Collection:** Custom scrapers collect game stats, prices, and reviews from Steam and external datasets (Kaggle/Mendeley).
- **ETL Pipeline:** Processing raw CSV data, currency conversion, and loading into a Data Warehouse (PostgreSQL) with Stage/Main zones.
- **Modeling:** Comparison of multiple approaches to find the best prediction model:
  - **Machine Learning:** XGBoost, LightGBM, LinearSVR.
  - **Time Series:** SARIMA (ARIMA) and **SARIMAX** (ARIMAX).

## 🛠 Tech Stack
- **Languages:** Python, SQL
- **Libraries:** Pandas, Scikit-Learn, XGBoost, LightGBM, PmdArima, Statsmodels
- **Database:** PostgreSQL
- **Tools:** Jupyter Notebooks

## Project Structure

- `code/initial_processing/`: Scripts for parsing and initial CSV data cleaning.
- `code/stage_and_main_zones/`: SQL scripts for Data Warehouse setup and ETL processes.
- `code/main/`: Jupyter Notebooks containing model training, evaluation, and analytics.
- `docs/`: Project documentation and presentation materials.

## ⚡ How to Run

1. **Database Setup:**
   - Install PostgreSQL.
   - Run scripts from `code/stage_and_main_zones/` to create the schema and tables.

2. **Python Environment:**
   - Install dependencies:
     ```bash
     pip install pandas sklearn xgboost lightgbm statsmodels psycopg2 matplotlib seaborn
     ```

3. **Execution:**
   - Run the Jupyter Notebooks in `code/main/` to reproduce the experiments and view the forecasts.