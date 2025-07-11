output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "Public IP"
  value       = aws_instance.this.public_ip
}

output "public_dns" {
  description = "Public DNS"
  value       = aws_instance.this.public_dns
}

output "ssh_sg_id" {
  description = "Security group ID allowing SSH"
  value       = aws_security_group.ssh.id
}
