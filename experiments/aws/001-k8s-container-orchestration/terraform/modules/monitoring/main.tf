# =============================================================================
# IAM Resources
# =============================================================================

data "aws_iam_policy_document" "cloudwatch_agent_server_policy" {
  statement {
    actions = [
      "cloudwatch:PutMetricData",
      "ec2:DescribeVolumes",
      "ec2:DescribeTags",
      "logs:PutLogEvents",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
      "logs:DescribeLogGroups"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "cloudwatch_agent_server_policy" {
  name   = "${var.cluster_name}-cloudwatch-agent-server-policy"
  policy = data.aws_iam_policy_document.cloudwatch_agent_server_policy.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent_server_policy" {
  role       = var.node_role_name
  policy_arn = aws_iam_policy.cloudwatch_agent_server_policy.arn
}

# =============================================================================
# CloudWatch Log Group Resources
# =============================================================================

resource "aws_cloudwatch_log_group" "container_insights" {
  name              = "/aws/containerinsights/${var.cluster_name}/application"
  retention_in_days = var.log_retention_days

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "container_insights_dataplane" {
  name              = "/aws/containerinsights/${var.cluster_name}/dataplane"
  retention_in_days = var.log_retention_days

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "container_insights_host" {
  name              = "/aws/containerinsights/${var.cluster_name}/host"
  retention_in_days = var.log_retention_days

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "container_insights_performance" {
  name              = "/aws/containerinsights/${var.cluster_name}/performance"
  retention_in_days = var.log_retention_days

  tags = var.tags
}