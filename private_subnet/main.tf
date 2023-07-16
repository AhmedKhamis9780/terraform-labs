

resource "aws_subnet" "private" {
  count =length(var.subnet_cidr_list)
  availability_zone = var.subnet_zone[count.index]
  vpc_id     = var.vpc_id
  cidr_block = var.subnet_cidr_list[count.index]

  tags = {
    Name = "private"

  }
}

resource "aws_eip" "lb" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "nat-way" {
  allocation_id = aws_eip.lb.id
  subnet_id     =  var.subnet_public_id

  tags = {
    Name = "gw NAT"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-way.id
  }

  tags = {
    Name = "rt"
  }
}
resource "aws_route_table_association" "a" {
  count =length(var.subnet_cidr_list)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

