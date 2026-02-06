provider "aws" {
  region = var.region
}

module "three_tier" {
  source = "../../modules/three-tier"

  project     = var.project
  environment = var.environment
  region      = var.region

  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone  = var.availability_zone

  ami_id        = var.ami_id
  instance_type = var.instance_type
  ssh_cidr      = var.ssh_cidr

  extra_tags = var.extra_tags
}
