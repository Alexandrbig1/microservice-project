output "s3_bucket_name" {
  description = "S3 bucket name for storing Terraform state files"
  value       = module.s3_backend.s3_bucket_name
}

# output "dynamodb_table_name" {
#   description = "DynamoDB table name for Terraform state locking"
#   value       = module.s3_backend.dynamodb_table_name
# }

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = module.ecr.repository_url
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_arn" {
  description = "EKS cluster ARN"
  value       = module.eks.cluster_arn
}

output "kubectl_config_command" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --region us-east-1 --name ${module.eks.cluster_name}"
}

output "jenkins_url" {
  description = "Jenkins LoadBalancer URL"
  value       = module.jenkins.jenkins_url
}

output "jenkins_admin_user" {
  description = "Jenkins admin username"
  value       = module.jenkins.jenkins_admin_user
}

output "jenkins_admin_password" {
  description = "Jenkins admin password"
  value       = module.jenkins.jenkins_admin_password
  sensitive   = true
}

output "argocd_server_url" {
  description = "Argo CD Server URL"
  value       = module.argo_cd.argocd_server_url
}

output "argocd_admin_password" {
  description = "Argo CD admin password"
  value       = module.argo_cd.argocd_admin_password
  sensitive   = true
}

# Deployment instructions
output "deployment_instructions" {
  description = "Instructions for accessing services"
  value = <<EOF

🚀 CI/CD Infrastructure deployed successfully!

📊 Jenkins: ${module.jenkins.jenkins_url}
   Username: ${module.jenkins.jenkins_admin_user}
   Password: Use 'terraform output jenkins_admin_password' to get password

🔄 Argo CD: ${module.argo_cd.argocd_server_url}
   Username: admin
   Password: Use 'terraform output argocd_admin_password' to get password

📝 Next steps:
1. Access Jenkins and configure AWS credentials
2. Create a pipeline job using the Jenkinsfile
3. Access Argo CD to monitor deployments
4. Push changes to trigger the CI/CD pipeline

EOF
}