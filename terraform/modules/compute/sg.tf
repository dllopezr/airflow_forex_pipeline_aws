resource "aws_security_group" "airflow_host_sg" {
  name        = "airflow_host_sg"
  description = "Security group for airflow host EC2"
  vpc_id      = "vpc-0b0bcdf57b81f20a1"

  ingress {
    description      = "Allow inbound for port 22"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "airflow_host_sg"
  }
}