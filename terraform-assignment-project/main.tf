# ============================================================
# ROOT main.tf — Calls all modules
# This is the entry point of your Terraform project.
# Each module block wires up a reusable child module.
# ============================================================

# ---------- VPC (must come first — others depend on it) ----------
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  project_name         = var.project_name
}

# ---------- Security Group ----------
module "security_group" {
  source = "./modules/security-group"

  vpc_id       = module.vpc.vpc_id
  project_name = var.project_name
}

# ---------- IAM Role ----------
module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
}

# ---------- ECR (Elastic Container Registry) ----------
module "ecr" {
  source = "./modules/ecr"

  repository_name = var.ecr_repository_name
  project_name    = var.project_name
}

# ---------- EKS (Elastic Kubernetes Service) ----------
module "eks" {
  source = "./modules/eks"

  cluster_name       = var.eks_cluster_name
  project_name       = var.project_name
  subnet_ids         = module.vpc.private_subnet_ids
  eks_role_arn       = module.iam.eks_cluster_role_arn
  node_role_arn      = module.iam.eks_node_role_arn
  security_group_ids = [module.security_group.eks_sg_id]
}

# ---------- EC2 (2 instances: Jenkins + Ansible) ----------
module "ec2" {
  source = "./modules/ec2"

  project_name         = var.project_name
  ami_id               = var.ubuntu_ami_id
  instance_type        = var.instance_type
  subnet_id            = module.vpc.public_subnet_ids[0]
  security_group_id    = module.security_group.ec2_sg_id
  key_name             = var.key_name
  iam_instance_profile = module.iam.ec2_instance_profile_name
}
