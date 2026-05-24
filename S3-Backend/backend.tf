terraform {
  backend "s3" {
    bucket  = "anshu-sharma-tfstate-713881"
    key     = "s3-backend/terraform.tfstate"
    region  = "us-east-1"
    profile = "anshu"
  }
}
