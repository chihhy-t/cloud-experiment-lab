output "cloudwatch_log_groups" {
  description = "List of CloudWatch log groups created for Container Insights"
  value = [
    aws_cloudwatch_log_group.container_insights.name,
    aws_cloudwatch_log_group.container_insights_dataplane.name,
    aws_cloudwatch_log_group.container_insights_host.name,
    aws_cloudwatch_log_group.container_insights_performance.name
  ]
}

output "cloudwatch_agent_policy_arn" {
  description = "ARN of the CloudWatch Agent policy"
  value       = aws_iam_policy.cloudwatch_agent_server_policy.arn
}