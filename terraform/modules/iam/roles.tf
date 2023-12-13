resource "aws_iam_instance_profile" "airflow_ec2_host_instance_profile" {
  name = "airflow_ec2_host_instance_profile"
  role = aws_iam_role.airflow_ec2_host_role.name
}

resource "aws_iam_role" "airflow_ec2_host_role" {
  name               = "airflow_ec2_host_role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_policy.json
  managed_policy_arns = [
    "arn:aws:iam::921082494404:policy/airflow_host_ec2_s3_access",
    "arn:aws:iam::921082494404:policy/lambda_invoke_download_forex_rates"
    ]
}


resource "aws_iam_role" "lambda_download_forex_rates" {
  name               = "lambda_download_forex_rates"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
  managed_policy_arns = [
    "arn:aws:iam::921082494404:policy/put_forex_rates_date",
    "arn:aws:iam::921082494404:policy/read_airflow_forex_pipeline_david_lopez",
    "arn:aws:iam::921082494404:policy/create_logs"
    ]
}