provider "aws" {
  region = var.region
}

module "serverless" {
  source = "../../modules/serverless"

  project     = var.project
  environment = var.environment
  region      = var.region

  extra_tags = var.extra_tags
}
