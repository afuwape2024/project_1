resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = var.aws_vpc
  } 
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.aws_public_subnet_cidr
  availability_zone = var.aws_availability_zone_1
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.aws_private_subnet_cidr
  availability_zone = var.aws_availability_zone_1

  tags = {
    Name = "private_subnet"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.aws_public_subnet_cidr_2
  availability_zone = var.aws_availability_zone_2
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet2"
  }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.aws_private_subnet_cidr_2
  availability_zone = var.aws_availability_zone_2

  tags = {
    Name = "private_subnet2"
  }
}
