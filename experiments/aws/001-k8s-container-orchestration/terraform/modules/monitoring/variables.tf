variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "node_role_name" {
  description = "Name of the EKS node group IAM role"
  type        = string
}

variable "log_retention_days" {
  description = "Number of days to retain log events in CloudWatch"
  type        = number
  default     = 7
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}