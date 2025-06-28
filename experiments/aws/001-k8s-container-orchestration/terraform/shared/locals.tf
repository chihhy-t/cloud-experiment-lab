locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name

  common_tags = {
    Project     = "cloud-experiment-lab"
    Experiment  = "001-k8s-container-orchestration"
    ManagedBy   = "terraform"
    Environment = var.environment
  }
}