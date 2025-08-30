# Kubernetes namespace for monitoring
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.namespace
  }
}

# Prometheus Helm Release
resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  version    = "25.8.0"

  timeout = 900
  wait    = true

  values = [
    templatefile("${path.module}/values/prometheus-values.yaml", {
      prometheus_storage_size = var.prometheus_storage_size
      cluster_name            = var.cluster_name
    })
  ]

  depends_on = [kubernetes_namespace.monitoring]
}

# Grafana Helm Release
resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  version    = "7.0.19"

  timeout = 900
  wait    = true

  values = [
    templatefile("${path.module}/values/grafana-values.yaml", {
      grafana_storage_size   = var.grafana_storage_size
      grafana_admin_password = var.grafana_admin_password
      prometheus_service     = "prometheus-server"
      namespace              = var.namespace
    })
  ]

  depends_on = [kubernetes_namespace.monitoring, helm_release.prometheus]
}

# ServiceMonitor for Django application (if using Prometheus Operator)
resource "kubernetes_config_map" "prometheus_config" {
  metadata {
    name      = "prometheus-extra-config"
    namespace = var.namespace
  }

  data = {
    "django-scrape.yml" = <<EOF
- job_name: 'django-app'
  kubernetes_sd_configs:
  - role: endpoints
    namespaces:
      names:
      - django-app
  relabel_configs:
  - source_labels: [__meta_kubernetes_service_name]
    action: keep
    regex: django-app
  - source_labels: [__meta_kubernetes_endpoint_port_name]
    action: keep
    regex: http
  - target_label: __address__
    replacement: __meta_kubernetes_endpoint_address_target_name:8000
  - source_labels: [__meta_kubernetes_pod_name]
    target_label: pod
  - source_labels: [__meta_kubernetes_namespace]
    target_label: namespace
EOF

    "jenkins-scrape.yml" = <<EOF
- job_name: 'jenkins'
  kubernetes_sd_configs:
  - role: endpoints
    namespaces:
      names:
      - jenkins
  relabel_configs:
  - source_labels: [__meta_kubernetes_service_name]
    action: keep
    regex: jenkins
  - source_labels: [__meta_kubernetes_endpoint_port_name]
    action: keep
    regex: http
  - target_label: __address__
    replacement: __meta_kubernetes_endpoint_address_target_name:8080
  - target_label: __metrics_path__
    replacement: /prometheus
EOF

    "rds-monitoring.yml" = <<EOF
# RDS monitoring would require CloudWatch exporter
# For now, basic Kubernetes and application metrics
- job_name: 'kubernetes-pods'
  kubernetes_sd_configs:
  - role: pod
  relabel_configs:
  - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
    action: keep
    regex: true
  - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
    action: replace
    target_label: __metrics_path__
    regex: (.+)
EOF
  }

  depends_on = [kubernetes_namespace.monitoring]
}
