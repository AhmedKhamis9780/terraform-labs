resource "aws_subnet" "public" {
  count = length(var.subnet_cidr_list)
  availability_zone = var.subnet_zone[count.index]
  vpc_id     = var.vpc_id
  cidr_block = var.subnet_cidr_list[count.index]

  tags = {
    Name = "public"

  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "gw"
  }
}

resource "aws_route_table" "pub_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "rt"
  }
}

resource "aws_route_table_association" "a" {
  count =length(var.subnet_cidr_list)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.pub_rt.id
}