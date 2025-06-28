output "cluster_id" {
  description = "EKS cluster ID"
  value       = module.eks.cluster_id
}

output "cluster_arn" {
  description = "EKS cluster ARN"
  value       = module.eks.cluster_arn
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_version" {
  description = "The Kubernetes version for the EKS cluster"
  value       = module.eks.cluster_version
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = module.eks.cluster_certificate_authority_data
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnet_ids
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnet_ids
}

output "node_group_arn" {
  description = "Amazon Resource Name (ARN) of the EKS Node Group"
  value       = module.node_groups.node_group_arn
}

output "node_group_status" {
  description = "Status of the EKS Node Group"
  value       = module.node_groups.node_group_status
}

output "cloudwatch_log_groups" {
  description = "List of CloudWatch log groups created for Container Insights"
  value       = module.monitoring.cloudwatch_log_groups
}

output "kubectl_config" {
  description = "kubectl config command to connect to cluster"
  value       = "aws eks --region ${var.region} update-kubeconfig --name ${var.cluster_name}"
}