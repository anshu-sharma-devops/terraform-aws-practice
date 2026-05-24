# ============================================================
# provider.tf — Tells Terraform which cloud to use (AWS)
# The required_providers block pins the version for stability.
# ============================================================

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # ── S3 Backend (Assignment 1 from May 21st) ──────────────
  # Stores terraform.tfstate remotely in S3 instead of locally.
  # This allows team collaboration and prevents state loss.
  # IMPORTANT: Create the S3 bucket manually BEFORE running terraform init
  backend "s3" {
    bucket         = "devops-assignment-terraform-state"   # your S3 bucket name
    key            = "terraform/state/terraform.tfstate"   # path inside the bucket
    region         = "us-east-1"
    encrypt        = true                                  # encrypts state at rest
    dynamodb_table = "terraform-state-lock"               # prevents concurrent applies
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "devops-assignment"
      ManagedBy   = "Terraform"
      Environment = "dev"
    }
  }
}
