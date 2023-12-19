resource "aws_athena_workgroup" "airflow_forex_rates_pipeline_workgroup" {
    name = "airflow_forex_rates_pipeline_workgroup"
    configuration {
        enforce_workgroup_configuration    = true
        publish_cloudwatch_metrics_enabled = true

        result_configuration {
            output_location = "s3://athena-query-outputs-david-lopez/"
        }
    }
}