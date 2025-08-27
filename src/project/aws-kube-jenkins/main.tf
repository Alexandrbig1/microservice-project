terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.24"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Kubernetes and Helm providers configuration
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name, "--region", "eu-north-1"]
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name, "--region", "eu-north-1"]
    }
  }
}

# S3 Backend Module
module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "terraform-state-bucket-project-woolf-002"
  table_name  = "terraform-locks-project-woolf-002"
}

# VPC Module  
module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  vpc_name           = "aws-iac-vpc"
}

# ECR Module
module "ecr" {
  source          = "./modules/ecr"
  repository_name = "aws-iac-ecr"
}

# EKS Module
module "eks" {
  source = "./modules/eks"

  cluster_name    = "terraform-helm-project-woolf-002-eks-cluster"
  cluster_version = "1.28"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = concat(module.vpc.private_subnet_ids, module.vpc.public_subnet_ids)

  node_group_name         = "terraform-helm-project-woolf-002-nodes"
  node_group_capacity     = "t3.medium"
  node_group_min_size     = 2
  node_group_max_size     = 6
  node_group_desired_size = 2
}

# Jenkins Module
module "jenkins" {
  source           = "./modules/jenkins"
  cluster_name     = module.eks.cluster_name
  cluster_endpoint = module.eks.cluster_endpoint
  namespace        = "jenkins"
}

# Argo CD Module  
module "argo_cd" {
  source = "./modules/argo_cd"

  cluster_name     = module.eks.cluster_name
  cluster_endpoint = module.eks.cluster_endpoint
  namespace        = "argocd"
}
