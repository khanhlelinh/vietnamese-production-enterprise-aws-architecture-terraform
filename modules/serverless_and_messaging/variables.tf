variable "environment" {
  description = "Environment name"
  type        = string
}

variable "cognito_authorizer_id" {
  description = "Cognito User Pool Authorizer ID for API Gateway"
  type        = string
}

variable "lambda_execution_role_arn" {
  description = "IAM Role ARN for Lambda execution"
  type        = string
}
