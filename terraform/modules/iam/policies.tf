data "aws_iam_policy_document" "ec2_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "airflow_host_ec2_s3_access" {
  name        = "airflow_host_ec2_s3_access"
  description = "This policy grants s3 granular access to the airflow EC2 host"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "arn:aws:s3:::airflow-forex-pipeline-david-lopez/*",
                "arn:aws:s3:::airflow-forex-pipeline-david-lopez"
            ]
        }
    ]
})
}

resource "aws_iam_policy" "read_airflow_forex_pipeline_david_lopez" {
  name        = "read_airflow_forex_pipeline_david_lopez"
  description = "This policy grants read elements from airflow-forex-pipeline-david-lopez"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::airflow-forex-pipeline-david-lopez/*"
            ]
        }
    ]
})
}

resource "aws_iam_policy" "put_forex_rates_data" {
  name        = "put_forex_rates_date"
  description = "This policy grants put objects on the forex-rates-data-david-lopez bucket"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::forex-rates-data-david-lopez/*"
            ]
        }
    ]
  })
}

resource "aws_iam_policy" "create_logs" {
  name        = "create_logs"
  description = "Grant permissions to create and write logs in Cloudwatch"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
  })
}
