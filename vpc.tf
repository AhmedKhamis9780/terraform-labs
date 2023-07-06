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

resource "aws_subnet" "pub" {
  vpc_id     = aws_vpc.lab.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "pub"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.lab.id

  tags = {
    Name = "gw"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.lab.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "rt"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.pub.id
  route_table_id = aws_route_table.rt.id
}