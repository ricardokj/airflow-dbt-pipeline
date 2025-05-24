
import os
import argparse
import logging
import psycopg2
import psycopg2.extras
from airflow.hooks.base import BaseHook

def _connect_db(host,port,username,password,database):
    """Create database connection

    :param config Configuration parameters
    """
    conn = psycopg2.connect(
        host=host,
        port=port,
        user=username,
        password=password,
        dbname=database
    )
    cursor = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
    return conn, cursor


def _get_source_path(source):
    """Build absolute source file path

    :param source Source path
    """
    current_path = os.path.dirname(os.path.abspath(__file__))
    return os.path.join(current_path, source)


def load_dw(table, source, schema='staging', delimiter=',', conn_id='postgres'):

    conn = BaseHook.get_connection(conn_id)
    host = conn.host
    port = conn.port
    username = conn.login
    password = conn.password
    database = conn.schema

    conn, cursor = _connect_db(host,port,username,password,database)
    source_path = _get_source_path(source)

    try:
        with open(source_path, 'r') as f:
            logging.info(f"Loading data from {source_path} into table {schema}.{table}")
            copy_sql = f"""
                DELETE FROM {schema}.{table} WHERE TRUE;
                COPY {schema}.{table} FROM STDIN WITH CSV DELIMITER '{delimiter}' HEADER
                """
            cursor.copy_expert(copy_sql, f)
            conn.commit()
            logging.info(f"Successfully loaded data into {schema}.{table}")
        conn.commit()
    finally:
        cursor.close()
        conn.close()