# ============================================================
# MODULE: IAM ROLE
# IAM Roles define WHAT AWS services can do on your behalf
# Example: EKS needs permission to manage EC2, ECR, etc.
# ============================================================

# ---- IAM Role for EKS Cluster ----
# This role is ASSUMED by the EKS service itself (the control plane)
resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.project_name}-eks-cluster-role"

  # Trust policy: who can assume this role?
  # Here: only the EKS service (eks.amazonaws.com)
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = { Name = "${var.project_name}-eks-cluster-role" }
}

# Attach AWS managed policy — gives EKS permission to manage cluster resources
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# ---- IAM Role for EKS Worker Nodes (EC2 instances that run pods) ----
resource "aws_iam_role" "eks_node_role" {
  name = "${var.project_name}-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }  # EC2 (worker nodes) assumes this
      Action    = "sts:AssumeRole"
    }]
  })

  tags = { Name = "${var.project_name}-eks-node-role" }
}

# These 3 policies are REQUIRED for EKS worker nodes to function
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"  # For pod networking
}

resource "aws_iam_role_policy_attachment" "ecr_read_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"  # Pull images from ECR
}

# ---- IAM Role for EC2 instances (Jenkins & Ansible) ----
resource "aws_iam_role" "ec2_role" {
  name = "${var.project_name}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = { Name = "${var.project_name}-ec2-role" }
}

# Allow EC2 instances to push/pull from ECR and interact with EKS
resource "aws_iam_role_policy" "ec2_inline_policy" {
  name = "ec2-ecr-eks-access"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ecr:*"]   # Full ECR access (push images from Jenkins)
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = ["eks:DescribeCluster"]  # Needed for kubectl auth
        Resource = "*"
      }
    ]
  })
}

# Instance profile wraps the role so EC2 can use it
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}
