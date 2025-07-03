provider "aws" {
  region = "us-east-1" 
}

module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "terraform-state-bucket-project-woolf-002"
  table_name  = "terraform-locks-project-woolf-002"
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
  source          = "./modules/eks"          
  cluster_name    = "eks-cluster-demo"            
  subnet_ids      = module.vpc.public_subnets     
  instance_type   = "t2.micro"                    
  desired_size    = 1                             
  max_size        = 2                             
  min_size        = 1                             
}