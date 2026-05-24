resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Allow MySQL access"

  ingress {
    from_port   = 3306
    to_port     = 3306
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

resource "aws_db_instance" "mydb" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"

  identifier           = "terraform-mysql-db"

  username             = var.db_username
  password             = var.db_password

  publicly_accessible  = true
  skip_final_snapshot  = true

  vpc_security_group_ids = [
    aws_security_group.rds_sg.id
  ]
}