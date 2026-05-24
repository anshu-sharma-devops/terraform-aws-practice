output "instance_id" {
  value = aws_instance.dev_ec2.id
}

output "public_ip" {
  value = aws_instance.dev_ec2.public_ip
}

output "ami_used" {
  value = data.aws_ami.amazon_linux.id
}

output "availability_zones" {
  value = data.aws_availability_zones.available.names
}