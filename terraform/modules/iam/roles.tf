resource "aws_iam_instance_profile" "airflow_ec2_host_instance_profile" {
  name = "airflow_ec2_host_instance_profile"
  role = aws_iam_role.airflow_ec2_host_role.name
}

resource "aws_iam_role" "airflow_ec2_host_role" {
  name               = "airflow_ec2_host_role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_policy.json
  managed_policy_arns = [
    "arn:aws:iam::921082494404:policy/airflow_host_ec2_s3_access"
    ]
}