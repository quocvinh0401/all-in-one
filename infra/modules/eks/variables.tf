variable "vpc_id" {
  description = "ID of the VPC"
  type        = string  
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
  
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string  
}

variable "desired_size" {
  description = "Desired number of worker nodes"
  type        = number
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  type        = number
}

variable "instance_type" {
  description = "Instance type"
  type        = string
}