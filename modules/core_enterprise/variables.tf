variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where resources will be deployed"
  type        = string
}

variable "vpc_cidr_core" {
  description = "CIDR block for security group rules"
  type        = string
}

variable "app_subnet_ids" {
  description = "List of private subnet IDs for Apps (EC2)"
  type        = list(string)
}

variable "db_subnet_ids" {
  description = "List of private subnet IDs for Databases (RDS)"
  type        = list(string)
}

variable "sles_sap_ami_id" {
  description = "AMI ID for SUSE Linux Enterprise Server for SAP Applications"
  type        = string
  default     = "ami-xxxxxxxxxxxxxxxxx" # Requires valid AMI from AWS Marketplace
}

variable "ec2_key_name" {
  description = "SSH Key Pair name"
  type        = string
  default     = "vpe-prod-key"
}

variable "ec2_instance_profile" {
  description = "IAM Instance Profile for EC2 (SSM, S3 access)"
  type        = string
}

variable "db_username" {
  description = "Master username for Oracle RDS"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Master password for Oracle RDS"
  type        = string
  sensitive   = true
}
