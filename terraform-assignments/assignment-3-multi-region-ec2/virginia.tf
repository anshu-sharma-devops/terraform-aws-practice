resource "aws_instance" "virginia_ec2" {
  provider      = aws.virginia
  ami           = data.aws_ami.ubuntu_virginia.id
  instance_type = "t2.micro"

  tags = {
    Name = "project3-virginia"
  }
}