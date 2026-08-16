output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster.arn
}

output "fargate_execution_role_arn" {
  value = aws_iam_role.fargate_execution.arn
}

output "iot_role_arn" {
  value = aws_iam_role.iot_role.arn
}

output "sagemaker_role_arn" {
  value = aws_iam_role.sagemaker_role.arn
}

output "glue_role_arn" {
  value = aws_iam_role.glue_role.arn
}

output "lambda_execution_role_arn" {
  value = aws_iam_role.lambda_role.arn
}

output "ec2_instance_profile_name" {
  value = aws_iam_instance_profile.ec2_profile.name
}
