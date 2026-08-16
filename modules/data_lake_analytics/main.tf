# ------------------------------------------------------------------------------
# VPE Data Lake & Analytics Module
# ------------------------------------------------------------------------------

# --- 1. S3 Data Lake Buckets ---

resource "aws_s3_bucket" "raw_data" {
  bucket = "${var.environment}-vpe-datalake-raw-${var.aws_account_id}"
}

resource "aws_s3_bucket_versioning" "raw_data_versioning" {
  bucket = aws_s3_bucket.raw_data.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "processed_data" {
  bucket = "${var.environment}-vpe-datalake-processed-${var.aws_account_id}"
}

# --- 2. AWS Glue Data Catalog & Crawler ---

resource "aws_glue_catalog_database" "vpe_analytics_db" {
  name        = "vpe_analytics_db"
  description = "Glue Catalog Database for VPE Farm & Enterprise Data"
}

resource "aws_glue_crawler" "farm_data_crawler" {
  name          = "${var.environment}-vpe-farm-data-crawler"
  database_name = aws_glue_catalog_database.vpe_analytics_db.name
  role          = var.glue_role_arn

  s3_target {
    path = "s3://${aws_s3_bucket.processed_data.bucket}/farm-telemetry/"
  }
}

# --- 3. Amazon Athena ---

resource "aws_s3_bucket" "athena_results" {
  bucket = "${var.environment}-vpe-athena-results-${var.aws_account_id}"
}

resource "aws_athena_workgroup" "analytics_wg" {
  name = "${var.environment}-vpe-analytics-wg"

  configuration {
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = true

    result_configuration {
      output_location = "s3://${aws_s3_bucket.athena_results.bucket}/output/"
    }
  }
}

# --- 4. Amazon QuickSight (Placeholder config) ---
# Note: QuickSight enterprise setup usually requires manual registration or specific IAM roles
resource "aws_quicksight_group" "executive_dashboard" {
  group_name = "VPE-Executive-Dashboard-Users"
  aws_account_id = var.aws_account_id
}
