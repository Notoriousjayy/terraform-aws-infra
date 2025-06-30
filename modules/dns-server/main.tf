##############################
# Data Source: Latest Debian AMI
##############################
data "aws_ami" "debian" {
  most_recent = true
  owners      = [var.ami_owner]

  filter {
    name   = "name"
    values = [var.ami_name_pattern]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

##############################
# Resource: EC2 Instance for DNS
##############################
resource "aws_instance" "this" {
  ami                         = data.aws_ami.debian.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = var.vpc_security_group_ids
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true

  tags = {
    Name        = var.name
    Environment = var.environment
  }
}

##############################
# Resource: Elastic IP for DNS
##############################
resource "aws_eip" "this" {
  instance = aws_instance.this.id
  domain   = "vpc"
}
