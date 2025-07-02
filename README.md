# microservice-project

<img align="right" src="https://media.giphy.com/media/du3J3cXyzhj75IOgvA/giphy.gif" width="100"/>

[![GitHub last commit](https://img.shields.io/github/last-commit/Alexandrbig1/microservice-project)](https://github.com/Alexandrbig1/microservice-project/commits/main)
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

## DevOps CI/CD

This repository contains a Kanban board and scripts for automating common DevOps tasks as part of the DevOps module.

---

## Features

- Kanban board for task management
- Bash scripts for environment setup and automation
- Automated installation of Node.js, npm, git, Docker, Express.js, etc.
- Modular AWS infrastructure provisioning with Terraform (VPC, S3, DynamoDB, ECR)

---

## AWS Infrastructure as Code (Terraform)

This repository includes a modular Terraform project for provisioning AWS infrastructure as part of the DevOps curriculum.

**Features:**

- Remote state management using S3 and DynamoDB
- Automated creation of VPCs with public/private subnets and routing
- Elastic Container Registry (ECR) for Docker images
- Modular structure for easy reuse and scalability

**Usage:**

1. Navigate to the AWS Terraform project directory:
   ```bash
   cd src/project/aws-terraform
   ```
2. Initialize and apply the infrastructure:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```
3. Destroy resources when finished:
   ```bash
   terraform destroy
   ```

**Note:**  
The S3 bucket and DynamoDB table for remote state must be created manually before the first `terraform init`.

For full details, see the [AWS Terraform module README](src/project/aws-terraform/README.md).

---

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
