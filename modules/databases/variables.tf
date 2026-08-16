variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for Database security groups"
  type        = string
}

variable "vpc_cidr_sales" {
  description = "CIDR block of Sales VPC to allow access"
  type        = string
}

variable "db_subnet_ids" {
  description = "List of private subnet IDs for databases"
  type        = list(string)
}

variable "db_username" {
  description = "Master username for Aurora CRM"
  type        = string
  default     = "crmadmin"
}

variable "db_password" {
  description = "Master password for Aurora CRM"
  type        = string
  sensitive   = true
}
