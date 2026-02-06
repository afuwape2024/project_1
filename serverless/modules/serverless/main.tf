provider "aws" {
  region = var.region
}

# -----------------------
# S3 Bucket
# -----------------------
resource "aws_s3_bucket" "this" {
  bucket = "${local.name}-bucket"
  tags   = local.tags
}

# -----------------------
# DynamoDB Table
# -----------------------
resource "aws_dynamodb_table" "this" {
  name         = "${local.name}-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = local.tags
}

# -----------------------
# SQS Queue
# -----------------------
resource "aws_sqs_queue" "this" {
  name = "${local.name}-queue"
  tags = local.tags
}

# -----------------------
# SNS Topic + Subscription
# -----------------------
resource "aws_sns_topic" "this" {
  name = "${local.name}-topic"
  tags = local.tags
}

resource "aws_sns_topic_subscription" "sqs" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.this.arn
}

# -----------------------
# IAM Role & Policy
# -----------------------
resource "aws_iam_role" "lambda" {
  name = "${local.name}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "lambda" {
  role = aws_iam_role.lambda.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:*",
          "dynamodb:*",
          "s3:*",
          "sns:Publish",
          "sqs:*"
        ]
        Resource = "*"
      }
    ]
  })
}

# -----------------------
# Lambda Function
# -----------------------
resource "aws_lambda_function" "this" {
  function_name = "${local.name}-lambda"
  role          = aws_iam_role.lambda.arn
  runtime       = var.lambda_runtime
  handler       = var.lambda_handler
  timeout       = var.lambda_timeout

  filename         = "lambda.zip"
  source_code_hash = filebase64sha256("lambda.zip")

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.this.name
      BUCKET     = aws_s3_bucket.this.bucket
      TOPIC_ARN  = aws_sns_topic.this.arn
      QUEUE_URL  = aws_sqs_queue.this.url
    }
  }

  tags = local.tags
}

# -----------------------
# API Gateway
# -----------------------
resource "aws_apigatewayv2_api" "this" {
  name          = "${local.name}-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda" {
  api_id                 = aws_apigatewayv2_api.this.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.this.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "default" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "ANY /"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

resource "aws_apigatewayv2_stage" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = "$default"
  auto_deploy = true
}

# -----------------------
# Lambda Permission
# -----------------------
resource "aws_lambda_permission" "api" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.this.execution_arn}/*/*"
}
