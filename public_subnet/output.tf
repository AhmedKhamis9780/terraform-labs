output "subnet_id1" {
  value = aws_subnet.public[0].id
}
output "subnet_id2" {
  value = aws_subnet.public[1].id
}