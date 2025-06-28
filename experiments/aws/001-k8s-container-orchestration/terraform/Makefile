# EKS Container Orchestration - Terraform Management
# ====================================================

# Configuration
ENVIRONMENT ?= dev
REGION ?= ap-northeast-1
TERRAFORM_DIR = environments/$(ENVIRONMENT)

# Colors for output
GREEN = \033[0;32m
YELLOW = \033[0;33m
RED = \033[0;31m
BLUE = \033[0;34m
NC = \033[0m # No Color

.DEFAULT_GOAL := help

# Help target
help: ## Show available commands
	@echo "$(BLUE)EKS Container Orchestration - Available Commands$(NC)"
	@echo "=================================================="
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(GREEN)%-20s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(YELLOW)Environment:$(NC) $(ENVIRONMENT)"
	@echo "$(YELLOW)Region:$(NC) $(REGION)"
	@echo ""
	@echo "$(YELLOW)Usage Examples:$(NC)"
	@echo "  make plan                      # Plan deployment to dev environment"
	@echo "  make apply                     # Apply changes to dev environment"
	@echo "  make destroy                   # Destroy dev environment"
	@echo "  ENVIRONMENT=prod make plan     # Plan deployment to prod environment"

# Prerequisites check
check-prereqs: ## Check required tools and AWS authentication
	@echo "$(BLUE)🔍 Checking prerequisites...$(NC)"
	@command -v terraform >/dev/null || (echo "$(RED)❌ Terraform not found. Please install Terraform.$(NC)" && exit 1)
	@command -v aws >/dev/null || (echo "$(RED)❌ AWS CLI not found. Please install AWS CLI.$(NC)" && exit 1)
	@aws sts get-caller-identity >/dev/null || (echo "$(RED)❌ AWS not configured. Run 'aws configure'.$(NC)" && exit 1)
	@echo "$(GREEN)✅ Prerequisites check passed$(NC)"

# Terraform initialization
init: check-prereqs ## Initialize Terraform
	@echo "$(BLUE)📋 Initializing Terraform...$(NC)"
	@cd $(TERRAFORM_DIR) && terraform init
	@echo "$(GREEN)✅ Terraform initialized$(NC)"

# Configuration validation
validate: init ## Validate and format Terraform configuration
	@echo "$(BLUE)🔍 Validating Terraform configuration...$(NC)"
	@cd $(TERRAFORM_DIR) && terraform validate
	@echo "$(BLUE)🔧 Formatting Terraform files...$(NC)"
	@terraform fmt -recursive .
	@echo "$(GREEN)✅ Validation and formatting completed$(NC)"

# Deployment planning
plan: validate ## Plan Terraform deployment
	@echo "$(BLUE)📊 Planning Terraform deployment...$(NC)"
	@cd $(TERRAFORM_DIR) && terraform plan -var-file=terraform.tfvars
	@echo "$(YELLOW)💡 Review the plan above before deploying$(NC)"

# EKS cluster deployment
apply: plan ## Apply EKS cluster changes
	@echo "$(BLUE)🚀 Applying EKS cluster changes...$(NC)"
	@cd $(TERRAFORM_DIR) && terraform apply -var-file=terraform.tfvars -auto-approve
	@echo "$(GREEN)✅ EKS cluster apply completed!$(NC)"
	@echo ""
	@echo "$(YELLOW)📝 Next steps:$(NC)"
	@echo "1. Use GitHub Actions for application deployment and kubectl operations"

# Cluster destruction
destroy: ## Destroy EKS cluster (with confirmation)
	@echo "$(BLUE)🔥 Planning EKS cluster destruction...$(NC)"
	@cd $(TERRAFORM_DIR) && terraform plan -destroy -var-file=terraform.tfvars
	@echo ""
	@echo "$(RED)⚠️  This will permanently delete all resources!$(NC)"
	@echo "$(RED)⚠️  This action cannot be undone!$(NC)"
	@echo ""
	@read -p "Are you sure you want to destroy the cluster? Type 'yes' to continue: " confirm && [ "$$confirm" = "yes" ] || (echo "$(YELLOW)Aborted.$(NC)" && exit 1)
	@cd $(TERRAFORM_DIR) && terraform destroy -var-file=terraform.tfvars -auto-approve
	@echo "$(GREEN)✅ EKS cluster destruction completed$(NC)"
	@echo "$(YELLOW)💰 Remember to check AWS console for any remaining resources$(NC)"


# Development utilities
fmt: ## Format all Terraform files
	@echo "$(BLUE)🔧 Formatting Terraform files...$(NC)"
	@terraform fmt -recursive .
	@echo "$(GREEN)✅ Formatting completed$(NC)"

clean: ## Clean Terraform cache and temporary files
	@echo "$(BLUE)🧹 Cleaning Terraform cache...$(NC)"
	@find . -name ".terraform" -type d -exec rm -rf {} + 2>/dev/null || true
	@find . -name ".terraform.lock.hcl" -delete 2>/dev/null || true
	@find . -name "terraform.tfstate.backup" -delete 2>/dev/null || true
	@echo "$(GREEN)✅ Cleanup completed$(NC)"


# Show current status
status: ## Show current infrastructure status
	@echo "$(BLUE)📊 Current Status:$(NC)"
	@echo "$(YELLOW)Environment:$(NC) $(ENVIRONMENT)"
	@echo "$(YELLOW)Region:$(NC) $(REGION)"
	@echo ""
	@if [ -f "$(TERRAFORM_DIR)/terraform.tfstate" ]; then \
		echo "$(GREEN)✅ Terraform state exists$(NC)"; \
		cd $(TERRAFORM_DIR) && terraform show -json | jq -r '.values.root_module.resources[] | select(.type == "aws_eks_cluster") | "EKS Cluster: " + .values.name + " (" + .values.status + ")"' 2>/dev/null || echo "$(YELLOW)Cluster info not available$(NC)"; \
	else \
		echo "$(RED)❌ No Terraform state found$(NC)"; \
	fi

# Show outputs
outputs: ## Show Terraform outputs
	@echo "$(BLUE)📋 Terraform Outputs:$(NC)"
	@if [ -f "$(TERRAFORM_DIR)/terraform.tfstate" ]; then \
		cd $(TERRAFORM_DIR) && terraform output; \
	else \
		echo "$(RED)❌ No Terraform state found. Deploy the cluster first.$(NC)"; \
	fi


# Phony targets
.PHONY: help check-prereqs init validate plan apply destroy fmt clean status outputs