# Define the security group for the EC2 Instance
resource "aws_security_group" "aws-sg" {
  name        = "vm-sg"
  description = "Allow incoming connections"
  vpc_id      = aws_vpc.lab.id  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming HTTP connections"
  } 
    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming SSH connections"
    }
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  } 
}
# Create EC2 Instance
resource "aws_instance" "public-server" {
  ami                    = var.AMIS
  instance_type          = var.INSTANCE_Type
  subnet_id              =  local.public_subnet
  vpc_security_group_ids = [aws_security_group.aws-sg.id]
  source_dest_check      = false
  associate_public_ip_address = true
  key_name = var.key
  
  user_data = file("nginx-config.sh")
  
  
  tags = {
    Name = "nginx"
  }
}
resource "aws_instance" "private-server" {
  ami                    = var.AMIS
  instance_type          = var.INSTANCE_Type
  subnet_id              = local.private_subnet
  vpc_security_group_ids = [aws_security_group.aws-sg.id]
  source_dest_check      = false
  associate_public_ip_address = false
  
  user_data = file("apache-config.sh")
  
  
  tags = {
    Name = "appache"
  }
}