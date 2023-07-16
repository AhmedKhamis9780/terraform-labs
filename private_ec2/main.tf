# Create EC2 Instance
resource "aws_instance" "private" {
  count =length(var.subnet)
  ami                    = var.AMIS
  instance_type          = var.INSTANCE_Type
  subnet_id              = var.subnet[count.index]
  vpc_security_group_ids = [var.sg]
  source_dest_check      = false
  associate_public_ip_address = false
  key_name = var.KEY
  user_data = file("apache-config.sh")
  
  
  tags = {
    Name = "apache"
  }
}

