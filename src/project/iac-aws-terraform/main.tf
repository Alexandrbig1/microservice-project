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
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
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
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name, "--region", "us-east-1"]
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name, "--region", "us-east-1"]
    }
  }
}

# S3 Backend Module
module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "terraform-state-bucket-final-project-woolf"
  table_name  = "terraform-locks-final-project-woolf"
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
  source       = "./modules/ecr"
  ecr_name     = "final-project-django-app"
  scan_on_push = true
}

# EKS Module
module "eks" {
  source = "./modules/eks"

  cluster_name    = "terraform-helm-final-project-woolf-eks-cluster"
  cluster_version = "1.28"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = concat(module.vpc.private_subnet_ids, module.vpc.public_subnet_ids)

  node_group_name         = "terraform-helm-final-project-woolf-nodes"
  node_group_capacity     = "t3.medium"
  node_group_min_size     = 2
  node_group_max_size     = 6
  node_group_desired_size = 2
}

# Security Group for EKS to RDS
resource "aws_security_group" "eks_to_rds" {
  name        = "woolf-final3-eks-rds"
  description = "Allow EKS nodes to access RDS databases"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "woolf-final-rds"
    Project     = "woolf-final"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}

# Security Group Rule for EKS Node Group -> RDS
resource "aws_security_group_rule" "eks_nodes_to_rds" {
  count                    = 1
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eks_to_rds.id
  security_group_id        = aws_security_group.eks_to_rds.id
  description              = "Allow EKS nodes to access PostgreSQL"
}

# RDS Module - PostgreSQL for Django (Development)
module "rds_postgres" {
  source = "./modules/rds"

  project_name = "woolf-final"
  environment  = "dev"

  # Main settings
  use_aurora     = false
  engine         = "postgres"
  engine_version = "16.9"
  instance_class = "db.t3.micro"

  # DB for Django
  db_name         = "djangodb"
  master_username = "djangouser"
  master_password = null

  # Network
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids

  # Allowed access from private routes (where EKS nodes is)
  allowed_cidr_blocks = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  # Dev settings
  multi_az                = false
  storage_encrypted       = true
  backup_retention_period = 3
  deletion_protection     = false
  skip_final_snapshot     = true

  # Custom params for Django (Without timezone - already as default_parameters)
  custom_db_parameters = [
    {
      name  = "max_connections"
      value = "200"
    },
    {
      name  = "checkpoint_completion_target"
      value = "0.9"
    }
  ]

  tags = {
    Project     = "woolf-final"
    Environment = "dev"
    ManagedBy   = "terraform"
    Module      = "rds"
    Purpose     = "django-database"
  }
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

# Monitoring Module (Prometheus + Grafana)
module "monitoring" {
  source = "./modules/monitoring"

  cluster_name     = module.eks.cluster_name
  cluster_endpoint = module.eks.cluster_endpoint
  namespace        = "monitoring"

  # Storage configuration (smaller sizes for simplicity)
  prometheus_storage_size = "20Gi"
  grafana_storage_size    = "5Gi"

  # Grafana configuration
  grafana_admin_password = "GrafanaAdmin123!" # Change this to a secure password

  depends_on = [module.eks]
}
