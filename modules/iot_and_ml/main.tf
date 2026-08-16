# ------------------------------------------------------------------------------
# VPE IoT and ML Module (Smart Farm & Automation)
# ------------------------------------------------------------------------------

# --- 1. AWS IoT Core (Giám sát trang trại heo & Tự động hóa nhà máy cám) ---

# IoT Policy for Farm Sensors
resource "aws_iot_policy" "farm_sensor_policy" {
  name = "${var.environment}-vpe-farm-sensor-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["iot:Connect", "iot:Publish", "iot:Subscribe", "iot:Receive"]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# Example IoT Thing for Swine Farm Monitor
resource "aws_iot_thing" "swine_monitor_device" {
  name = "${var.environment}-vpe-swine-monitor-001"
  attributes = {
    FarmLocation = "DongNai"
    Type         = "SwineTelemetry"
  }
}

# IoT Topic Rule to send telemetry to Kinesis Firehose / Timestream
resource "aws_iot_topic_rule" "farm_telemetry_to_timestream" {
  name        = "${var.environment}_vpe_farm_telemetry_rule"
  description = "Route swine farm telemetry to Timestream"
  enabled     = true
  sql         = "SELECT * FROM 'vpe/farms/+/telemetry'"
  sql_version = "2016-03-23"

  timestream {
    database_name = var.timestream_db_name
    table_name    = var.timestream_table_name
    role_arn      = var.iot_role_arn

    dimension {
      name  = "FarmId"
      value = "$${topic(3)}"
    }
    dimension {
      name  = "DeviceType"
      value = "Sensor"
    }
  }
}


# --- 2. Kinesis Video Streams (Camera AI Ấp trứng & Vật nuôi) ---

# Hatchery AI Camera Stream
resource "aws_kinesis_video_stream" "hatchery_camera" {
  name                    = "${var.environment}-vpe-hatchery-ai-stream"
  data_retention_in_hours = 24
  device_name             = "Hatchery-Sorting-Cam-01"
  media_type              = "video/h264"
  tags                    = { Domain = "FarmFood", Application = "AI Camera" }
}

# Swine Health Monitor Stream
resource "aws_kinesis_video_stream" "swine_health_camera" {
  name                    = "${var.environment}-vpe-swine-health-stream"
  data_retention_in_hours = 48
  device_name             = "Swine-Health-Cam-01"
  media_type              = "video/h264"
  tags                    = { Domain = "FarmFood", Application = "AI Camera" }
}


# --- 3. Amazon SageMaker (Trí tuệ nhân tạo) ---

# SageMaker Endpoint for Animal Health Classification (Placeholder configuration)
resource "aws_sagemaker_model" "animal_health_model" {
  name               = "${var.environment}-vpe-animal-health-model"
  execution_role_arn = var.sagemaker_role_arn
  primary_container {
    image          = var.sagemaker_container_image
    model_data_url = "s3://${var.s3_ml_bucket}/models/animal-health.tar.gz"
  }
}

resource "aws_sagemaker_endpoint_configuration" "animal_health_config" {
  name = "${var.environment}-vpe-animal-health-endpoint-cfg"
  production_variants {
    variant_name           = "AllTraffic"
    model_name             = aws_sagemaker_model.animal_health_model.name
    initial_instance_count = 1
    instance_type          = "ml.t2.medium" # Adjust for production (e.g., ml.c5.xlarge)
  }
}

resource "aws_sagemaker_endpoint" "animal_health_endpoint" {
  name                 = "${var.environment}-vpe-animal-health-endpoint"
  endpoint_config_name = aws_sagemaker_endpoint_configuration.animal_health_config.name
}
