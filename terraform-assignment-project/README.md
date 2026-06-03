# 🚀 Terraform DevOps Assignment — May 21st & 22nd

A complete Terraform project using **modules** to provision AWS infrastructure for a DevOps pipeline.

---

## 📁 Project Structure

```
terraform-assignment/
├── main.tf                          # Root: calls all modules
├── variables.tf                     # All input variable definitions
├── outputs.tf                       # Prints values after apply
├── provider.tf                      # AWS provider + S3 backend config
├── terraform.tfvars                 # Your actual variable values
├── .gitignore                       # Excludes state files & secrets
│
├── modules/
│   ├── vpc/                         # VPC, subnets, IGW, NAT, route tables
│   ├── security-group/              # EC2 and EKS security groups
│   ├── iam/                         # IAM roles for EKS + EC2
│   ├── ecr/                         # Elastic Container Registry
│   ├── eks/                         # EKS cluster + node group
│   └── ec2/                         # Jenkins + Ansible EC2 instances
│
└── assignment2-s3-import/           # Optional: import existing S3 bucket
    ├── s3_import.tf
    ├── provider.tf
    └── import_commands.sh
```

---

## 🏗️ Architecture Overview

```
                         ┌─────────────────── VPC (10.0.0.0/16) ───────────────────┐
                         │                                                           │
          Internet ──── IGW ──── Public Subnets ──── Jenkins EC2                   │
                         │            │          └─── Ansible EC2                   │
                         │           NAT                                             │
                         │            │                                              │
                         │       Private Subnets ──── EKS Worker Nodes             │
                         │                                                           │
                         └───────────────────────────────────────────────────────── ┘
                         
          ECR (Docker images) ←── Jenkins builds → pushes → EKS pulls
          IAM Roles ──────────── Control permissions for all services
```

---

## 📦 Modules Explained

### 1. `modules/vpc` — Network Foundation
Creates the entire network layer:
- **VPC** with CIDR `10.0.0.0/16`
- **2 Public Subnets** (EC2 instances live here, have internet access)
- **2 Private Subnets** (EKS nodes live here, no direct internet)
- **Internet Gateway (IGW)** — connects public subnets to internet
- **NAT Gateway** — lets private subnet instances reach the internet (for pulling packages)
- **Route Tables** — directs traffic correctly for both subnet types

### 2. `modules/security-group` — Virtual Firewalls
- **EC2 SG**: Opens port 22 (SSH) and 8080 (Jenkins UI)
- **EKS SG**: Opens port 443 (K8s API) and allows internal node communication

### 3. `modules/iam` — Permissions
- **EKS Cluster Role**: Lets EKS control plane manage AWS resources
- **EKS Node Role**: Lets worker nodes join the cluster + pull from ECR
- **EC2 Role + Instance Profile**: Lets Jenkins push to ECR and access EKS

### 4. `modules/ecr` — Docker Registry
- Private registry to store Docker images
- Automatic vulnerability scanning on push
- Lifecycle policy to clean up old untagged images after 30 days

### 5. `modules/eks` — Kubernetes Cluster
- **Control Plane**: AWS-managed Kubernetes API server
- **Node Group**: 2 `t3.medium` Ubuntu worker nodes (auto-scales 1–4)
- CloudWatch logging for API, audit, and authenticator logs

### 6. `modules/ec2` — Jenkins & Ansible Servers
- **Jenkins** (`t3.medium`): Auto-installs Java, Jenkins, Docker on first boot
- **Ansible** (`t3.small`): Auto-installs Ansible, Python3, AWS CLI

---

## 🔧 Prerequisites

Before running Terraform:

1. **AWS CLI configured**
   ```bash
   aws configure
   # Enter: Access Key, Secret Key, Region (us-east-1), Output (json)
   ```

2. **Terraform installed** (v1.5+)
   ```bash
   terraform --version
   ```

3. **EC2 Key Pair created** in AWS console
   - Go to EC2 → Key Pairs → Create Key Pair
   - Update `key_name` in `terraform.tfvars`

4. **S3 Bucket for backend state** created manually:
   ```bash
   aws s3 mb s3://devops-assignment-terraform-state --region us-east-1
   aws s3api put-bucket-versioning \
     --bucket devops-assignment-terraform-state \
     --versioning-configuration Status=Enabled
   ```

5. **DynamoDB table** for state locking:
   ```bash
   aws dynamodb create-table \
     --table-name terraform-state-lock \
     --attribute-definitions AttributeName=LockID,AttributeType=S \
     --key-schema AttributeName=LockID,KeyType=HASH \
     --billing-mode PAY_PER_REQUEST \
     --region us-east-1
   ```

---

## 🚀 How to Run

```bash
# 1. Clone the repo
git clone https://github.com/YOUR_USERNAME/terraform-assignment.git
cd terraform-assignment

# 2. Edit your values
nano terraform.tfvars   # update key_name at minimum

# 3. Initialize (downloads AWS provider + configures S3 backend)
terraform init

# 4. Preview what will be created
terraform plan

# 5. Apply (type 'yes' when prompted)
terraform apply

# 6. See outputs (IPs, URLs, etc.)
terraform output
```

---

## 📤 Outputs After Apply

| Output | Description |
|--------|-------------|
| `jenkins_public_ip` | Access Jenkins at `http://<IP>:8080` |
| `ansible_public_ip` | SSH into Ansible: `ssh ubuntu@<IP>` |
| `ecr_repository_url` | Push Docker images to this URL |
| `eks_cluster_name` | Use with `kubectl` |
| `eks_cluster_endpoint` | Kubernetes API endpoint |
| `vpc_id` | VPC ID for reference |

---

## 🗂️ Assignment 2 — S3 Import (Optional)

Import an existing manually-created S3 bucket into Terraform state:

```bash
cd assignment2-s3-import

# Edit s3_import.tf — update the bucket name to your real bucket
terraform init

# Import the bucket (no resources are deleted or recreated)
terraform import aws_s3_bucket.imported YOUR-BUCKET-NAME

# Verify plan shows only tag additions
terraform plan

# Apply to add Terraform-managed tags
terraform apply
```

---

## 🧹 Clean Up (Destroy Everything)

```bash
terraform destroy
# Type 'yes' to confirm
```
⚠️ This deletes all resources. EKS clusters take ~10 minutes to destroy.

---

## 🔑 Key Terraform Concepts Used

| Concept | Where Used |
|---------|-----------|
| **Modules** | Each service is a reusable module in `modules/` |
| **Variables** | `variables.tf` + `terraform.tfvars` |
| **Outputs** | `outputs.tf` — prints IPs, URLs after apply |
| **Data Sources** | Can extend to look up AMIs dynamically |
| **S3 Backend** | Remote state in `provider.tf` (Assignment 1, May 21st) |
| **`terraform import`** | Import existing S3 bucket (Assignment 2) |
| **`count`** | Used in VPC for creating multiple subnets |
| **`depends_on`** | Ensures correct creation order |
| **`user_data`** | Auto-installs Jenkins/Ansible on EC2 boot |

---

## 👤 Author

**Anshu sharma** — DevOps Training Assignment  
May 21–22, 2024
