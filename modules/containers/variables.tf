variable "environment" {
  description = "Environment name"
  type        = string
}

variable "app_subnet_ids" {
  description = "List of private subnet IDs where EKS pods will be scheduled"
  type        = list(string)
}

variable "eks_cluster_role_arn" {
  description = "IAM Role ARN for the EKS Cluster"
  type        = string
}

variable "fargate_pod_execution_role_arn" {
  description = "IAM Role ARN for Fargate Pod Execution"
  type        = string
}
