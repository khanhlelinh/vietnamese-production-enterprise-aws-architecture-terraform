# Enterprise# Enterprise Cloud Migration & Modernization (Terraform IaC)

![Vietnamese Production Enterprise Solution Architecture](LeKhanhLinh_AWS_Enterprise_Solution_Architecture.png)

This repository contains the comprehensive Infrastructure as Code (IaC) deployment for a large-scale agricultural enterprise (Agri-Tech) cloud migration and application modernization project, managing 27 core applications across the Feed - Farm - Food value chain.

## Architecture Overview

The infrastructure is built on AWS Region `ap-southeast-1` (Singapore) using a multi-VPC architecture connected via Transit Gateway. The architecture is divided into three main business domains:

1.  **Domain 1 - Core Enterprise:** Finance, ERP SAP, MES, HRM, SOP.
2.  **Domain 2 - Sales & Commerce:** CRM, Enterprise Feed Sales App, Pay On (E-Wallet), Online Shop.
3.  **Domain 3 - Farm, Food, IoT:** Farm Monitoring, Camera AI, IoT Ingestion, Data Lake & Analytics.

## Directory Structure

*   `environments/`: Contains environment-specific configurations (`dev`, `staging`, `prod`). The `prod` environment is the primary entrypoint.
*   `modules/`: Reusable Terraform modules categorizing different aspects of the architecture:
    *   `network`: VPCs, Subnets, TGW, Route53, Load Balancers.
    *   `security_and_mgmt`: IAM, WAF, Security Hub, Config, CloudTrail.
    *   `core_enterprise`: EC2 (HANA/Finance), Bastion.
    *   `containers`: EKS Clusters, Fargate Profiles, ECR.
    *   `databases`: RDS Oracle, Aurora PostgreSQL, DynamoDB, ElastiCache.
    *   `data_lake_analytics`: S3 Data Lake, Glue, Athena, QuickSight.
    *   `iot_and_ml`: IoT Core, Kinesis, SageMaker, Rekognition.
    *   `serverless_and_messaging`: SQS, SNS, API Gateway, Lambda.
    *   `migration_tools`: AWS DMS, MGN, SCT.

## How to Deploy

1.  Initialize Terraform inside the target environment (e.g., `prod`):
    ```bash
    cd environments/prod
    terraform init
    ```
2.  Review the infrastructure plan:
    ```bash
    terraform plan
    ```
3.  Apply the configuration:
    ```bash
    terraform apply
    ```

## Notes for GitHub
- Do not commit `.tfstate` files or sensitive variables (ensure `.gitignore` is applied).
- Use an S3 backend with DynamoDB locking for state management in a team environment.
