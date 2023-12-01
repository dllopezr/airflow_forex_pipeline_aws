terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67.0"
    }
  }
  backend "s3" {
    bucket         = "airflow-forex-pipeline-tf-s3-backend"
    key            = "terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform_state" 
  }
}

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

module "compute" {
  source             = "./modules/compute"
}
