# ============================================================
# ROOT outputs.tf — Prints important values after apply
# These appear in your terminal after `terraform apply`
# ============================================================

output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = module.vpc.private_subnet_ids
}

output "jenkins_instance_id" {
  description = "EC2 Instance ID of the Jenkins server"
  value       = module.ec2.jenkins_instance_id
}

output "jenkins_public_ip" {
  description = "Public IP to access Jenkins UI (port 8080)"
  value       = module.ec2.jenkins_public_ip
}

output "ansible_instance_id" {
  description = "EC2 Instance ID of the Ansible server"
  value       = module.ec2.ansible_instance_id
}

output "ansible_public_ip" {
  description = "Public IP to SSH into Ansible server"
  value       = module.ec2.ansible_public_ip
}

output "ecr_repository_url" {
  description = "Full ECR URL to push Docker images to"
  value       = module.ecr.repository_url
}

output "eks_cluster_name" {
  description = "EKS cluster name (use with kubectl)"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS API server endpoint"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_role_arn" {
  description = "IAM Role ARN used by EKS"
  value       = module.iam.eks_cluster_role_arn
}
