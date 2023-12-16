resource "aws_glue_job" "transform_forex_rates" {
    name        = "transform_forex_rates"
    description = "Read json files from forex-rates-data-david-lopez, convert the files to csv and stores in transformed-forex-rates-david-lopez"
    role_arn = "arn:aws:iam::921082494404:role/glue_service_role"
    command {
        script_location = "s3://airflow-forex-pipeline-david-lopez/transform_forex_rates.py"
    }
    worker_type = "G.1X"
    number_of_workers = 2
    glue_version = "4.0"
    timeout = 60
}