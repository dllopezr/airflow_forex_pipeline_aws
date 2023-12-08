data "aws_iam_policy_document" "ec2_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "airflow_host_ec2_s3_access" {
  name        = "airflow_host_ec2_s3_access"
  description = "This policy grants s3 granular access to the airflow EC2 host"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
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