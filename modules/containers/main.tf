# ------------------------------------------------------------------------------
# VPE Containers Module (Microservices & App Backends)
# ------------------------------------------------------------------------------

# --- 1. Amazon ECR Repositories ---

resource "aws_ecr_repository" "sales_app_backend" {
  name                 = "vpe/sales-app-backend"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "sop_platform" {
  name                 = "vpe/sop-platform"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "poultry_production" {
  name                 = "vpe/poultry-production-api"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

# --- 2. Amazon EKS Cluster ---

resource "aws_eks_cluster" "vpe_microservices" {
  name     = "${var.environment}-vpe-eks-cluster"
  role_arn = var.eks_cluster_role_arn

  vpc_config {
    subnet_ids              = var.app_subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = false
  }

  tags = {
    Domain = "Shared Services"
  }
}

# --- 3. EKS Fargate Profiles ---

# Fargate Profile for SOP Platform
resource "aws_eks_fargate_profile" "sop_profile" {
  cluster_name           = aws_eks_cluster.vpe_microservices.name
  fargate_profile_name   = "sop-workloads"
  pod_execution_role_arn = var.fargate_pod_execution_role_arn
  subnet_ids             = var.app_subnet_ids

  selector {
    namespace = "vpe-sop"
  }
}

# Fargate Profile for Sales App Backend
resource "aws_eks_fargate_profile" "sales_profile" {
  cluster_name           = aws_eks_cluster.vpe_microservices.name
  fargate_profile_name   = "sales-app-workloads"
  pod_execution_role_arn = var.fargate_pod_execution_role_arn
  subnet_ids             = var.app_subnet_ids

  selector {
    namespace = "vpe-sales"
  }
}

# Fargate Profile for Poultry Production
resource "aws_eks_fargate_profile" "poultry_profile" {
  cluster_name           = aws_eks_cluster.vpe_microservices.name
  fargate_profile_name   = "poultry-app-workloads"
  pod_execution_role_arn = var.fargate_pod_execution_role_arn
  subnet_ids             = var.app_subnet_ids

  selector {
    namespace = "vpe-poultry"
  }
}
