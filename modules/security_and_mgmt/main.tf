# ------------------------------------------------------------------------------
# VPE Security and Management Module
# ------------------------------------------------------------------------------

# Dummy IAM Roles for completeness

resource "aws_iam_role" "eks_cluster" {
  name = "${var.environment}-vpe-eks-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{ Action = "sts:AssumeRole", Principal = { Service = "eks.amazonaws.com" }, Effect = "Allow" }]
  })
}

resource "aws_iam_role" "fargate_execution" {
  name = "${var.environment}-vpe-fargate-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{ Action = "sts:AssumeRole", Principal = { Service = "eks-fargate-pods.amazonaws.com" }, Effect = "Allow" }]
  })
}

resource "aws_iam_role" "iot_role" {
  name = "${var.environment}-vpe-iot-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{ Action = "sts:AssumeRole", Principal = { Service = "iot.amazonaws.com" }, Effect = "Allow" }]
  })
}

resource "aws_iam_role" "sagemaker_role" {
  name = "${var.environment}-vpe-sagemaker-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{ Action = "sts:AssumeRole", Principal = { Service = "sagemaker.amazonaws.com" }, Effect = "Allow" }]
  })
}

resource "aws_iam_role" "glue_role" {
  name = "${var.environment}-vpe-glue-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{ Action = "sts:AssumeRole", Principal = { Service = "glue.amazonaws.com" }, Effect = "Allow" }]
  })
}

resource "aws_iam_role" "lambda_role" {
  name = "${var.environment}-vpe-lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{ Action = "sts:AssumeRole", Principal = { Service = "lambda.amazonaws.com" }, Effect = "Allow" }]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.environment}-vpe-ec2-profile"
  role = aws_iam_role.lambda_role.name # Dummy assignment
}
