output "raw_data_bucket_name" {
  value = aws_s3_bucket.raw_data.bucket
}

output "processed_data_bucket_name" {
  value = aws_s3_bucket.processed_data.bucket
}

output "glue_database_name" {
  value = aws_glue_catalog_database.vpe_analytics_db.name
}
