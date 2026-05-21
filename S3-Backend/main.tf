resource "aws_s3_bucket" "terraform_state" {
  bucket = "anshu-sharma-tfstate-713881"

  tags = {
    Name        = "Terraform State Bucket"
    Environment = "learning"
  }
}

resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}