variable "controller" {
  type = any
  default = {
    admin = {
      username = "admin"
      password = "admin123"
    }
    serviceType = "LoadBalancer"
    servicePort = 80
    service = {
      port = 80
      targetPort = 8080
    }
    resources = {
      limits = {
        cpu    = "500m"
        memory = "1Gi"
      }
      requests = {
        cpu    = "250m"
        memory = "512Mi"
      }
    }
    persistentVolume = {
      enabled      = true
      storageClass = ""
      size         = "10Gi"
    }
    installPlugins = [
      "kubernetes:latest",
      "workflow-aggregator:latest",
      "git:latest",
      "configuration-as-code:latest",
      "credentials-binding:latest",
      "github:latest"
    ]
  }
}

