resource "aws_instance" "ohio_ec2" {
  provider      = aws.ohio
  ami           = data.aws_ami.ubuntu_ohio.id
  instance_type = "t2.micro"

  tags = {
    Name = "project3-ohio"
  }
}