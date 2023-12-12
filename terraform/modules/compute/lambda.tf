resource "aws_lambda_function" "download_forex_rates" {
  function_name = "download_forex_rates"

  s3_bucket   = "airflow-forex-pipeline-david-lopez"
  s3_key      = "download_forex_rates.zip"
  handler     = "lambda_function.lambda_handler"
  role        = "arn:aws:iam::921082494404:role/lambda_download_forex_rates"
  runtime     = "python3.10"
  timeout     = 60
  memory_size = 256

}
