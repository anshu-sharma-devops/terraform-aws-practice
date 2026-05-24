output "jenkins_instance_id" { value = aws_instance.jenkins.id }
output "jenkins_public_ip"   { value = aws_instance.jenkins.public_ip }
output "ansible_instance_id" { value = aws_instance.ansible.id }
output "ansible_public_ip"   { value = aws_instance.ansible.public_ip }
