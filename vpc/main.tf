resource "aws_vpc" "lab" {
    cidr_block = var.cidr
    tags = {
        Name = var.name
    }
}