
variable "AMIS" {
  type = string
  default =  "ami-0989fb15ce71ba39e" # ami which will be used to launch instance.
}

variable "INSTANCE_Type" {
  default = "t3.micro"  
}
variable "subnet_cidr" {
  type = list(string)
}
variable "subnet_name" {
  type = list(string)
}
variable "key" {
  type = string
}
locals {
  public_subnet = aws_subnet.lab[0].id
  private_subnet = aws_subnet.lab[1].id
}