variable "environment" {
  description = "Environment name"
  type        = string
}

variable "aws_account_id" {
  description = "AWS Account ID for S3 bucket uniqueness"
  type        = string
}

variable "glue_role_arn" {
  description = "IAM Role ARN for AWS Glue Crawlers and Jobs"
  type        = string
}
