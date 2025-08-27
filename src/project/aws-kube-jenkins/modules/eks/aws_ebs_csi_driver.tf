# Створюємо IAM OIDC Provider для IRSA
resource "aws_iam_openid_connect_provider" "oidc" {
  url             = aws_eks_cluster.eks.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da0ecd6c6f9"]
}

# IAM роль для EBS CSI Driver
resource "aws_iam_role" "ebs_csi_irsa_role" {
  name = "${var.cluster_name}-ebs-csi-irsa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = aws_iam_openid_connect_provider.oidc.arn
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "${replace(aws_eks_cluster.eks.identity[0].oidc[0].issuer, "https://", "")}:sub" = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
        }
      }
    }]
  })
}

# Прикріплюємо офіційну політику до цієї ролі
resource "aws_iam_role_policy_attachment" "ebs_irsa_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.ebs_csi_irsa_role.name
}

# EKS Addon з привʼязаною IRSA IAM роллю
resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name                  = aws_eks_cluster.eks.name
  addon_name                    = "aws-ebs-csi-driver"
  addon_version                 = "v1.41.0-eksbuild.1"
  service_account_role_arn      = aws_iam_role.ebs_csi_irsa_role.arn
  resolve_conflicts_on_update  = "PRESERVE"

  depends_on = [
    aws_iam_openid_connect_provider.oidc,
    aws_iam_role_policy_attachment.ebs_irsa_policy
  ]
}

