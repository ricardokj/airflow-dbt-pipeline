# airflow-dbt-pipeline
A hands-on data engineering portfolio project demonstrating an end-to-end data pipeline using Apache Airflow, DBT Core, and PostgreSQL, all orchestrated with Docker Compose.

This project showcases ETL/ELT practices, including raw and staging schemas, automated data loading, transformation, and summary modeling.

# Project Overview
This repository contains a complete, containerized data pipeline for demonstration and learning purposes:

- Apache Airflow orchestrates the workflow.
- DBT Core (run in a Python virtual environment) performs SQL-based data transformations.
- PostgreSQL serves as the data warehouse, with raw_data and staging schemas.
- CSV files are loaded into staging tables, then transformed and upserted into the raw data tables, and finally summarized.

---

## How It Works

1. **Database Initialization**
    - On startup, Postgres runs `init_db.sql` to create the `staging` schema and tables.
    - The `raw_data` schema and tables are also present.

2. **Data Loading**
    - Airflow DAGs orchestrate loading CSV files from `/data` into the `staging` tables.

3. **DBT Transformations**
    - Downstream Airflow tasks trigger DBT models (run via venv) to upsert data from `staging` into the `raw_data` schema.
    - A final Airflow task runs a summary DBT model, producing aggregated results.

---

## Getting Started

### Prerequisites

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- [Python 3.8+](https://www.python.org/) (for running DBT in venv)

### Setup Steps

1. **Clone this repository**
    ```
    git clone https://github.com/ricardokj/airflow-dbt-pipeline.git
    cd airflow-dbt-pipeline
    ```

2. **Review/Edit `.env` file**
    - The `.env` file contains demo credentials and connection info (safe for demo use).

3. **Start the pipeline**
    ```
    docker compose up --build
    ```

4. **Access Airflow UI**
    - Navigate to [http://localhost:8080](http://localhost:8080)
    - Default credentials: `airflow` / `airflow`

5. **Trigger the DAG**
    - Run the demo DAG to load, transform, and summarize the data.

---

## Environment Variables

All sensitive/demo configuration is stored in `.env` (included for demonstration):

| Variable           | Description            |
|--------------------|-----------------------|
| POSTGRES_USER      | Postgres username     |
| POSTGRES_PASSWORD  | Postgres password     |
| POSTGRES_DB        | Database name         |
| POSTGRES_HOST      | Hostname for Postgres |
| AIRFLOW_POSTGRES_USER | Airflow Postgres username |
| AIRFLOW_POSTGRES_PASSWORD | Airflow Postgres password |
| AIRFLOW_POSTGRES_DB | Airflow Postgres database name |

---

## Key Features

- **End-to-end orchestration** with Airflow
- **Modular SQL transformations** with DBT Core
- **Automated data loading** from CSV to staging
- **Upserts and summaries** for raw and aggregate tables
- **Containerized and reproducible** with Docker Compose

---
