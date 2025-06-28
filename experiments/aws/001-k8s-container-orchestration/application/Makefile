# K8s Container Orchestration Experiment - Application Makefile

# Docker image settings
FRONTEND_IMAGE := k8s-experiment/frontend:latest
BACKEND_IMAGE := k8s-experiment/backend:latest
DOCKER_REGISTRY ?= 
NAMESPACE := k8s-experiment

# AWS ECR settings (override these as needed)
AWS_REGION ?= ap-northeast-1
ECR_REPOSITORY_PREFIX ?= 

.PHONY: help build build-frontend build-backend push test clean deploy undeploy local-up local-down local-test k8s-apply k8s-delete

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# Docker operations
build: build-frontend build-backend ## Build all Docker images

build-frontend: ## Build frontend Docker image
	@echo "Building frontend image..."
	docker build -t $(FRONTEND_IMAGE) ./frontend

build-backend: ## Build backend Docker image
	@echo "Building backend image..."
	docker build -t $(BACKEND_IMAGE) ./backend

push: ## Push images to registry (requires DOCKER_REGISTRY)
	@if [ -z "$(DOCKER_REGISTRY)" ]; then \
		echo "Error: DOCKER_REGISTRY not set"; \
		echo "Usage: make push DOCKER_REGISTRY=your-registry.com"; \
		exit 1; \
	fi
	@echo "Tagging and pushing images to $(DOCKER_REGISTRY)..."
	docker tag $(FRONTEND_IMAGE) $(DOCKER_REGISTRY)/$(FRONTEND_IMAGE)
	docker tag $(BACKEND_IMAGE) $(DOCKER_REGISTRY)/$(BACKEND_IMAGE)
	docker push $(DOCKER_REGISTRY)/$(FRONTEND_IMAGE)
	docker push $(DOCKER_REGISTRY)/$(BACKEND_IMAGE)

push-ecr: ## Push images to AWS ECR (requires ECR_REPOSITORY_PREFIX)
	@if [ -z "$(ECR_REPOSITORY_PREFIX)" ]; then \
		echo "Error: ECR_REPOSITORY_PREFIX not set"; \
		echo "Usage: make push-ecr ECR_REPOSITORY_PREFIX=123456789012.dkr.ecr.ap-northeast-1.amazonaws.com"; \
		exit 1; \
	fi
	@echo "Logging into ECR..."
	aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(ECR_REPOSITORY_PREFIX)
	@echo "Tagging and pushing images to ECR..."
	docker tag $(FRONTEND_IMAGE) $(ECR_REPOSITORY_PREFIX)/k8s-experiment-frontend:latest
	docker tag $(BACKEND_IMAGE) $(ECR_REPOSITORY_PREFIX)/k8s-experiment-backend:latest
	docker push $(ECR_REPOSITORY_PREFIX)/k8s-experiment-frontend:latest
	docker push $(ECR_REPOSITORY_PREFIX)/k8s-experiment-backend:latest

# Local testing with docker-compose
local-up: build ## Start application locally with docker-compose
	@echo "Starting application locally..."
	docker-compose up -d
	@echo "Frontend available at: http://localhost:8080"
	@echo "Backend available at: http://localhost:8081"

local-down: ## Stop local application
	@echo "Stopping local application..."
	docker-compose down

local-test: ## Test local application endpoints
	@echo "Testing local application..."
	@echo "Frontend health check:"
	curl -s http://localhost:8080/health | jq . || echo "Frontend not responding"
	@echo ""
	@echo "Backend health check:"
	curl -s http://localhost:8081/health | jq . || echo "Backend not responding"
	@echo ""
	@echo "Backend users API:"
	curl -s http://localhost:8081/users | jq . || echo "Backend users API not responding"

