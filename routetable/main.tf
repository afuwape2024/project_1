resource "aws_route_table" "public_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.ig_id
  }
  tags = {
    Name = "public_rt"
  }   
}

resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id = var.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}


resource "aws_eip" "nat_eip" {
  domain = "vpc"
}
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id
} 
resource "aws_route_table" "private_rt_with_nat" {
  vpc_id = aws_vpc.justvpc.id

  route {
    cidr_block = "0.0.0.0/0"  
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = {
    Name = "private_rt_with_nat"
  }   
}
resource "aws_route_table_association" "private_rt_with_nat_assoc" {
  subnet_id = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt_with_nat.id
}