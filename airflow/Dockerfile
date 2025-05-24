FROM apache/airflow:2.9.1

USER root
RUN apt-get update && apt-get install -y git
RUN python -m venv /dbt_venv && \
    /dbt_venv/bin/pip install dbt-postgres
ENV PATH="/dbt_venv/bin:$PATH"
USER airflow