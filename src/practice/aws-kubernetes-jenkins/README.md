# AWS Kubernetes Infrastructure with Terraform & Helm

## Overview

This project demonstrates how to provision a production-ready Kubernetes cluster on AWS using Terraform, deploy a Django application containerized with Docker, and manage deployments with Helm.  
It builds on previous work with VPC, S3, DynamoDB, and ECR, and adds Kubernetes orchestration and Helm chart packaging.

---

## Project Structure

```
aws-kubernetes/
├── main.tf            # Connects and configures all modules
├── backend.tf         # Remote state backend configuration (S3 + DynamoDB)
├── outputs.tf         # Outputs from all modules
├── charts/
│   └── django-app/
│       ├── templates/
│       │   ├── deployment.yaml     # Django Deployment (uses ECR image, env from ConfigMap)
│       │   ├── service.yaml        # LoadBalancer Service for external access
│       │   ├── configmap.yaml      # Environment variables for Django app
│       │   └── hpa.yaml            # Horizontal Pod Autoscaler (2-6 pods, >70% CPU)
│       ├── Chart.yaml
│       └── values.yaml             # Parameters for image, service, config, autoscaler
├── modules/
│   ├── s3-backend/   # S3 bucket and DynamoDB table for state management
│   ├── vpc/          # VPC, subnets, gateways, and routing
│   ├── ecr/          # Elastic Container Registry (ECR) module
│   └── eks/          # EKS (Kubernetes cluster) module
└── README.md         # Project documentation
```

---

## Key Components & Steps

1. **Kubernetes Cluster Creation**

   - Terraform provisions an EKS cluster in your existing VPC.
   - Access the cluster using `kubectl`.

2. **Elastic Container Registry (ECR)**

   - Terraform creates an ECR repository for your Django Docker image.
   - Push your Django image to ECR using AWS CLI.

3. **Helm Chart for Django**

   - Helm chart includes:
     - `deployment.yaml`: Deploys Django app from ECR, loads env variables from ConfigMap.
     - `service.yaml`: Exposes Django via LoadBalancer for public access.
     - `hpa.yaml`: Scales pods from 2 to 6 if CPU usage > 70%.
     - `configmap.yaml`: Stores environment variables.
     - `values.yaml`: Centralizes configuration for image, service, autoscaler, etc.

4. **ConfigMap Integration**
   - Environment variables are managed via ConfigMap and injected into the Django app.

---

## Results

- AWS account contains a fully provisioned Kubernetes (EKS) cluster.
- ECR stores your Django Docker image.
- Django app is deployed to the cluster via Helm.
- Service exposes the app via public IP.
- ConfigMap is connected to the app through Helm.
- HPA automatically scales pods based on load.

---

## Usage

**Initialize Terraform:**

```bash
terraform init
```

**Plan and apply infrastructure:**

```bash
terraform plan
terraform apply
```

**Build and push Django image to ECR:**

```bash
docker build -t <your-ecr-repo>:latest .
docker push <your-ecr-repo>:latest
```

**Deploy Django app with Helm:**

```bash
helm upgrade --install django-app ./charts/django-app --values ./charts/django-app/values.yaml
```

**Destroy all resources:**

```bash
terraform destroy
```

---

## Notes

- Ensure AWS credentials are configured locally.
- S3 bucket and DynamoDB table for remote state must exist before running `terraform init`.
- Update region and resource names as needed in configuration files.

---

## License

This project is for educational purposes.
