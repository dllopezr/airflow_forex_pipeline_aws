resource "aws_instance" "airflow_host_ec2" {
    ami = "ami-0e83be366243f524a"
    instance_type = "t2.medium"
    security_groups = [ "airflow_host_sg" ]
    iam_instance_profile = "airflow_ec2_host_instance_profile"
    tags = {
        Name = "airflow_host_ec2"
  }
}