variable "aws_profile" {
  type        = string
  description = "AWS profile configuration. Used to connect to AWS"
  default     = "default"
}

variable "aws_region" {
  type        = string
  description = "AWS region to use for the resources creation"
  default     = "us-east-2"
}