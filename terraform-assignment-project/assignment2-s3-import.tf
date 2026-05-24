# ============================================================
# ASSIGNMENT 2: Import existing S3 bucket into Terraform state
# ============================================================
# STEP 1: Create the S3 bucket MANUALLY in AWS Console
#   - Go to S3 → Create Bucket → Name it "my-manually-created-bucket"
#   - Leave all defaults, click Create

# STEP 2: Write this Terraform resource to MATCH what you created manually
resource "aws_s3_bucket" "imported" {
  bucket = "my-manually-created-bucket"   # Must match the exact name you created!
}

# STEP 3: Run the import command in terminal:
#   terraform import aws_s3_bucket.imported my-manually-created-bucket
#
# This tells Terraform: "that bucket already exists — add it to your state file"
# After import, run: terraform plan → should show "No changes" if resource matches

# STEP 4: Add tags to confirm Terraform now controls this bucket
resource "aws_s3_bucket_tagging" "imported" {    # (use inline tags in newer AWS provider)
  bucket = aws_s3_bucket.imported.bucket

  # Adding these tags PROVES Terraform controls the bucket
  # After: terraform apply → check S3 Console → you'll see these tags!
}

# In AWS Provider v5+, tags go directly on the bucket:
# resource "aws_s3_bucket" "imported" {
#   bucket = "my-manually-created-bucket"
#   tags = {
#     ManagedBy   = "Terraform"
#     ImportedOn  = "2024-05-22"
#     Environment = "dev"
#   }
# }
