output "node_group_arn" {
  description = "Amazon Resource Name (ARN) of the EKS Node Group"
  value       = aws_eks_node_group.main.arn
}

output "node_group_status" {
  description = "Status of the EKS Node Group"
  value       = aws_eks_node_group.main.status
}

output "node_group_capacity_type" {
  description = "Type of capacity associated with the EKS Node Group"
  value       = aws_eks_node_group.main.capacity_type
}

output "node_group_instance_types" {
  description = "Set of instance types associated with the EKS Node Group"
  value       = aws_eks_node_group.main.instance_types
}

output "node_group_security_group_id" {
  description = "Security group ID attached to the EKS Node Group"
  value       = aws_security_group.node_group.id
}

output "node_role_arn" {
  description = "Amazon Resource Name (ARN) of the EKS Node Group IAM role"
  value       = aws_iam_role.node_group.arn
}