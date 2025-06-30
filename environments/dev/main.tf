provider "aws" {
  region = var.aws_region
}

# ────────────────────────────────────────────────────────────
# Generate & upload SSH key
# ────────────────────────────────────────────────────────────
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "debian" {
  key_name   = var.key_name
  public_key = tls_private_key.ssh.public_key_openssh
}

# ────────────────────────────────────────────────────────────
# VPC
# ────────────────────────────────────────────────────────────
module "vpc" {
  source             = "../../modules/vpc"
  name               = "dev-vpc"
  cidr_block         = var.vpc_cidr
  public_subnets     = var.public_subnets
  availability_zones = var.availability_zones
}

# ────────────────────────────────────────────────────────────
# EC2
# ────────────────────────────────────────────────────────────
module "ec2" {
  source            = "../../modules/ec2"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  instance_type     = var.instance_type
  instance_name     = var.instance_name

  key_name    = aws_key_pair.debian.key_name
  environment = var.environment
}

# ────────────────────────────────────────────────────────────
# DNS Server
# ────────────────────────────────────────────────────────────
module "dns_server" {
  source               = "../../modules/dns-server"
  name                 = var.dns_instance_name
  environment          = var.environment
  instance_type        = var.dns_instance_type
  key_name             = aws_key_pair.debian.key_name

  vpc_security_group_ids = [module.ec2.ssh_sg_id]
  subnet_id              = module.vpc.public_subnet_ids[0]
}
