output "jenkins_url" {
  description = "Jenkins LoadBalancer URL"
  value       = "http://${data.kubernetes_service.jenkins.status.0.load_balancer.0.ingress.0.hostname}:8080"
}

output "jenkins_admin_user" {
  description = "Jenkins admin username"
  value       = var.jenkins_admin_user
}

output "jenkins_admin_password" {
  description = "Jenkins admin password"
  value       = var.jenkins_admin_password
  sensitive   = true
}

output "jenkins_namespace" {
  description = "Jenkins namespace"
  value       = var.namespace
}

# Data source to get LoadBalancer hostname
data "kubernetes_service" "jenkins" {
  metadata {
    name      = "jenkins"
    namespace = var.namespace
  }
  
  depends_on = [helm_release.jenkins]
}