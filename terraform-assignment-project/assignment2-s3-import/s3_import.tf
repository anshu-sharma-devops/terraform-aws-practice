# ============================================================
# ASSIGNMENT 2 (Optional): s3_import.tf
# ============================================================
# SCENARIO: You manually created an S3 bucket in the AWS console.
# Now you want Terraform to manage it without recreating it.
#
# STEPS:
#   1. Create bucket manually in AWS console
#   2. Run: terraform import aws_s3_bucket.imported <your-bucket-name>
#   3. Run: terraform plan  (should show no changes)
#   4. Add tags → terraform apply  (Terraform now owns it)
# ============================================================

resource "aws_s3_bucket" "imported" {
  bucket = "my-manually-created-bucket"   # CHANGE to your actual bucket name

  tags = {
    Name        = "my-manually-created-bucket"
    ManagedBy   = "Terraform"
    ImportedOn  = "2024-05-22"
    Environment = "dev"
  }
}

resource "aws_s3_bucket_public_access_block" "imported" {
  bucket = aws_s3_bucket.imported.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "imported" {
  bucket = aws_s3_bucket.imported.id
  versioning_configuration {
    status = "Enabled"
  }
}
