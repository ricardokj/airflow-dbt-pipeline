from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator
from datetime import datetime
from utils.load_dw import load_dw

default_args = {
    'owner': 'airflow',
    'start_date': datetime(2025, 5, 24),
}

tables_to_load = {
    "airlines":"/opt/airflow/data/nyc_airlines.csv",
    "airports":"/opt/airflow/data/nyc_airports.csv",
    "flights":"/opt/airflow/data/nyc_flights.csv",
    "planes":"/opt/airflow/data/nyc_planes.csv",
    "weather":"/opt/airflow/data/nyc_weather.csv",
}

with DAG('flights_load',
         default_args=default_args,
         schedule_interval='@daily',
         max_active_runs=1) as dag:

    dbt_model_flights_summary = BashOperator(
        task_id=f'dbt_flights_summary',
        bash_command=f'dbt run --target curated --select curated.flights_summary'
    )

    for tab in tables_to_load:
        csv_load = PythonOperator(
            task_id=f'load_{tab}_csv_to_staging',
            python_callable=load_dw,
            op_kwargs={
                'table': tab,
                'source': tables_to_load[tab]
            }
        )

        dbt_model_run = BashOperator(
            task_id=f'dbt_load_{tab}',
            bash_command=f'dbt run --select staging_to_raw.{tab}'
        )
        csv_load >> dbt_model_run

        if tab == "flights":
            dbt_model_run >> dbt_model_flights_summary