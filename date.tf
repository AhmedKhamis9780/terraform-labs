data "aws_ami" "lab" {
    most_recent      = true
    owners = ["amazon"]
    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    filter {
        name   = "root-device-type"
        values = ["ebs"]
    }
}




