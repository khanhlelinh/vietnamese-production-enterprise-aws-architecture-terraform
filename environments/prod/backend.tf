# ------------------------------------------------------------------------------
# Provider and Backend Configuration for Production
# ------------------------------------------------------------------------------

terraform {
  required_version = ">= 1.5.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # NOTE: Initialize backend after creating the S3 bucket and DynamoDB table
  # backend "s3" {
  #   bucket         = "enterprise-terraform-state-prod"
  #   key            = "prod/terraform.tfstate"
  #   region         = "ap-southeast-1"
  #   dynamodb_table = "enterprise-terraform-locks-prod"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Environment = "prod"
      Project     = "Enterprise Migration"
      ManagedBy   = "Terraform"
    }
  }
}
