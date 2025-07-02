terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-project-woolf-001"
    key            = "aws-iac/terraform.tfstate"   
    region         = "us-east-1"                    
    dynamodb_table = "terraform-locks-project-woolf-001"              
    encrypt        = true                           
  }
}

