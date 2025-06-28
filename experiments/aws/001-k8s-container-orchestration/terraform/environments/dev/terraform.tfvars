# Environment Configuration
environment = "dev"
region      = "ap-northeast-1"

# EKS Cluster Configuration
cluster_name       = "k8s-experiment-dev"
kubernetes_version = "1.33"

# VPC Configuration
vpc_cidr = "10.0.0.0/16"

# Node Group Configuration (t3.small as per design doc)
node_group_settings = {
  instance_types = ["t3.small"]
  desired_size   = 2
  max_size       = 3
  min_size       = 1
}

# SSH Key (optional - set if you need SSH access to nodes)
# key_name = "your-key-pair-name"