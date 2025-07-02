# AWS Modular Infrastructure with Terraform

## Overview

This project demonstrates a modular approach to provisioning AWS infrastructure using Terraform.  
It includes remote state management, networking, and a container registry, all organized with reusable modules.

---

## Project Structure

```
aws-terraform/
├── main.tf           # Connects and configures all modules
├── backend.tf        # Remote state backend configuration (S3 + DynamoDB)
├── outputs.tf        # Outputs from all modules
├── modules/
│   ├── s3-backend/   # S3 bucket and DynamoDB table for state management
│   ├── vpc/          # VPC, subnets, gateways, and routing
│   └── ecr/          # Elastic Container Registry (ECR) module
└── README.md         # Project documentation
```

---

## Usage

**Initialize the project:**
```bash
terraform init
```

**Preview planned changes:**
```bash
terraform plan
```

**Apply the configuration:**
```bash
terraform apply
```

**Destroy all resources:**
```bash
terraform destroy
```

---

## Module Explanations

### `modules/s3-backend`
- **Purpose:**  
  Manages the S3 bucket (with versioning) for storing Terraform state files and a DynamoDB table for state locking.
- **Outputs:**  
  - S3 bucket name
  - DynamoDB table name

### `modules/vpc`
- **Purpose:**  
  Provisions a VPC with a configurable CIDR block, three public and three private subnets, an Internet Gateway, and route tables.  
  (NAT Gateway can be added if needed.)
- **Outputs:**  
  - VPC ID
  - Public subnet IDs
  - Private subnet IDs

### `modules/ecr`
- **Purpose:**  
  Creates an AWS Elastic Container Registry (ECR) repository with image scanning on push.
- **Outputs:**  
  - Repository URL
  - Repository name
  - Repository ARN
  - Repository ID

---

## Notes

- **Remote state backend:**  
  The S3 bucket and DynamoDB table for remote state must be created manually before running `terraform init`.
- **AWS Credentials:**  
  Ensure your AWS credentials are configured locally (via environment variables or `~/.aws/credentials`).
- **Region:**  
  Update the AWS region in `provider` and `backend.tf` as needed.

---

## License

This project is for educational purposes.