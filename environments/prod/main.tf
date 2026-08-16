# ------------------------------------------------------------------------------
# VPE Production Architecture - Main Entrypoint
# ------------------------------------------------------------------------------

module "network" {
  source             = "../../modules/network"
  environment        = "prod"
  vpc_cidr_core      = var.vpc_cidr_core
  vpc_cidr_sales     = var.vpc_cidr_sales
  vpc_cidr_iot       = var.vpc_cidr_iot
  availability_zones = var.availability_zones
}

module "security_and_mgmt" {
  source      = "../../modules/security_and_mgmt"
  environment = "prod"
  vpc_id      = module.network.core_vpc_id
}

module "core_enterprise" {
  source               = "../../modules/core_enterprise"
  environment          = "prod"
  vpc_id               = module.network.core_vpc_id
  vpc_cidr_core        = var.vpc_cidr_core
  app_subnet_ids       = module.network.core_private_app_subnet_ids
  db_subnet_ids        = module.network.core_private_db_subnet_ids
  ec2_instance_profile = module.security_and_mgmt.ec2_instance_profile_name
  db_password          = var.db_password
}

module "containers" {
  source                         = "../../modules/containers"
  environment                    = "prod"
  app_subnet_ids                 = module.network.core_private_app_subnet_ids
  eks_cluster_role_arn           = module.security_and_mgmt.eks_cluster_role_arn
  fargate_pod_execution_role_arn = module.security_and_mgmt.fargate_execution_role_arn
}

module "databases" {
  source         = "../../modules/databases"
  environment    = "prod"
  vpc_id         = module.network.sales_vpc_id
  vpc_cidr_sales = var.vpc_cidr_sales
  db_subnet_ids  = module.network.core_private_db_subnet_ids # Or sales subnets
  db_password    = var.db_password
}

module "iot_and_ml" {
  source                    = "../../modules/iot_and_ml"
  environment               = "prod"
  iot_role_arn              = module.security_and_mgmt.iot_role_arn
  sagemaker_role_arn        = module.security_and_mgmt.sagemaker_role_arn
  sagemaker_container_image = var.sagemaker_container_image
  s3_ml_bucket              = module.data_lake_analytics.raw_data_bucket_name
}

module "data_lake_analytics" {
  source         = "../../modules/data_lake_analytics"
  environment    = "prod"
  aws_account_id = var.aws_account_id
  glue_role_arn  = module.security_and_mgmt.glue_role_arn
}

module "serverless_and_messaging" {
  source                    = "../../modules/serverless_and_messaging"
  environment               = "prod"
  cognito_authorizer_id     = var.cognito_authorizer_id
  lambda_execution_role_arn = module.security_and_mgmt.lambda_execution_role_arn
}
