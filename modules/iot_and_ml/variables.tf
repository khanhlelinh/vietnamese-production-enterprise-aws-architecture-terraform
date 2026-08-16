variable "environment" {
  description = "Environment name"
  type        = string
}

variable "timestream_db_name" {
  description = "Timestream Database Name for IoT data"
  type        = string
  default     = "vpe-farm-telemetry-db"
}

variable "timestream_table_name" {
  description = "Timestream Table Name for IoT data"
  type        = string
  default     = "SensorData"
}

variable "iot_role_arn" {
  description = "IAM Role ARN for IoT Core to write to Timestream"
  type        = string
}

variable "sagemaker_role_arn" {
  description = "IAM Role ARN for SageMaker execution"
  type        = string
}

variable "sagemaker_container_image" {
  description = "ECR image URI for SageMaker inference container"
  type        = string
}

variable "s3_ml_bucket" {
  description = "S3 bucket storing ML models"
  type        = string
}
