variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "k8s-experiment-dev"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "kubernetes_version" {
  description = "Kubernetes version to use for the EKS cluster"
  type        = string
  default     = "1.28"
}

variable "node_group_settings" {
  description = "Configuration settings for EKS node groups"
  type = object({
    instance_types = list(string)
    desired_size   = number
    max_size       = number
    min_size       = number
  })
  default = {
    instance_types = ["t3.small"]
    desired_size   = 2
    max_size       = 3
    min_size       = 1
  }
}

variable "key_name" {
  description = "EC2 Key Pair name for SSH access to nodes"
  type        = string
  default     = null
}