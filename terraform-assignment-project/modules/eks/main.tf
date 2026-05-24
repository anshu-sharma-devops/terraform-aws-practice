# ============================================================
# MODULE: eks/main.tf
# EKS = Elastic Kubernetes Service
# AWS-managed Kubernetes control plane + worker node group.
# ============================================================

# ---------- EKS Control Plane ----------
# This is the "brain" of Kubernetes — manages scheduling,
# API server, etcd. AWS handles this for you with EKS.
resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = var.eks_role_arn
  version  = "1.29"   # Kubernetes version

  vpc_config {
    subnet_ids              = var.subnet_ids
    security_group_ids      = var.security_group_ids
    endpoint_private_access = true   # kubectl works inside VPC
    endpoint_public_access  = true   # kubectl works from your laptop too
  }

  # Control plane logs sent to CloudWatch for debugging
  enabled_cluster_log_types = ["api", "audit", "authenticator"]

  tags = {
    Name = "${var.project_name}-eks-cluster"
  }

  depends_on = [var.eks_role_arn]
}

# ---------- Node Group ----------
# Worker nodes are plain EC2 instances managed by EKS.
# Pods (containers) actually run on these nodes.
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.project_name}-node-group"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  # Instance type for worker nodes
  instance_types = ["t3.medium"]

  # Auto-scaling config: maintain 2 nodes, can scale to 4
  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 1
  }

  # Rolling update: replace one node at a time
  update_config {
    max_unavailable = 1
  }

  tags = {
    Name = "${var.project_name}-node-group"
  }
}
