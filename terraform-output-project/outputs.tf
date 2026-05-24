output "file_name" {
  value = local_file.student_info.filename
}

output "file_id" {
  value = local_file.student_info.id
}

output "student_course" {
  value = var.course_name
}