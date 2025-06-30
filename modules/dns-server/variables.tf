variable "name" {
  description = "Name tag for DNS server resources"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g. dev, staging, prod)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for DNS server"
  type        = string
}

variable "key_name" {
  description = "SSH key pair name for DNS server"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs to attach"
  type        = list(string)
}

variable "subnet_id" {
  description = "ID of the subnet to launch into"
  type        = string
}

variable "ami_owner" {
  description = "AWS account ID that publishes the Debian Cloud AMIs"
  type        = string
  default     = "136693071363"
}

variable "ami_name_pattern" {
  description = "Wildcard pattern for the Debian AMI name"
  type        = string
  default     = "debian-11-amd64-*"
}
