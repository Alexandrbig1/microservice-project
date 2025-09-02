# microservice-project

<img align="right" src="https://media.giphy.com/media/du3J3cXyzhj75IOgvA/giphy.gif" width="100"/>

[![GitHub last commit](https://img.shields.io/github/last-commit/Alexandrbig1/microservice-project)](https://github.com/Alexandrbig1/microservice-project/commits/main)
[![CI](https://github.com/Alexandrbig1/microservice-project/actions/workflows/ci.yml/badge.svg)](https://github.com/Alexandrbig1/microservice-project/actions)
[![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white)](https://www.docker.com/)
[![AWS](https://img.shields.io/badge/AWS-232F3E?logo=amazonaws&logoColor=white)](https://aws.amazon.com/)
[![Terraform](https://img.shields.io/badge/Terraform-623CE4?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![Shell](https://img.shields.io/badge/Shell-FFD500?logo=gnu-bash&logoColor=black)](https://www.gnu.org/software/bash/)
[![Bash](https://img.shields.io/badge/Bash-4EAA25?logo=gnubash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Python](https://img.shields.io/badge/Python-3776AB?logo=python&logoColor=white)](https://www.python.org/)
[![Linux](https://img.shields.io/badge/Linux-FCC624?logo=linux&logoColor=black)](https://www.linux.org/)
[![Nginx](https://img.shields.io/badge/Nginx-009639?logo=nginx&logoColor=white)](https://nginx.org/)
[![Jenkins](https://img.shields.io/badge/Jenkins-D24939?logo=jenkins&logoColor=white)](https://www.jenkins.io/)

## microservice-project

This repository is an educational microservices and DevOps playground that contains multiple example modules showing how to provision and operate microservice infrastructure using modern tooling: shell scripts, Docker, Kubernetes (Helm), Terraform (AWS), Argo CD, Jenkins, and GitHub Actions.

The goal: provide small, reusable modules and hands-on examples for learning and improving DevOps & SRE skills. Each module can be used independently for experiments, CI/CD exercises, and demonstrations.

Key notes:
- This repository is intentionally modular: many subfolders are separate exercises and example projects (Terraform modules, Helm charts, Dockerized apps, CI pipelines).
- Secrets and sensitive values are not stored in the repo. Use environment variables, AWS Secrets Manager, SSM, or your CI secret store.
- The examples are opinionated and simplified for learning; adapt them before using in production.

## What this repo contains

Top-level structure (high level):

```
src/
   practice/         # lab exercises and small examples (Docker, Terraform, Helm, etc.)
   project/          # larger composed projects and end-to-end examples (EKS, Jenkins, ArgoCD)
   script/           # helper scripts for local env setup
```

Highlights:
- Terraform modules: `vpc`, `eks`, `ecr`, `rds`, `s3-backend`, `jenkins`, `argo_cd`.
- Helm charts: `charts/django-app` and others for demo deployments.
- Dockerized sample apps: Django, PHP, FastAPI in different folders under `practice/` and `project/`.
- CI/CD examples: Jenkins Helm deployments, Argo CD configs, and example GitHub Actions workflows (see `.github/workflows`).

## Quick start (local)

1. Clone the repo:

```bash
git clone https://github.com/Alexandrbig1/microservice-project.git
cd microservice-project
```

2. Read the module you want to try, for example:

```bash
ls src/project/aws-kube-jenkins
```

3. Follow the README inside each module (e.g., `src/project/iac-aws-terraform/README.md`) for module-specific setup.

## Common workflows

Terraform (example):

```bash
cd src/project/iac-aws-terraform
# ensure AWS credentials and region are set
terraform init
terraform plan
terraform apply
```

Build & push Docker image to ECR (example):

```bash
docker build -t <aws_account>.dkr.ecr.<region>.amazonaws.com/django-app:TAG ./src/project/iac-aws-terraform/django
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <aws_account>.dkr.ecr.<region>.amazonaws.com
docker push <aws_account>.dkr.ecr.<region>.amazonaws.com/django-app:TAG
```

Helm (install demo chart):

```bash
helm upgrade --install django-app src/project/iac-aws-terraform/charts/django-app --values src/project/iac-aws-terraform/charts/django-app/values.yaml --namespace app --create-namespace
```

Argo CD (example flow):

1. Deploy Argo CD into cluster (see module `project/modules/argo_cd` or `src/project/...`).
2. Register the repo/application in Argo CD pointing to the desired chart path (e.g., `charts/django-app`).

Jenkins (demo):

- A Helm-based Jenkins deployment is available in `src/project/...` (or `practice/...`). See the `values.example.yaml` in the module for credential wiring.

CI / GitHub Actions

- This repo contains example GitHub Actions workflows under `.github/workflows/` for CI and simple automation; update the workflow names and secrets for your account. The top badge links to `actions/workflows/ci.yml` if present.

## Security & secrets

- Do not commit secrets. Use AWS Secrets Manager, SSM Parameter Store, Kubernetes Secrets, or CI secret stores.
- If you configure remote Terraform state (S3 + DynamoDB), create the S3 bucket and DynamoDB table before `terraform init`.

## Contributing & learning

This repository is a learning resource. Contributions, corrections, and improvements are welcome. Suggested ways to contribute:

- Add clearer module READMEs with step-by-step lab guides.
- Add CI tests (lint, terraform validate, helm lint) to `.github/workflows`.
- Add small unit/integration tests for any scripts or code under `src/`.

When contributing, prefer small, focused pull requests and include a short description of what was tested locally.

## License

This project is licensed under the [MIT License](LICENSE).

---

## Languages and Tools

<div align="center">  
<a href="https://www.gnu.org/software/bash/" target="_blank"><img style="margin: 10px" src="https://profilinator.rishav.dev/skills-assets/gnu_bash-icon.svg" alt="Bash" height="50" /></a>  
<a href="https://github.com/" target="_blank"><img style="margin: 10px" src="https://profilinator.rishav.dev/skills-assets/git-scm-icon.svg" alt="Git" height="50" /></a>  
<a href="https://www.linux.org/" target="_blank"><img style="margin: 10px" src="https://profilinator.rishav.dev/skills-assets/linux-original.svg" alt="Linux" height="50" /></a>  
<a href="https://aws.amazon.com/" target="_blank"><img style="margin: 10px" src="https://profilinator.rishav.dev/skills-assets/amazonwebservices-original-wordmark.svg" alt="AWS" height="50" /></a>  
<a href="https://www.docker.com/" target="_blank"><img style="margin: 10px" src="https://profilinator.rishav.dev/skills-assets/docker-original-wordmark.svg" alt="Docker" height="50" /></a>  
<a href="https://kubernetes.io/" target="_blank"><img style="margin: 10px" src="https://profilinator.rishav.dev/skills-assets/kubernetes-icon.svg" alt="Kubernetes" height="50" /></a>  
<a href="https://www.terraform.io/" target="_blank"><img style="margin: 10px" src="https://profilinator.rishav.dev/skills-assets/terraformio-icon.svg" alt="Terraform" height="50" /></a>  
<a href="https://www.jenkins.io/" target="_blank"><img style="margin: 10px" src="https://profilinator.rishav.dev/skills-assets/jenkins-icon.svg" alt="Jenkins" height="50" /></a>  
<a href="https://www.nginx.com/" target="_blank"><img style="margin: 10px" src="https://profilinator.rishav.dev/skills-assets/nginx-original.svg" alt="Nginx" height="50" /></a>  
</div>

---

## Connect with me

<div align="center">
<a href="https://linkedin.com/in/alex-smagin29" target="_blank">
<img src=https://img.shields.io/badge/linkedin-%231E77B5.svg?&style=for-the-badge&logo=linkedin&logoColor=white alt=linkedin style="margin-bottom: 5px;" />
</a>
<a href="https://www.youtube.com/@AlexSmaginDev" target="_blank">
<img src="https://img.shields.io/badge/youtube-%23FF0000.svg?&style=for-the-badge&logo=youtube&logoColor=white" alt="YouTube" style="margin-bottom: 5px;" />
</a>
<a href="https://discord.gg/t6MGsCqdFX" target="_blank">
<img src="https://img.shields.io/badge/discord-%237289DA.svg?&style=for-the-badge&logo=discord&logoColor=white" alt="Discord" style="margin-bottom: 5px;" />
</a>
<a href="https://stackoverflow.com/users/22484161/alex-smagin" target="_blank">
<img src=https://img.shields.io/badge/stackoverflow-%23F28032.svg?&style=for-the-badge&logo=stackoverflow&logoColor=white alt=stackoverflow style="margin-bottom: 5px;" />
</a>
<a href="https://dribbble.com/Alexandrbig1" target="_blank">
<img src=https://img.shields.io/badge/dribbble-%23E45285.svg?&style=for-the-badge&logo=dribbble&logoColor=white alt=dribbble style="margin-bottom: 5px;" />
</a>
<a href="https://www.behance.net/a1126" target="_blank">
<img src=https://img.shields.io/badge/behance-%23191919.svg?&style=for-the-badge&logo=behance&logoColor=white alt=behance style="margin-bottom: 5px;" />
</a>
<a href="https://www.upwork.com/freelancers/~0117da9f9f588056d2" target="_blank">
<img src="https://img.shields.io/badge/upwork-%230077B5.svg?&style=for-the-badge&logo=upwork&logoColor=white&color=%23167B02" alt="Upwork" style="margin-bottom: 5px;" />
</a>
</div>
