output "oidc_id" {
  value = regex("https://oidc.eks.(.+).amazonaws.com/id/(.+)", aws_eks_cluster.this.identity[0].oidc[0].issuer)[1]
}

output "url" {
  value = aws_eks_cluster.this.identity[0].oidc[0].issuer
}