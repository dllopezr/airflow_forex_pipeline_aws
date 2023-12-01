resource "aws_instance" "airflow_host" {
    ami = "ami-0e83be366243f524a"
    instance_type = "t2.medium"
    security_groups = [ "airflow_host_sg" ]
    tags = {
        Name = "airflow_host"
  }
}