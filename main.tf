# Configure the AWS Provider
provider "aws" {
    region = "us-east-1"
}

module "vpc" {
  source = "./vpc"
  cidr = "10.0.0.0/16"
  name = "sprint"
}
module "public_subnet" {
  source           = "./public_subnet"  
  subnet_cidr_list = ["10.0.0.0/24","10.0.1.0/24"]
  subnet_zone      = [ "us-east-1a","us-east-1b" ]
  vpc_id           = module.vpc.vpc_id
}
module "private_subnet" {
  source           = "./private_subnet"  
  subnet_cidr_list = ["10.0.2.0/24","10.0.3.0/24"]
  subnet_zone      = [ "us-east-1a","us-east-1b" ]
  vpc_id           = module.vpc.vpc_id
  subnet_public_id = module.public_subnet.subnet_id1

}
module "sec_group" {
  source = "./sg"
  vpc_id = module.vpc.vpc_id
}
module "pub_ec2" {
  source = "./public_ec2"
  AMIS = data.aws_ami.lab.id
  INSTANCE_Type = "t2.micro"
  subnet = [module.public_subnet.subnet_id1,module.public_subnet.subnet_id2]
  sg = module.sec_group.sg_id
  KEY = "new"
}
module "private_ec2" {
  source = "./private_ec2"
  AMIS = data.aws_ami.lab.id
  INSTANCE_Type = "t2.micro"
  subnet = [module.private_subnet.subnet_id1,module.private_subnet.subnet_id2]
  sg = module.sec_group.sg_id
  KEY = "new"
}
module "public_id" {
  source = "./lb"
  name = "public"
  tg_name = "public"
  internal = false
  sg = module.sec_group.sg_id
  subnet = [module.public_subnet.subnet_id1,module.public_subnet.subnet_id2]
  vpc = module.vpc.vpc_id
  instance = [module.pub_ec2.public_ec2_id1,module.pub_ec2.public_ec2_id2]
}
module "private_id" {
  source = "./lb"
  name = "private"
  tg_name = "private"
  internal = true
  sg = module.sec_group.sg_id
  subnet = [module.private_subnet.subnet_id1,module.private_subnet.subnet_id2]
  vpc = module.vpc.vpc_id
  instance = [module.private_ec2.private_ec2_id1,module.private_ec2.private_ec2_id2]
}