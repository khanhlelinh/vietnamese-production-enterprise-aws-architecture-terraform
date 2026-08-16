variable "aws_region" {
  description = "AWS Region for deployment"
  type        = string
  default     = "ap-southeast-1"
}

variable "vpc_cidr_core" {
  description = "CIDR block for Core Enterprise VPC"
  type        = string
}

variable "vpc_cidr_sales" {
  description = "CIDR block for Sales & Commerce VPC"
  type        = string
}

variable "vpc_cidr_iot" {
  description = "CIDR block for IoT & Analytics VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of Availability Zones"
  type        = list(string)
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

variable "sagemaker_container_image" {
  description = "ECR image URI for SageMaker"
  type        = string
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "cognito_authorizer_id" {
  description = "Cognito authorizer ID for API Gateway"
  type        = string
}
