#!/bin/bash

# Clean up Terraform-related files
echo "Cleaning up Terraform cache and state files..."
rm -rf .terraform*  # Corrected flag to '-rf' instead of '-fr'
rm -rf terraform.tfstate*

# Configure AWS CLI
echo "Configuring AWS CLI..."
aws configure

# Initialize Terraform
echo "Initializing Terraform..."
terraform init
if [ $? -ne 0 ]; then
    echo "Terraform initialization failed. Exiting."
    exit 1
fi

# Apply Terraform configuration with auto-approve
echo "Applying Terraform configuration..."
terraform apply --auto-approve
if [ $? -ne 0 ]; then
    echo "Terraform apply failed. Exiting."
    exit 1
fi

# Wait for the Kubernetes service to be available before port-forwarding
echo "Waiting for Kubernetes service to be ready..."
kubectl wait --for=condition=available --timeout=60s svc/my-otel-demo-frontendproxy

# Port forward to the frontend service
echo "Setting up port forwarding on port 8080..."
kubectl port-forward svc/my-otel-demo-frontendproxy 8080:8080

