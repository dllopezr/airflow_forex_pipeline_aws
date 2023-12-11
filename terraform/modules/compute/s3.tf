resource "aws_s3_bucket" "tf_s3_backend_bucket" {
    bucket = "airflow-forex-pipeline-tf-s3-backend"
    tags = {
        Name = "airflow_forex_pipeline_tf_s3_backend"
    }
}

resource "aws_s3_bucket" "airflow_forex_pipeline" {
    bucket = "airflow-forex-pipeline-david-lopez"
    tags = {
        Name = "airflow-forex-pipeline-david-lopez"
    }
}

resource "aws_s3_bucket" "forex_rates_data" {
    bucket = "forex-rates-data-david-lopez"
    tags = {
        Name = "forex-rates-data-david-lopez"
    }
}