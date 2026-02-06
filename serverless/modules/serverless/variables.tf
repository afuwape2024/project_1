variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "lambda_runtime" {
  type    = string
  default = "python3.11"
}

variable "lambda_handler" {
  type    = string
  default = "handler.lambda_handler"
}

variable "lambda_timeout" {
  type    = number
  default = 10
}

variable "extra_tags" {
  type    = map(string)
  default = {}
}
