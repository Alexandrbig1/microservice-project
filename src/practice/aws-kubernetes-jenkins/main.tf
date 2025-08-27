provider "aws" {
  region = "us-east-1" 
}

module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "terraform-state-bucket-project-woolf-001"
  table_name  = "terraform-locks-project-woolf-001"
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  vpc_name           = "aws-iac-vpc"
}

module "ecr" {
  source      = "./modules/ecr"
  repository_name    = "aws-iac-ecr"
}

module "eks" {
  source = "./modules/eks"
  
  cluster_name    = "terraform-helm-project-woolf-001-eks-cluster"
  cluster_version = "1.28"
  
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = concat(module.vpc.private_subnet_ids, module.vpc.public_subnet_ids)
  
  node_group_name         = "terraform-helm-project-woolf-001-nodes"
  node_group_capacity     = "t3.medium"
  node_group_min_size     = 2
  node_group_max_size     = 6
  node_group_desired_size = 2
}

module "jenkins" {
  source       = "./modules/jenkins"
  cluster_name = module.eks.cluster_name
  kubeconfig   = module.eks.kubeconfig

  providers = {
    helm = helm
  }
}