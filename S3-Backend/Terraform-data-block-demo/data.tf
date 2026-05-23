# Fetch latest Amazon Linux 2 AMI (DATA BLOCK)
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Fetch available AZs in region (DATA BLOCK)
data "aws_availability_zones" "available" {
  state = "available"
}