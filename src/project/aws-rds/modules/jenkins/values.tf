variable "controller" {
  description = "Jenkins controller configuration"
  type        = any
  default = {
    image = "jenkins/jenkins"
    tag   = "2.426.1-lts"

    resources = {
      requests = {
        cpu    = "1000m"
        memory = "2Gi"
      }
      limits = {
        cpu    = "2000m"
        memory = "4Gi"
      }
    }

    serviceType = "LoadBalancer"
    servicePort = 8080

    JCasC = {
      defaultConfig = true
      configScripts = {
        "welcome-message" = <<-EOT
          jenkins:
            systemMessage: "Jenkins for CI/CD Pipeline"
        EOT
      }
    }

    admin = {
      existingSecret = ""
      userKey        = "jenkins-admin-user"
      passwordKey    = "jenkins-admin-password"
    }

    installPlugins = [
      "kubernetes:3937.vd7b_82db_e347b_",
      "workflow-aggregator:2.6",
      "git:4.8.3",
      "configuration-as-code:1625.v27444588cc3d",
      "pipeline-stage-view:2.25",
      "docker-workflow:1.29",
      "blueocean:1.25.2",
      "github:1.37.0",
      "pipeline-github-lib:38.v445716ea_edda_",
      "aws-credentials:191.vcb_f183ce58b_9",
    ]

    additionalExistingSecrets = [
      { name = "aws-credentials", keyName = "aws-access-key-id" },
      { name = "aws-credentials", keyName = "aws-secret-access-key" },
    ]
  }
}

variable "agent" {
  description = "Jenkins agent configuration"
  type        = any
  default = {
    enabled = true
    image   = "jenkins/inbound-agent"
    tag     = "3107.v665000b_51092-5"
    podTemplates = {
      kaniko = <<-EOT
        - name: kaniko
          label: kaniko
          serviceAccount: jenkins-admin
          containers:
          - name: kaniko
            image: gcr.io/kaniko-project/executor:debug
            command: ["/busybox/cat"]
            tty: true
            volumeMounts:
            - name: aws-secret
              mountPath: /root/.aws/
          - name: git
            image: alpine/git:latest
            command: ["/bin/sh", "-c", "cat"]
            tty: true
          volumes:
          - name: aws-secret
            secret:
              secretName: aws-credentials
      EOT
    }
  }
}

variable "persistence" {
  description = "Jenkins persistence configuration"
  type        = any
  default = {
    enabled      = true
    storageClass = "gp2"
    size         = "20Gi"
    accessMode   = "ReadWriteOnce"
  }
}

variable "securityContext" {
  description = "Jenkins security context"
  type        = any
  default = {
    runAsUser = 1000
    fsGroup   = 1000
  }
}

variable "serviceAccount" {
  description = "Jenkins service account configuration"
  type        = any
  default = {
    create = false
    name   = "jenkins-admin"
  }
}

variable "rbac" {
  description = "Jenkins RBAC configuration"
  type        = any
  default = {
    create      = true
    readSecrets = true
  }
}
