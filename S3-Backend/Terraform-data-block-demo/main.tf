resource "aws_instance" "dev_ec2" {
  ami           = data.aws_ami.amazon_linux.id   # 👈 USING DATA BLOCK
  instance_type = var.instance_type

  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "Terraform-Data-Block-EC2"
  }
}