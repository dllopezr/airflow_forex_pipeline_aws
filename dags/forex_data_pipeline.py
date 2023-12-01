import datetime, timedelta
from airflow import DAG
from airflow.providers.http.sensors.http import HttpSensor

default_args = {
    "owner": "airflow",
    "email_on_failure": False,
    "email_on_retry": False,
    "email": "admin@localhost.com",
    "retries": 1,
    "retry_delay": timedelta(minutes=5)
}

with DAG(
    dag_id="forex_data_pipeline",
    start_date=datetime.datetime(2023, 1, 1),
    schedule="@daily",
    catchup=False,
    default_args=default_args
):
    
    is_forex_rates_available = HttpSensor(
        task_id = "is_forex_rates_available",
        http_conn_id="forex_api",
        endpoint="marclamberti/f45f872dea4dfd3eaa015a4a1af4b39b",
        response_check=lambda response: "rates" in response.text,
        poke_interval=5,
        timeout=20
    )