# Kubernetes operations
k8s-apply: ## Apply Kubernetes manifests
	@echo "Creating namespace..."
	kubectl apply -f k8s/namespace.yaml
	@echo "Applying Kubernetes manifests..."
	kubectl apply -f k8s/backend-deployment.yaml
	kubectl apply -f k8s/backend-service.yaml
	kubectl apply -f k8s/frontend-deployment.yaml
	kubectl apply -f k8s/frontend-service.yaml
	kubectl apply -f k8s/ingress.yaml
	kubectl apply -f k8s/hpa.yaml
	@echo "Waiting for deployments to be ready..."
	kubectl wait --for=condition=available --timeout=300s deployment/backend-deployment -n $(NAMESPACE)
	kubectl wait --for=condition=available --timeout=300s deployment/frontend-deployment -n $(NAMESPACE)

k8s-delete: ## Delete Kubernetes resources
	@echo "Deleting Kubernetes resources..."
	kubectl delete -f k8s/hpa.yaml --ignore-not-found=true
	kubectl delete -f k8s/ingress.yaml --ignore-not-found=true
	kubectl delete -f k8s/frontend-service.yaml --ignore-not-found=true
	kubectl delete -f k8s/frontend-deployment.yaml --ignore-not-found=true
	kubectl delete -f k8s/backend-service.yaml --ignore-not-found=true
	kubectl delete -f k8s/backend-deployment.yaml --ignore-not-found=true
	kubectl delete -f k8s/namespace.yaml --ignore-not-found=true

k8s-status: ## Show Kubernetes deployment status
	@echo "Namespace:"
	kubectl get namespace $(NAMESPACE) 2>/dev/null || echo "Namespace not found"
	@echo ""
	@echo "Deployments:"
	kubectl get deployments -n $(NAMESPACE) 2>/dev/null || echo "No deployments found"
	@echo ""
	@echo "Services:"
	kubectl get services -n $(NAMESPACE) 2>/dev/null || echo "No services found"
	@echo ""
	@echo "Ingress:"
	kubectl get ingress -n $(NAMESPACE) 2>/dev/null || echo "No ingress found"
	@echo ""
	@echo "HPA:"
	kubectl get hpa -n $(NAMESPACE) 2>/dev/null || echo "No HPA found"
	@echo ""
	@echo "Pods:"
	kubectl get pods -n $(NAMESPACE) 2>/dev/null || echo "No pods found"

k8s-logs: ## Show application logs
	@echo "Backend logs:"
	kubectl logs -l app=backend -n $(NAMESPACE) --tail=50 || echo "No backend logs"
	@echo ""
	@echo "Frontend logs:"
	kubectl logs -l app=frontend -n $(NAMESPACE) --tail=50 || echo "No frontend logs"

# Combined operations
deploy: build k8s-apply ## Build and deploy to Kubernetes

test: ## Test application (local or k8s based on what's running)
	@if docker-compose ps | grep -q "Up"; then \
		echo "Testing local deployment..."; \
		$(MAKE) local-test; \
	elif kubectl get namespace $(NAMESPACE) >/dev/null 2>&1; then \
		echo "Testing Kubernetes deployment..."; \
		$(MAKE) k8s-test; \
	else \
		echo "No deployment found. Run 'make local-up' or 'make deploy' first."; \
	fi

k8s-test: ## Test Kubernetes deployment
	@echo "Getting ingress URL..."
	@INGRESS_URL=$$(kubectl get ingress app-ingress -n $(NAMESPACE) -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null); \
	if [ -n "$$INGRESS_URL" ]; then \
		echo "Testing application at http://$$INGRESS_URL"; \
		echo "Frontend:"; \
		curl -s "http://$$INGRESS_URL/health" | jq . || echo "Frontend not responding"; \
		echo ""; \
		echo "Backend:"; \
		curl -s "http://$$INGRESS_URL/api/health" | jq . || echo "Backend not responding"; \
	else \
		echo "Ingress not ready yet. Try again in a few minutes."; \
	fi

clean: ## Clean up Docker images and containers
	@echo "Cleaning up..."
	docker-compose down --rmi all --volumes --remove-orphans 2>/dev/null || true
	docker rmi $(FRONTEND_IMAGE) $(BACKEND_IMAGE) 2>/dev/null || true
	docker system prune -f