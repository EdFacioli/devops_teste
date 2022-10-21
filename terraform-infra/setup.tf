terraform {
  backend "s3" {
    bucket = "terraform-state-amopromo-infra"
    key    = "terraform/terraform.tfstate"
    region = "sa-east-1"
  }

  required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "~> 4.0"
    }
  }
}

provider "aws" {
    region = "sa-east-1"
}