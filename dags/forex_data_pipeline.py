from datetime import datetime, timedelta
from airflow import DAG
from airflow.providers.http.sensors.http import HttpSensor
from airflow.providers.amazon.aws.sensors.s3 import S3KeySensor
from airflow.providers.amazon.aws.operators.lambda_function import LambdaInvokeFunctionOperator
from airflow.providers.amazon.aws.operators.glue import GlueJobOperator
from airflow.providers.amazon.aws.operators.sns import SnsPublishOperator
from airflow.providers.amazon.aws.notifications.sns import SnsNotifier

default_args = {
    "owner": "airflow",
    "email_on_failure": False,
    "email_on_retry": False,
    "email": "admin@localhost.com",
    "retries": 0,
    "retry_delay": timedelta(minutes=5)
}

dag_failure_sns_notification = SnsNotifier(
    aws_conn_id = "aws_default",
    message = "The DAG {{ dag.dag_id }} failed",
    subject = "Airlfow Pipeline Failed", 
    target_arn = "arn:aws:sns:us-east-2:921082494404:airflow_forex_pipeline",
)

with DAG(
    dag_id="forex_data_pipeline",
    start_date=datetime(2023, 1, 1),
    schedule="@daily",
    catchup=False,
    default_args=default_args,
    on_failure_callback=[dag_failure_sns_notification]
):
    
    is_forex_rates_available = HttpSensor(
        task_id = "is_forex_rates_available",
        http_conn_id="forex_api",
        endpoint="marclamberti/f45f872dea4dfd3eaa015a4a1af4b39b",
        response_check=lambda response: "rates" in response.text,
        poke_interval=5,
        timeout=20
    )

    is_forex_currencies_file_available = S3KeySensor(
        task_id = "is_forex_currencies_file_available",
        bucket_key = "forex_currencies.csv",
        bucket_name = "airflow-forex-pipeline-david-lopez",
        aws_conn_id = "aws_default",
        poke_interval=5,
        timeout=20
    )

    downloading_rates = LambdaInvokeFunctionOperator(
        task_id = "downloading_rates",
        function_name = "download_forex_rates",
        aws_conn_id="aws_default"
    )

    transform_forex_rates = GlueJobOperator(
        task_id = "transform_forex_rate",
        job_name = "transform_forex_rates"
    )

    succesfull_execution_sns = SnsPublishOperator(
        task_id = "succesfull_execution_sns",
        aws_conn_id = "aws_default",
        target_arn = "arn:aws:sns:us-east-2:921082494404:airflow_forex_pipeline",
        message = f"Airflow Forex Data Pipeline has been succesfully executed at {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}",
        subject = "Airflow Forex Data Pipeline"
    )


    is_forex_rates_available >> is_forex_currencies_file_available >> downloading_rates >> transform_forex_rates >> succesfull_execution_sns
