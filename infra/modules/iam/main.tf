data "aws_caller_identity" "current" {
  
}

resource "aws_iam_openid_connect_provider" "eks_oidc" {
  url = var.url
  # url = aws_eks_cluster.example.identity[0].oidc[0].issuer

  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]
}

resource "aws_iam_role" "ebs_csi_driver_role" {
  name               = "EKS_EBS_CSI_DriverRole"
  assume_role_policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/oidc.eks.ap-southeast-1.amazonaws.com/id/${var.oidc_id}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "oidc.eks.ap-southeast-1.amazonaws.com/id/${var.oidc_id}:sub": "system:serviceaccount:kube-system:ebs-csi-controller-sa",
          "oidc.eks.ap-southeast-1.amazonaws.com/id/${var.oidc_id}:aud": "sts.amazonaws.com"
        }
      }
    }
  ]
})
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver_policy_attachment" {
  role       = aws_iam_role.ebs_csi_driver_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}