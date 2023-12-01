resource "aws_s3_bucket" "tf_s3_backend_bucket" {
    bucket = "airflow-forex-pipeline-tf-s3-backend"
    tags = {
        Name = "airflow_forex_pipeline_tf_s3_backend"
    }
}