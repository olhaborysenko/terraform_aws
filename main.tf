terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3"{
      bucket = "borysenko-terraform-state"
      key    = "state/terraform.tfstate"
      region = "eu-west-1"
      shared_credentials_file = "~/.aws/credentials"
  }
}
# Configure the AWS Provider
provider "aws" {
  region = "eu-west-1"
  profile = "default"
}
