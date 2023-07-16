# Create EC2 Instance
resource "aws_instance" "public" {
  count =length(var.subnet)
  ami                    = var.AMIS
  instance_type          = var.INSTANCE_Type
  subnet_id              = var.subnet[count.index]
  vpc_security_group_ids = [var.sg]
  source_dest_check      = false
  associate_public_ip_address = true
  key_name = var.KEY
  user_data = file("nginx-config.sh")
  
  
  tags = {
    Name = "nginx"
  }

  provisioner "local-exec" {
    command = "echo public-ip ${count.index} is ${self.public_ip} >> all-ips.txt"
  }
}