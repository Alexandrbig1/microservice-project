resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block   
  enable_dns_support   = true                 
  enable_dns_hostnames = true                 

  tags = {
    Name = "${var.vpc_name}-vpc"              
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)   
  vpc_id                  = aws_vpc.main.id              
  cidr_block              = var.public_subnets[count.index] 
  availability_zone       = var.availability_zones[count.index] 
  map_public_ip_on_launch = true                         

  tags = {
    Name = "${var.vpc_name}-public-subnet-${count.index + 1}"  
  }
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnets)   
  vpc_id            = aws_vpc.main.id               
  cidr_block        = var.private_subnets[count.index] 
  availability_zone = var.availability_zones[count.index] 

  tags = {
    Name = "${var.vpc_name}-private-subnet-${count.index + 1}"  
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id   

  tags = {
    Name = "${var.vpc_name}-igw"   
  }
}

