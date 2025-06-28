provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  common_tags = {
    Project     = "cloud-experiment-lab"
    Experiment  = "001-k8s-container-orchestration"
    ManagedBy   = "terraform"
    Environment = var.environment
  }
}

module "vpc" {
  source = "../../modules/vpc"

  cluster_name = var.cluster_name
  vpc_cidr     = var.vpc_cidr
  tags         = local.common_tags
}

module "eks" {
  source = "../../modules/eks"

  cluster_name         = var.cluster_name
  kubernetes_version   = var.kubernetes_version
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids
  public_subnet_ids   = module.vpc.public_subnet_ids
  tags                = local.common_tags

  depends_on = [module.vpc]
}

module "node_groups" {
  source = "../../modules/node-groups"

  cluster_name              = var.cluster_name
  vpc_id                   = module.vpc.vpc_id
  private_subnet_ids       = module.vpc.private_subnet_ids
  cluster_security_group_id = module.eks.cluster_security_group_id
  instance_types           = var.node_group_settings.instance_types
  desired_size             = var.node_group_settings.desired_size
  max_size                 = var.node_group_settings.max_size
  min_size                 = var.node_group_settings.min_size
  key_name                 = var.key_name
  tags                     = local.common_tags

  depends_on = [module.eks]
}

module "monitoring" {
  source = "../../modules/monitoring"

  cluster_name     = var.cluster_name
  node_role_name   = regex("[^/]+$", module.node_groups.node_role_arn)
  tags             = local.common_tags

  depends_on = [module.node_groups]
}