# 📤 GitHub Push Guide — Step by Step

## 1. Create a new GitHub repository
- Go to https://github.com → Click **"New"**
- Name it: `terraform-assignment`
- Set to **Public** or **Private**
- Do NOT initialize with README (we already have one)
- Click **"Create repository"**

## 2. Open your terminal and run these commands

```bash
# Navigate into your project folder
cd terraform-assignment

# Initialize git
git init

# Add all files
git add .

# First commit
git commit -m "feat: initial terraform assignment - ECR, EKS, EC2, VPC, SG, IAM modules"

# Connect to your GitHub repo (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/terraform-assignment.git

# Push to GitHub
git branch -M main
git push -u origin main
```

## 3. Verify on GitHub
- Visit: `https://github.com/YOUR_USERNAME/terraform-assignment`
- You should see all your files and the README rendered

## 4. Future commits (after making changes)

```bash
git add .
git commit -m "feat: add security group rules for RDS"
git push
```

## ✅ Good commit message examples
- `feat: add VPC module with public and private subnets`
- `fix: update EKS node instance type to t3.medium`
- `docs: update README with deployment steps`
- `refactor: extract security group rules into variables`
