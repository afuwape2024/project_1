module "vpc" {
  source = ".//main"
  cidr_block = var.cidr_block
  aws_vpc = var.aws_vpc
  aws_public_subnet_cidr = var.aws_public_subnet_cidr
  aws_private_subnet_cidr = var.aws_private_subnet_cidr
  aws_public_subnet_cidr_2 = var.aws_public_subnet_cidr_2
  aws_private_subnet_cidr_2 = var.aws_private_subnet_cidr_2
  aws_availability_zone_1 = var.aws_availability_zone_1
  aws_availability_zone_2 = var.aws_availability_zone_2
}