output "api_endpoint" {
  value = aws_apigatewayv2_api.this.api_endpoint
}

output "lambda_name" {
  value = aws_lambda_function.this.function_name
}

output "s3_bucket" {
  value = aws_s3_bucket.this.bucket
}

output "dynamodb_table" {
  value = aws_dynamodb_table.this.name
}

output "sns_topic" {
  value = aws_sns_topic.this.arn
}

output "sqs_queue" {
  value = aws_sqs_queue.this.id
}
