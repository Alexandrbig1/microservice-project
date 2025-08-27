resource "helm_release" "jenkins" {
  name             = "jenkins"
  namespace        = "jenkins"
  repository       = "<https://charts.jenkins.io>"
  chart            = "jenkins"
  version          = "5.0.16"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
