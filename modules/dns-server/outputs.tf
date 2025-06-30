output "instance_id" {
  description = "ID of the DNS EC2 instance"
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "Public IP of the DNS server"
  value       = aws_instance.this.public_ip
}

output "public_dns" {
  description = "Public DNS of the DNS server"
  value       = aws_instance.this.public_dns
}

output "eip" {
  description = "Elastic IP allocated to the DNS server"
  value       = aws_eip.this.public_ip
}
