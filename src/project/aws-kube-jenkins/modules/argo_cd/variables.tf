variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_endpoint" {
  description = "EKS cluster endpoint"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace for Argo CD"
  type        = string
  default     = "argocd"
}

variable "chart_version" {
  description = "Argo CD Helm chart version"
  type        = string
  default     = "5.51.4"
}

variable "git_repo_url" {
  description = "Git repository URL for Django app"
  type        = string
  default     = "https://github.com/yana-shapka/my-microservice-project.git"
}

variable "git_target_revision" {
  description = "Git branch/tag to track"
  type        = string
  default     = "cicd-project"
}

variable "django_app_namespace" {
  description = "Namespace for Django application"
  type        = string
  default     = "django-app"
}