output "prometheus_url" {
  description = "Prometheus server URL"
  value       = "http://${data.kubernetes_service.prometheus.status.0.load_balancer.0.ingress.0.hostname}"
}

output "grafana_url" {
  description = "Grafana dashboard URL"
  value       = "http://${data.kubernetes_service.grafana.status.0.load_balancer.0.ingress.0.hostname}"
}

output "grafana_admin_password" {
  description = "Grafana admin password"
  value       = var.grafana_admin_password
  sensitive   = true
}

output "monitoring_namespace" {
  description = "Monitoring namespace"
  value       = var.namespace
}

# Data sources for outputs
data "kubernetes_service" "prometheus" {
  metadata {
    name      = "prometheus-server"
    namespace = var.namespace
  }

  depends_on = [helm_release.prometheus]
}

data "kubernetes_service" "grafana" {
  metadata {
    name      = "grafana"
    namespace = var.namespace
  }

  depends_on = [helm_release.grafana]
}
