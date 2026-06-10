provider "aws" {
  region = "ap-south-1"
}

resource "aws_security_group" "apache_sg" {
  name = "apache-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "apache_server" {
  ami           = "ami-0f5ee92e2d63afc18"
  instance_type = "t3.micro"
  key_name      = "jenkins-key"

  vpc_security_group_ids = [
    aws_security_group.apache_sg.id
  ]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install httpd -y
              systemctl start httpd
              systemctl enable httpd

              echo "<h1>Hello from Terraform Apache Server</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "apache-server"
  }
}