# Terraform AWS RDS Project

## Project Overview

This project uses Terraform to create an AWS RDS MySQL database instance along with a security group.

The infrastructure is fully managed using Infrastructure as Code (IaC).

---

## Services Used

- AWS RDS
- AWS Security Group
- Terraform
- AWS Provider

---

## Files in This Project

| File Name | Purpose |
|------------|----------|
| provider.tf | AWS provider configuration |
| main.tf | RDS and Security Group resources |
| variables.tf | Variables for database credentials |
| outputs.tf | Displays RDS outputs |
| terraform.tfvars | Variable values |
| .gitignore | Ignore Terraform local files |
| README.md | Project documentation |

---

## Resources Created

### Security Group
- Allows MySQL traffic on port 3306

### RDS MySQL Instance
- MySQL Engine
- db.t3.micro instance
- Publicly accessible

---

## Terraform Commands Used

### Initialize Terraform

```bash
terraform init
```

### Check Execution Plan

```bash
terraform plan
```

### Create Infrastructure

```bash
terraform apply
```

### Destroy Infrastructure

```bash
terraform destroy
```

---

## Outputs

Terraform displays:

- RDS Endpoint
- RDS Engine
- Instance Class

Example:

```text
rds_endpoint = terraform-mysql-db.xxxxx.ap-south-1.rds.amazonaws.com:3306
rds_engine = mysql
rds_instance_class = db.t3.micro
```

---

## Learning Outcome

Through this project I learned:

- Terraform basics
- Infrastructure as Code
- AWS RDS provisioning
- Security Groups
- Terraform outputs
- Terraform state management
- AWS region handling

---

## Author

Anshu Sharma