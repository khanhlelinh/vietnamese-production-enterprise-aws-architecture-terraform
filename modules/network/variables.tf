variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
}

variable "vpc_cidr_core" {
  description = "CIDR block for Domain 1 - Core Enterprise"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_cidr_sales" {
  description = "CIDR block for Domain 2 - Sales & Commerce"
  type        = string
  default     = "10.1.0.0/16"
}

variable "vpc_cidr_iot" {
  description = "CIDR block for Domain 3 - Farm, Food, IoT"
  type        = string
  default     = "10.2.0.0/16"
}

variable "availability_zones" {
  description = "List of Availability Zones in the region"
  type        = list(string)
  default     = ["ap-southeast-1a", "ap-southeast-1b"]
}

variable "tags" {
  description = "Default tags for all network resources"
  type        = map(string)
  default     = {}
}
