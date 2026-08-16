# ------------------------------------------------------------------------------
# VPE Serverless & Messaging Module
# ------------------------------------------------------------------------------

# --- 1. Amazon API Gateway (Mobile App API) ---

resource "aws_api_gateway_rest_api" "sales_mobile_api" {
  name        = "${var.environment}-vpe-sales-api"
  description = "API for VPE Feed - Sales Mobile App"
  
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "orders" {
  rest_api_id = aws_api_gateway_rest_api.sales_mobile_api.id
  parent_id   = aws_api_gateway_rest_api.sales_mobile_api.root_resource_id
  path_part   = "orders"
}

resource "aws_api_gateway_method" "post_order" {
  rest_api_id   = aws_api_gateway_rest_api.sales_mobile_api.id
  resource_id   = aws_api_gateway_resource.orders.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = var.cognito_authorizer_id
}

# --- 2. Amazon SQS (Order Processing Queue) ---

resource "aws_sqs_queue" "order_queue" {
  name                      = "${var.environment}-vpe-sales-orders-queue"
  delay_seconds             = 0
  max_message_size          = 262144
  message_retention_seconds = 345600
  receive_wait_time_seconds = 10

  tags = {
    Application = "Sales Mobile App"
    Domain      = "Sales & Commerce"
  }
}

# --- 3. Amazon SNS (Alerts & Notifications) ---

resource "aws_sns_topic" "customer_alerts" {
  name = "${var.environment}-vpe-customer-alerts"

  tags = {
    Application = "Customer Notification Service"
  }
}

# --- 4. AWS Lambda (Webhook / Integration) ---

resource "aws_lambda_function" "order_processor" {
  filename      = "dummy_payload.zip" # Placeholder for actual code
  function_name = "${var.environment}-vpe-order-processor"
  role          = var.lambda_execution_role_arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"

  environment {
    variables = {
      QUEUE_URL = aws_sqs_queue.order_queue.url
    }
  }

  tags = {
    Application = "Sales Mobile App"
  }
}
