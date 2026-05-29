# Terraform AWS EC2 Project

## Project Overview

This project was created using Terraform with the AWS Provider.

The purpose of this project is to learn:

* Terraform basics
* AWS Provider configuration
* EC2 instance creation
* Variables and Outputs
* Terraform workflow commands
* Git and GitHub integration

---

# Tools Used

* Terraform
* AWS
* Git
* GitHub
* Visual Studio Code
* MacBook Terminal

---

# Project Structure

```text
terraform-ec2-project/
│
├── main.tf
├── provider.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── .gitignore
└── README.md
```

---

# What I Learned

## 1. Provider Block

The provider block is used to connect Terraform with AWS.

Example:

```hcl
provider "aws" {
  region = var.aws_region
}
```

---

## 2. Resource Block

The resource block creates AWS infrastructure.

Example:

```hcl
resource "aws_instance" "my_ec2" {
```

This creates an EC2 instance in AWS.

---

## 3. Variables

Variables help make Terraform code reusable and flexible.

Example:

```hcl
variable "instance_type" {
  default = "t2.micro"
}
```

---

## 4. Outputs

Outputs display useful information after infrastructure creation.

Example:

* Public IP
* Instance ID

---

## 5. Terraform Commands

### Initialize Terraform

```bash
terraform init
```

Downloads required providers.

---

### Validate Configuration

```bash
terraform validate
```

Checks Terraform syntax.

---

### Format Files

```bash
terraform fmt
```

Formats Terraform code properly.

---

### Preview Infrastructure Changes

```bash
terraform plan
```

Shows what Terraform will create or modify.

---

### Create Infrastructure

```bash
terraform apply
```

Creates AWS resources.

---

### Destroy Infrastructure

```bash
terraform destroy
```

Deletes created resources.

---

# Git Commands Used

## Check Status

```bash
git status
```

## Add Files

```bash
git add .
```

## Commit Changes

```bash
git commit -m "Added Terraform EC2 project"
```

## Push to GitHub

```bash
git push origin main
```

---

# AWS Concepts Learned

## EC2

Amazon EC2 is a virtual server in AWS.

---

## AMI

AMI (Amazon Machine Image) is an operating system template used to launch EC2 instances.

---

## AWS Region

Region determines where infrastructure is created.

Example:

```text
ap-south-1
```

---

# Problems Faced

## Invalid AMI Error

Error:

```text
InvalidAMIID.Malformed
```

Reason:

* Old or invalid AMI ID

Solution:

* Replace with valid AMI ID for the selected AWS region.

---

# Important Learning

* Never hardcode secrets
* Use `.gitignore`
* Always run:

  * terraform fmt
  * terraform validate
  * terraform plan
* Destroy resources after testing to avoid AWS charges

---

# Future Improvements

Next projects:

* EC2 with Security Group
* S3 Bucket
* VPC
* Load Balancer
* Auto Scaling
* Terraform Modules
* Remote Backend

---

# Author

Anshu Sharma
GitHub: https://github.com/anshu-sharma-devops