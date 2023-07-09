# Configure the AWS Provider
provider "aws" {
    region = "eu-north-1"
}

# Create a VPC
resource "aws_vpc" "lab" {
  cidr_block = "10.0.0.0/16"
    tags = {
    Name = "lab"
  }
}
# subnets
resource "aws_subnet" "lab" {
  count =length(var.subnet_cidr)
  vpc_id     = aws_vpc.lab.id
  cidr_block = var.subnet_cidr[count.index]

  tags = {
    Name = var.subnet_name[count.index]

  }
}

# internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.lab.id

  tags = {
    Name = "gw"
  }
}
# public route table
resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.lab.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "rt"
  }
}
# add route table to subnet
resource "aws_route_table_association" "a" {
  subnet_id      = local.public_subnet
  route_table_id = aws_route_table.pub_rt.id
}
#elactic ip
resource "aws_eip" "lb" {
  domain   = "vpc"
}
# nat gateway
resource "aws_nat_gateway" "nat-way" {
  allocation_id = aws_eip.lb.id
  subnet_id     =  local.public_subnet

  tags = {
    Name = "gw NAT"
  }
}
# private route table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.lab.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-way.id
  }

  tags = {
    Name = "rt"
  }
}
resource "aws_route_table_association" "con" {
  subnet_id      =  local.private_subnet
  route_table_id = aws_route_table.private_rt.id
}
