terraform {
  backend "s3" {
    bucket         = "my-dev-terraform-state"
    key            = "serverless/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile   = true
    encrypt        = true
  }
}
