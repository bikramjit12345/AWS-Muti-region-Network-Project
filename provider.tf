
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


# Configure the AWS Provider
provider "aws" {
  alias  = "us"
  region = "us-east-1"

}


provider "aws" {
  alias  = "eu"
  region = "eu-west-1"

}

