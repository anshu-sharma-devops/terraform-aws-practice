# ============================================================
# MODULE: ec2/main.tf
# Creates 2 Ubuntu EC2 instances:
#   1. Jenkins server — CI/CD pipelines
#   2. Ansible server — configuration management
# ============================================================

# ---------- Jenkins EC2 Instance ----------
resource "aws_instance" "jenkins" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name
  iam_instance_profile   = var.iam_instance_profile

  # user_data runs as root on first boot — installs Jenkins
  user_data = <<-USERDATA
    #!/bin/bash
    set -e
    apt-get update -y
    apt-get install -y openjdk-17-jdk curl gnupg2

    # Add Jenkins repo and install
    curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | tee \
      /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
      https://pkg.jenkins.io/debian-stable binary/ | tee \
      /etc/apt/sources.list.d/jenkins.list > /dev/null
    apt-get update -y
    apt-get install -y jenkins

    # Install Docker (Jenkins will use it to build images)
    curl -fsSL https://get.docker.com | sh
    usermod -aG docker jenkins
    usermod -aG docker ubuntu

    systemctl enable jenkins
    systemctl start jenkins
  USERDATA

  root_block_device {
    volume_size = 20   # 20 GB disk for Jenkins workspace
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.project_name}-jenkins"
    Role = "jenkins"
  }
}

# ---------- Ansible EC2 Instance ----------
resource "aws_instance" "ansible" {
  ami                    = var.ami_id
  instance_type          = "t3.small"   # Ansible needs less resources
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name
  iam_instance_profile   = var.iam_instance_profile

  user_data = <<-USERDATA
    #!/bin/bash
    set -e
    apt-get update -y
    apt-get install -y software-properties-common
    add-apt-repository --yes --update ppa:ansible/ansible
    apt-get install -y ansible python3-pip awscli
  USERDATA

  root_block_device {
    volume_size = 15
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.project_name}-ansible"
    Role = "ansible"
  }
}
