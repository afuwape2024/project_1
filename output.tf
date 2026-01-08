output "vpc_id" {
  value = aws_vpc.myvpc.id
}
output "public_subnet1" {
  value = aws_subnet.public_subnet.id
}
output "private_subnet1" {
  value = aws_subnet.private_subnet.id
}
output "public_subnet2" {
  value = aws_subnet.public_subnet2.id
}
output "private_subnet2" {
  value = aws_subnet.private_subnet2.id
}

