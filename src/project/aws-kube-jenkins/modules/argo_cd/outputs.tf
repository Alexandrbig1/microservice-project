output "argocd_server_url" {
  description = "Argo CD Server LoadBalancer URL"
  value       = "http://${data.kubernetes_service.argocd_server.status.0.load_balancer.0.ingress.0.hostname}"
}

output "argocd_admin_password" {
  description = "Argo CD admin password"
  value       = data.kubernetes_secret.argocd_initial_admin_secret.data["password"]
  sensitive   = true
}

output "argocd_namespace" {
  description = "Argo CD namespace"
  value       = var.namespace
}

output "django_app_namespace" {
  description = "Django app namespace"
  value       = var.django_app_namespace
}

# Data sources for outputs
data "kubernetes_service" "argocd_server" {
  metadata {
    name      = "argocd-server"
    namespace = var.namespace
  }
  
  depends_on = [helm_release.argocd]
}

data "kubernetes_secret" "argocd_initial_admin_secret" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = var.namespace
  }
  
  depends_on = [helm_release.argocd]
}