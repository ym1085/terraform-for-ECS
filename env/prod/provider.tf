# Terraform version
terraform {
  required_version = ">= 1.9.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Provider
provider "aws" {
  region = var.aws_region
}

# region
variable "aws_region" {
  description = "AWS Default Region"
  default     = "ap-northeast-2"
}
