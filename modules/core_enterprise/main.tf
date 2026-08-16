# ------------------------------------------------------------------------------
# VPE Core Enterprise Module (SAP ERP, Finance, Admin)
# ------------------------------------------------------------------------------

# --- 1. SAP HANA EC2 Instance (Production) ---

# Network Interface for SAP
resource "aws_network_interface" "sap_eni" {
  subnet_id       = var.app_subnet_ids[0]
  private_ips     = ["10.0.10.100"] # Example static IP
  security_groups = [aws_security_group.sap_sg.id]
}

# EC2 Instance optimized for SAP HANA (Memory Optimized)
resource "aws_instance" "sap_hana" {
  ami           = var.sles_sap_ami_id
  instance_type = "r6i.16xlarge" # SAP Certified Instance type (Placeholder)
  key_name      = var.ec2_key_name
  iam_instance_profile = var.ec2_instance_profile

  network_interface {
    network_interface_id = aws_network_interface.sap_eni.id
    device_index         = 0
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = 50
  }

  # Additional EBS volumes for SAP Data and Logs would be attached here
  tags = {
    Name        = "${var.environment}-vpe-sap-hana-prod"
    Application = "ERP SAP"
    Domain      = "Core Enterprise"
  }
}

# --- 2. Finance Core Database (RDS Oracle) ---

resource "aws_db_subnet_group" "core_db" {
  name       = "${var.environment}-vpe-core-db-subnet-group"
  subnet_ids = var.db_subnet_ids
  tags       = { Name = "${var.environment}-vpe-core-db-subnet-group" }
}

resource "aws_db_instance" "finance_oracle" {
  identifier           = "${var.environment}-vpe-finance-oracle"
  allocated_storage    = 500
  storage_type         = "io1"
  iops                 = 3000
  engine               = "oracle-ee"
  engine_version       = "19"
  instance_class       = "db.m5.2xlarge"
  db_name              = "FINCORE"
  username             = var.db_username
  password             = var.db_password # Manage via Secrets Manager in real scenario
  parameter_group_name = "default.oracle-ee-19"
  skip_final_snapshot  = false

  db_subnet_group_name   = aws_db_subnet_group.core_db.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  tags = {
    Name        = "${var.environment}-vpe-finance-db"
    Application = "Finance & Accounting"
    Domain      = "Core Enterprise"
  }
}


# --- 3. Security Groups ---

resource "aws_security_group" "sap_sg" {
  name        = "${var.environment}-vpe-sap-sg"
  description = "Security Group for SAP HANA"
  vpc_id      = var.vpc_id

  ingress {
    description = "SAP HANA Studio/Client"
    from_port   = 30015
    to_port     = 30015
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_core] # Restrict to Core VPC or On-Prem
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db_sg" {
  name        = "${var.environment}-vpe-db-sg"
  description = "Security Group for Oracle RDS"
  vpc_id      = var.vpc_id

  ingress {
    description = "Oracle SQLNet"
    from_port   = 1521
    to_port     = 1521
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_core]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
