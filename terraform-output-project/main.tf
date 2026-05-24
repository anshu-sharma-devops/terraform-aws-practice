terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
      version = "~> 2.4"
    }
  }
}

provider "local" {}

resource "local_file" "student_info" {
  filename = "student_details.txt"

  content = <<EOT
Student Name : ${var.student_name}
Course Name  : ${var.course_name}
Learning     : Terraform Output Block
EOT
}