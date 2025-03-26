variable "oidc_id" {
  description = "The OIDC ID of the EKS cluster"
  type        = string
}

variable "url" {
  description = "The URL of the OIDC provider for the EKS cluster"
  type        = string
}