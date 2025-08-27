# AWS RDS Module & Project Overview

## Overview
This project provisions AWS infra for a Kubernetes-based Django app (EKS + ECR + Helm + Jenkins + Argo CD) and now includes a reusable Terraform RDS module to provide a managed database backend (single RDS instance or Aurora cluster).

---

## What's new
- modules/rds — reusable Terraform module that can create either:
  - a single RDS instance (Postgres/MySQL) OR
  - an Amazon Aurora cluster (when `use_aurora = true`)
- Module creates DB Subnet Group, Security Group, and Parameter Group automatically.
- Designed for reusability and minimal variable changes; secrets are not stored in the repo.

---

## Project Structure

```
aws-kube-jenkins/
├── main.tf            # Connects and configures all modules
├── backend.tf         # Remote state backend configuration (S3 + DynamoDB)
├── outputs.tf         # Outputs from all modules
├── charts/
│   └── django-app/
│       ├── templates/
│       │   ├── deployment.yaml
│       │   ├── service.yaml
│       │   ├── configmap.yaml
│       │   └── hpa.yaml
│       ├── Chart.yaml
│       └── values.yaml
├── modules/
│   ├── s3-backend/
│   ├── vpc/
│   ├── ecr/
│   ├── eks/
│   ├── jenkins/        # Terraform module to deploy Jenkins (helm provider / k8s)
│   ├── argo_cd/        # Terraform module to deploy Argo CD
|   └── rds/             # <- new module (main.tf, variables.tf, outputs.tf, security.tf, subnet_group.tf, parameter_group.tf, README.md)
└── README.md
```

---

## Key Components & Steps

1. **Terraform infrastructure**
   - Provision VPC, ECR, and EKS cluster.
   - Modules are modularized under `modules/` for reusability.

2. **ECR**
   - Store and version Docker images (Django app).
   - Push images using AWS CLI after local build.

3. **Helm**
   - Helm chart (`charts/django-app`) packages Kubernetes manifests:
     - Deployment (uses ECR image, env from ConfigMap)
     - Service (LoadBalancer)
     - HPA (2–6 pods, target CPU 70%)
     - ConfigMap (app environment)

4. **Jenkins (CI)**
   - Deployed into the cluster via the `jenkins` module.
   - Responsible for:
     - Building Docker images on code changes
     - Pushing images to ECR
     - Updating Helm values or chart with new image tags (or committing tag changes to Git)
   - Jenkins configuration is managed via Helm values and config-as-code (no secrets in repo).

5. **Argo CD (GitOps)**
   - Deployed via the `argo_cd` module.
   - Watches Git repository/Helm chart and synchronizes cluster state automatically.
   - When Helm chart or values are updated (by Jenkins or manually), Argo CD will apply changes to the cluster.

6. **RDS (Managed Database)**
   - Deploys either a single RDS instance (Postgres/MySQL) or an Amazon Aurora cluster based on `use_aurora`.
   - Automatically creates DB Subnet Group, Security Group, and Parameter Group for the selected engine.
   - Exposes useful outputs: `endpoint`, `port`, `reader_endpoint` (Aurora), `subnet_group_name`, `security_group_id`.
   - Credentials must be supplied via external secret stores (AWS Secrets Manager / SSM / CI secrets); do not commit secrets to the repo.
   - Designed for reuse with minimal variable changes (engine, engine_version, instance_class, allocated_storage, multi_az, etc.).


---

## Typical Workflow

1. Make code changes in the Django application repository.
2. Jenkins build pipeline:
   - Runs tests (if configured)
   - Builds Docker image
   - Pushes image to ECR
   - Updates Helm values or a chart reference (e.g., with the new image tag) in Git
   - Runs DB migrations or triggers a migration job (when required)
   - Runs smoke tests / basic health checks
3. Argo CD detects the Git change and synchronizes the application in the EKS cluster.
4. HPA scales pods automatically based on load.
5. Post-deploy:
   - Verify app and run any post-deploy tasks
   - Ensure RDS backups and monitoring are healthy
   - Rollback via Argo CD or Helm if issues detected

---

## Usage

**Initialize Terraform:**
```bash
terraform init
```

**Plan & apply infra:**
```bash
terraform plan
terraform apply
```

**Build & push Django image to ECR (example):**
```bash
docker build -t <aws_account>.dkr.ecr.<region>.amazonaws.com/django-app:TAG ./django
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <aws_account>.dkr.ecr.<region>.amazonaws.com
docker push <aws_account>.dkr.ecr.<region>.amazonaws.com/django-app:TAG
```

**Deploy / upgrade Helm chart (local test):**
```bash
helm upgrade --install django-app ./charts/django-app --values ./charts/django-app/values.yaml --namespace app --create-namespace
```

**Access Jenkins (after installation):**
- Get Jenkins Service external IP (if LoadBalancer) or port-forward:
  ```bash
  kubectl get svc -n jenkins
  kubectl port-forward svc/jenkins 8080:8080 -n jenkins
  # open http://localhost:8080
  ```

**Access Argo CD UI (example port-forward):**
```bash
kubectl port-forward svc/argocd-server -n argocd 8084:443
# open https://localhost:8084
```

**Destroy resources:**
```bash
terraform destroy
```

---

## Security & Secrets

- Do not store secrets (passwords, tokens) in repository files.
- Use Kubernetes Secrets, AWS Secrets Manager, or CI/CD secret stores.
- Jenkins credentials and Git tokens should be supplied via secure secret mechanisms, not committed.

---

## Notes

- Ensure AWS credentials and region are configured locally.
- S3 bucket and DynamoDB table must exist for Terraform remote state before `terraform init`.
- Wait for the EKS node groups to become Ready before deploying workloads.
- Adjust resource sizes, autoscaling thresholds, and node types according to load and cost.

---

## Contributing

Questions, suggestions, and PRs are welcome. Use Issues or Discussions to propose changes or request features.

---

## License

Educational / personal learning repository.
