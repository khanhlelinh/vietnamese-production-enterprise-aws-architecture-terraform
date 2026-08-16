# ------------------------------------------------------------------------------
# VPE Databases Module (Sales, E-Wallet, CRM)
# ------------------------------------------------------------------------------

# --- 1. DynamoDB (E-Wallet & Online Transactions) ---

resource "aws_dynamodb_table" "ewallet_transactions" {
  name           = "${var.environment}-vpe-ewallet-transactions"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "TransactionId"
  range_key      = "Timestamp"

  attribute {
    name = "TransactionId"
    type = "S"
  }

  attribute {
    name = "Timestamp"
    type = "N"
  }

  attribute {
    name = "UserId"
    type = "S"
  }

  global_secondary_index {
    name               = "UserId-Index"
    hash_key           = "UserId"
    range_key          = "Timestamp"
    projection_type    = "ALL"
  }

  tags = {
    Domain      = "Sales & Commerce"
    Application = "PayOn E-Wallet"
  }
}

# --- 2. Aurora PostgreSQL (CRM & Sales App) ---

resource "aws_db_subnet_group" "sales_db" {
  name       = "${var.environment}-vpe-sales-db-subnet-group"
  subnet_ids = var.db_subnet_ids
}

resource "aws_rds_cluster" "sales_crm_cluster" {
  cluster_identifier      = "${var.environment}-vpe-sales-crm-aurora"
  engine                  = "aurora-postgresql"
  engine_version          = "15.3"
  database_name           = "crmdb"
  master_username         = var.db_username
  master_password         = var.db_password # Manage via Secrets Manager
  db_subnet_group_name    = aws_db_subnet_group.sales_db.name
  vpc_security_group_ids  = [aws_security_group.aurora_sg.id]
  skip_final_snapshot     = false
  backup_retention_period = 7
}

resource "aws_rds_cluster_instance" "sales_crm_instances" {
  count              = 2 # Primary + 1 Read Replica
  identifier         = "${var.environment}-vpe-sales-crm-${count.index}"
  cluster_identifier = aws_rds_cluster.sales_crm_cluster.id
  instance_class     = "db.r6g.large"
  engine             = aws_rds_cluster.sales_crm_cluster.engine
  engine_version     = aws_rds_cluster.sales_crm_cluster.engine_version
}

# --- 3. ElastiCache Redis (Session Management for Online Shop) ---

resource "aws_elasticache_subnet_group" "redis_subnet" {
  name       = "${var.environment}-vpe-redis-subnet-group"
  subnet_ids = var.db_subnet_ids
}

resource "aws_elasticache_cluster" "online_shop_session" {
  cluster_id           = "${var.environment}-vpe-shop-redis"
  engine               = "redis"
  node_type            = "cache.t4g.medium"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  engine_version       = "7.0"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet.name
  security_group_ids   = [aws_security_group.redis_sg.id]
}


# --- 4. Security Groups ---

resource "aws_security_group" "aurora_sg" {
  name        = "${var.environment}-vpe-aurora-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_sales] # Restrict to Sales VPC
  }
}

resource "aws_security_group" "redis_sg" {
  name        = "${var.environment}-vpe-redis-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_sales]
  }
}
