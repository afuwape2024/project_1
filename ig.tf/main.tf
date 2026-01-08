

resource "aws_internet_gateway" "ig_id" {
  vpc_id = var.vpc_id
  tags = {Name = "internet_gateway"}
}

resource "aws_internet_gateway_attachment" "ig_attach" {
  internet_gateway_id = aws_internet_gateway.ig_id.id
  vpc_id = var.vpc_id
}
