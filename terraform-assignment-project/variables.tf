# ============================================================
# ROOT variables.tf — All input variables for the project
# Think of variables as function parameters for your infra.
# ============================================================

variable "project_name" {
  description = "A prefix applied to every resource name for easy identification"
  type        = string
  default     = "devops-assignment"
}

variable "aws_region" {
  description = "AWS region where all resources will be created"
  type        = string
  default     = "us-east-1"
}

# ---------- VPC ----------
variable "vpc_cidr" {
  description = "CIDR block for the VPC (the IP range of your private network)"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets (EC2/Jenkins/Ansible live here)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets (EKS nodes live here)"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  description = "AZs to spread subnets across for high availability"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# ---------- EC2 ----------
variable "ubuntu_ami_id" {
  description = "Ubuntu 22.04 LTS AMI ID for us-east-1 (update if region changes)"
  type        = string
  default     = "ami-0c7217cdde317cfec" # Ubuntu 22.04 LTS us-east-1
}

variable "instance_type" {
  description = "EC2 instance size (t3.medium recommended for Jenkins)"
  type        = string
  default     = "t3.medium"
}

variable "key_name" {
  description = "Name of your existing EC2 Key Pair for SSH access"
  type        = string
  default     = "my-key-pair" # CHANGE THIS to your actual key pair name
}

# ---------- ECR ----------
variable "ecr_repository_name" {
  description = "Name of the ECR repository to store Docker images"
  type        = string
  default     = "devops-app"
}

# ---------- EKS ----------
variable "eks_cluster_name" {
  description = "Name of the EKS Kubernetes cluster"
  type        = string
  default     = "devops-cluster"
}
