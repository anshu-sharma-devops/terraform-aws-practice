output "public_ip" {
  value = aws_instance.apache_server.public_ip
}

output "instance_id" {
  value = aws_instance.apache_server.id
}