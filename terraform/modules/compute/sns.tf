resource "aws_sns_topic" "airflow_forex_pipeline" {
  name = "airflow_forex_pipeline"
}

resource "aws_sns_topic_subscription" "email_dllopezr" {
    endpoint = "dllopezr@unal.edu.co"
    protocol = "email"
    topic_arn = aws_sns_topic.airflow_forex_pipeline.arn
}