output "my_instance_id" {
    value       = aws_instance.this.id
}

output "my_server_ip" {                        
    value       = aws_instance.this.public_ip
}

output "attached_disk2" {
    value       = aws_ebs_volume.disk2.id
}

output "attached_disk3" {
    value       = aws_ebs_volume.disk3.id
}
