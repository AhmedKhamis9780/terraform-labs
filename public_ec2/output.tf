output "public_ec2_id1" {
  value = aws_instance.public[0].id
}
output "public_ec2_id2" {
  value = aws_instance.public[1].id
}