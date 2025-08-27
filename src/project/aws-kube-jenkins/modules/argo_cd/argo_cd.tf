# Kubernetes namespace for Argo CD
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.namespace
  }
}

# Kubernetes namespace for Django app
resource "kubernetes_namespace" "django_app" {
  metadata {
    name = "django-app"
  }
}

# Argo CD Helm release
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  version    = "5.51.6"

  timeout = 900   
  wait    = true  

  values = [
    file("${path.module}/values.yaml")
  ]

  depends_on = [kubernetes_namespace.argocd]
}