#!/bin/bash
# ============================================================
# Assignment 2 — S3 Import Step-by-Step Commands
# ============================================================

echo "STEP 1: Make sure you created the S3 bucket manually in AWS Console first!"
echo ""

# STEP 2: Init
terraform init

# STEP 3: Import existing bucket into Terraform state
# Replace 'my-manually-created-bucket' with YOUR bucket name
terraform import aws_s3_bucket.imported my-manually-created-bucket

# STEP 4: Verify — plan should show only tag additions
terraform plan

# STEP 5: Apply to add tags (confirms Terraform manages the bucket)
terraform apply -auto-approve

# STEP 6: Verify tags via AWS CLI
aws s3api get-bucket-tagging --bucket my-manually-created-bucket
