# AWS Terraform for Kubernetes (Django app)

## Overview
This project provisions AWS infrastructure for a Kubernetes-based Django application. It automates commonly required cloud components using Terraform and provides reusable modules for rapid iteration and testing.

Primary components provisioned by the project:
- VPC (networking)
- EKS (Kubernetes control plane + nodegroups)
- ECR (container registry)
- RDS (managed database: single instance or Aurora cluster)
- Jenkins (CI) deployed to the cluster
- Argo CD (GitOps) deployed to the cluster
- Monitoring stack (Prometheus + Grafana)

The repository also contains a Helm chart for the Django app and Terraform modules under `modules/` for modular reuse.

---

## What's new / Module highlights
- `modules/rds` — reusable Terraform module that can create either:
   - a single RDS instance (Postgres or MySQL), or
   - an Amazon Aurora cluster (when `use_aurora = true`).
- The RDS module creates a DB Subnet Group, Security Group, and Parameter Group automatically and exposes useful outputs (endpoint, port, reader_endpoint for Aurora, subnet group name, security group id).
- Secrets are intentionally not stored in the repository. Use AWS Secrets Manager, SSM, or your CI secret store.

---

## Project Structure

```
iac-aws-terraform/
├── main.tf             # Root composition: module calls and high-level provider references
├── backend.tf          # Remote state backend (S3 + DynamoDB) configuration
├── outputs.tf          # Root-level outputs (aggregate useful outputs)
├── versions.tf         # Recommended - terraform required_version and required_providers
├── variables.tf        # (optional) root-level variables used by main.tf
├── providers.tf        # (optional) provider configuration and aliases
├── modules/            # Reusable Terraform modules
│  ├── s3-backend/      # Module for S3 bucket + DynamoDB (remote state)
│  │  ├── s3.tf
│  │  ├── dynamodb.tf
│  │  ├── variables.tf
│  │  └── outputs.tf
│  │
│  ├── vpc/             # VPC, subnets, route tables, IGW
│  │  ├── vpc.tf
│  │  ├── routes.tf
│  │  ├── variables.tf
│  │  └── outputs.tf
│  │
│  ├── ecr/             # ECR repositories
│  │  ├── ecr.tf
│  │  ├── variables.tf
│  │  └── outputs.tf
│  │
│  ├── eks/             # EKS cluster and node groups
│  │  ├── eks.tf
│  │  ├── aws_ebs_csi_driver.tf
│  │  ├── variables.tf
│  │  └── outputs.tf
│  │
│  ├── rds/             # RDS module (single instance or Aurora)
│  │  ├── rds.tf
│  │  ├── aurora.tf
│  │  ├── shared.tf
│  │  ├── variables.tf
│  │  └── outputs.tf
│  │
│  ├── jenkins/         # Helm release module for Jenkins
│  │  ├── jenkins.tf
│  │  ├── providers.tf
│  │  ├── variables.tf
│  │  ├── values.example.yaml  # non-sensitive example values
│  │  └── outputs.tf
│  │
│  └── argo_cd/         # Helm release module for Argo CD
│     ├── argocd.tf
│     ├── providers.tf
│     ├── variables.tf
│     ├── values.example.yaml
│     ├── outputs.tf
│     └── README.md     # module usage and variables documentation
│
├── charts/             # Helm charts for applications (kept separate from modules)
│  └── django-app/
│     ├── Chart.yaml
│     ├── values.yaml   # app-level values (no secrets)
│     └── templates/
│        ├── deployment.yaml
│        ├── service.yaml
│        ├── configmap.yaml
│        └── hpa.yaml
│
└── django/             # Application source (optional; often in a separate repo)
   ├── app/
   ├── Dockerfile
   ├── Jenkinsfile
   └── docker-compose.yaml
```

## Key Components & Steps

1. Prepare environment
    - Ensure AWS credentials and region are configured locally (AWS CLI or environment variables).
    - Make sure S3 bucket and DynamoDB table exist for Terraform remote state (if using remote backend).
    - Initialize Terraform:
       ```bash
       terraform init
       ```
    - Validate variables and secret sources (check `.tfvars`, environment variables, or CI secret configuration).

2. Deploy infrastructure
    - Plan and apply Terraform:
       ```bash
       terraform plan
       terraform apply
       ```
    - After apply completes, verify Kubernetes resources:
       ```bash
       kubectl get all -n jenkins
       kubectl get all -n argocd
       kubectl get all -n monitoring
       ```

3. Verify access (port-forward for local checks)
    - Jenkins:
       ```bash
       kubectl port-forward svc/jenkins 8080:8080 -n jenkins
       # then open http://localhost:8080
       ```
    - Argo CD:
       ```bash
       kubectl port-forward svc/argocd-server 8081:443 -n argocd
       # then open https://localhost:8081
       ```

4. Monitoring & metrics
    - Grafana UI (port-forward):
       ```bash
       kubectl port-forward svc/grafana 3000:80 -n monitoring
       # open http://localhost:3000
       ```
    - Ensure Grafana shows dashboards sourcing data from Prometheus and that Prometheus is scraping the expected targets.


Teardown
```bash
terraform destroy
```

---

## Usage (common commands)

Initialize Terraform
```bash
terraform init
```

Plan & apply
```bash
terraform plan
terraform apply
```

Build & push Django image to ECR (example)
```bash
docker build -t <aws_account>.dkr.ecr.<region>.amazonaws.com/django-app:TAG ./django
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <aws_account>.dkr.ecr.<region>.amazonaws.com
docker push <aws_account>.dkr.ecr.<region>.amazonaws.com/django-app:TAG
```

Deploy / upgrade Helm chart (local test)
```bash
helm upgrade --install django-app ./charts/django-app --values ./charts/django-app/values.yaml --namespace app --create-namespace
```

Access Jenkins / Argo CD examples
```bash
kubectl get svc -n jenkins
kubectl port-forward svc/jenkins 8080:8080 -n jenkins

kubectl port-forward svc/argocd-server -n argocd 8081:443 -n argocd
```

Monitoring quick checks
```bash
kubectl get all -n monitoring
kubectl port-forward svc/grafana 3000:80 -n monitoring
```

---

## Security & secrets

- Do not store secrets (passwords, tokens) in repository files.
- Use Kubernetes Secrets, AWS Secrets Manager, or CI/CD secret stores (GitHub Actions secrets, GitLab CI variables, etc.).
- Jenkins credentials and Git tokens should be supplied via secure secret mechanisms and not committed into the repo.

---

## Notes & contributing
- Ensure AWS credentials and region are configured locally before running Terraform.
- Create the S3 bucket and DynamoDB table for remote state before `terraform init` if using remote backend.
- Wait for EKS nodegroups to reach `Ready` before deploying workloads.
- For changes to modules, prefer small, iterative updates and add tests/examples in the module folder.

Contributions and questions welcome — open an Issue or Discussion.

---

## License

Educational / personal learning repository.
