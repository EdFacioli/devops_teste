terraform {
  backend "s3" {
    bucket = "terraform-state-devopschallenge-infra"
    key    = "terraform/terraform.tfstate"
    region = "us-east-2"
  }

  required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "~> 4.0"
    }
  }
}

provider "aws" {
    region = "us-east-2"
}