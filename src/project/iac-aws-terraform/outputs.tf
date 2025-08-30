output "s3_bucket_name" {
  description = "S3 bucket name for storing Terraform state files"
  value       = module.s3_backend.s3_bucket_name
}

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

# RDS outputs
output "postgres_db_endpoint" {
  description = "PostgreSQL database endpoint for Django"
  value       = module.rds_postgres.db_endpoint
}

output "postgres_db_port" {
  description = "PostgreSQL database port"
  value       = module.rds_postgres.db_port
}

output "postgres_db_name" {
  description = "PostgreSQL database name"
  value       = module.rds_postgres.db_name
}

output "postgres_db_username" {
  description = "PostgreSQL database username"
  value       = module.rds_postgres.db_username
}

output "postgres_db_password" {
  description = "PostgreSQL database password"
  value       = module.rds_postgres.master_password
  sensitive   = true
}

output "postgres_connection_string" {
  description = "PostgreSQL connection string for Django"
  value       = module.rds_postgres.connection_string
  sensitive   = true
}

output "postgres_security_group_id" {
  description = "PostgreSQL security group ID"
  value       = module.rds_postgres.security_group_id
}

# Monitoring outputs
output "prometheus_url" {
  description = "Prometheus server URL"
  value       = module.monitoring.prometheus_url
}

output "grafana_url" {
  description = "Grafana dashboard URL"
  value       = module.monitoring.grafana_url
}

output "grafana_admin_password" {
  description = "Grafana admin password"
  value       = module.monitoring.grafana_admin_password
  sensitive   = true
}

# Django configuration for Kubernetes
output "django_database_config" {
  description = "Database configuration for Django ConfigMap"
  value = {
    DATABASE_ENGINE = "django.db.backends.postgresql"
    DATABASE_NAME   = module.rds_postgres.db_name
    DATABASE_USER   = module.rds_postgres.db_username
    DATABASE_HOST   = module.rds_postgres.db_endpoint
    DATABASE_PORT   = tostring(module.rds_postgres.db_port)
  }
}

output "django_database_password" {
  description = "Database password for Django Secret"
  value       = module.rds_postgres.master_password
  sensitive   = true
}

# Deployment instructions
output "deployment_instructions" {
  description = "Instructions for accessing services"
  value       = <<EOF

🚀 CI/CD Infrastructure deployed successfully!

📊 Jenkins: ${module.jenkins.jenkins_url}
   Username: ${module.jenkins.jenkins_admin_user}
   Password: Use 'terraform output jenkins_admin_password' to get password

🔄 Argo CD: ${module.argo_cd.argocd_server_url}
   Username: admin
   Password: Use 'terraform output argocd_admin_password' to get password

🗄️  PostgreSQL Database:
   📘 Endpoint: ${module.rds_postgres.db_endpoint}:${module.rds_postgres.db_port}
   📘 Database: ${module.rds_postgres.db_name}
   📘 Username: ${module.rds_postgres.db_username}
   📘 Password: Use 'terraform output postgres_db_password' to get password

📋 Database Connection:
   psql -h ${module.rds_postgres.db_endpoint} -p ${module.rds_postgres.db_port} -U ${module.rds_postgres.db_username} -d ${module.rds_postgres.db_name}

🔐 Django Database Configuration:
   Use 'terraform output django_database_config' for ConfigMap
   Use 'terraform output django_database_password' for Secret

🛠️  Create Kubernetes ConfigMap:
   kubectl create configmap django-db-config \\
     --from-literal=DATABASE_ENGINE=django.db.backends.postgresql \\
     --from-literal=DATABASE_NAME=${module.rds_postgres.db_name} \\
     --from-literal=DATABASE_USER=${module.rds_postgres.db_username} \\
     --from-literal=DATABASE_HOST=${module.rds_postgres.db_endpoint} \\
     --from-literal=DATABASE_PORT=${module.rds_postgres.db_port} \\
     --namespace=django-app

🔑 Create Kubernetes Secret:
   kubectl create secret generic django-db-secret \\
     --from-literal=DATABASE_PASSWORD="$(terraform output -raw postgres_db_password)" \\
     --namespace=django-app

📝 Next steps:
1. Configure kubectl: aws eks update-kubeconfig --region us-east-1 --name ${module.eks.cluster_name}
2. Create django-app namespace: kubectl create namespace django-app
3. Apply database ConfigMap and Secret (commands above)
4. Update Django Helm chart to use database
5. Access Jenkins and configure AWS credentials
6. Create a pipeline job using the Jenkinsfile
7. Access Argo CD to monitor deployments
8. Push changes to trigger the CI/CD pipeline

🔧 Database Security:
   - Database is in private subnets (10.0.4.0/24, 10.0.5.0/24, 10.0.6.0/24)
   - Access only from EKS cluster private subnets
   - Encryption at rest enabled
   - Automated backups: 3 days retention
   - Auto-generated secure password

💡 Get database info:
   terraform output postgres_db_endpoint
   terraform output postgres_db_password
   terraform output django_database_config

EOF
}
