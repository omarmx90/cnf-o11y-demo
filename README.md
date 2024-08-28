# cnf-o11y-demo

 # Overview

This repository contains Terraform code to provision and manage a Grafana dashboard tailored for observability. The dashboard is designed to monitor metrics and logs from various sources, such as Prometheus and OpenSearch, in a cloud environment.

 # Features

Automated Infrastructure Setup: The Terraform configuration sets up a Virtual Private Cloud (VPC) and an Elastic Kubernetes Service (EKS) cluster on AWS.

- Grafana Dashboard as Code: Define and deploy Grafana dashboards using Terraform, ensuring that your observability setup is version-controlled and reproducible.

- Pre-configured Metrics and Logs Panels: The dashboard includes panels for monitoring:

- AWS EC2 instances via Prometheus.
- Logs from OpenSearch to visualize real-time log data.
- Integration with OpenTelemetry: Includes a Helm chart installation to deploy OpenTelemetry components for distributed tracing and observability.


## Repository Structure


```bash main.tf```: Main Terraform configuration file that sets up the VPC, EKS cluster, and necessary IAM roles.

```bash variables.tf```: Defines the variables used in the Terraform configuration, such as AWS region, cluster name, etc.

```bash outputs.tf```: Specifies the outputs from the Terraform configuration, such as the cluster endpoint and security group IDs.

```bash provider.tf```: Contains provider configurations, including AWS, Kubernetes, and Grafana.

```bash dashboard.tf```: Terraform code to define and deploy the Grafana dashboard for observability.

```bash README.md```: This file, providing an overview of the repository and instructions for use.
Usage


## Prerequisites

Terraform: Install Terraform (>= 1.3) on your local machine.

AWS CLI: Ensure you have the AWS CLI installed and configured with appropriate credentials.

Grafana API Key: Obtain a Grafana API key for dashboard management.

##  Steps to Deploy

### Clone the Repository

```bash
git clone https://github.com/your-username/your-repo-name.git
cd your-repo-name
```

###  Configure Variables

Edit the variables.tf file to set your AWS region, cluster name, and Grafana details.

### Initialize Terraform

```bash
terraform init
```

### Apply the Terraform Configuration

```bash
terraform apply
```

Review the changes Terraform plans to make and type yes to confirm.
Access the Grafana Dashboard

Once the deployment is complete, you can access the Grafana dashboard using the URL provided in the Terraform output.

# Customization

Modifying the Dashboard: You can customize the Grafana dashboard by editing the dashboard.tf file. Add or modify panels to suit your observability needs.

Adding New Metrics/Logs: Extend the existing dashboard by adding new Prometheus queries or log queries to monitor additional aspects of your infrastructure.
