provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

locals {
  cluster_name = "guru-eks-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  name = "guru-vpc"

  cidr = "10.0.0.0/16"
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.5.1"

  cluster_name    = local.cluster_name
  cluster_version = "1.24"

  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

  eks_managed_node_groups = {
    one = {
      name = "node-group-1"
      instance_types = ["m5.large"]
      min_size     = 1
      max_size     = 3
      desired_size = 2
    }

    two = {
      name = "node-group-2"
      instance_types = ["m5.large"]
      min_size     = 1
      max_size     = 2
      desired_size = 1
    }

    three = {
      name = "node-group-3"
      instance_types = ["m5.large"]
      min_size     = 1
      max_size     = 2
      desired_size = 1
    }

    four = {
      name = "node-group-4"
      instance_types = ["m5.large"]
      min_size     = 1
      max_size     = 2
      desired_size = 1
    }

    five = {
      name = "node-group-5"
      instance_types = ["m5.large"]
      min_size     = 1
      max_size     = 2
      desired_size = 1
    }

    six = {
      name = "node-group-6"
      instance_types = ["m5.large"]
      min_size     = 1
      max_size     = 2
      desired_size = 1
    }

    seven = {
      name = "node-group-7"
      instance_types = ["m5.large"]
      min_size     = 1
      max_size     = 2
      desired_size = 1
    }
  }
}

data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

module "irsa-ebs-csi" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "4.7.0"

  create_role                   = true
  role_name                     = "AmazonEKSTFEBSCSIRole-${module.eks.cluster_name}"
  provider_url                  = module.eks.oidc_provider
  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}

resource "aws_eks_addon" "ebs-csi" {
  cluster_name             = module.eks.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.5.2-eksbuild.1"
  service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
  tags = {
    "eks_addon" = "ebs-csi"
    "terraform" = "true"
  }
}

resource "null_resource" "helm_install" {
  provisioner "local-exec" {
    command = <<EOT
    aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.region}
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    helm repo add grafana https://grafana.github.io/helm-charts
    helm repo add elastic https://helm.elastic.co
    helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
    helm repo add fluent https://fluent.github.io/helm-charts
    helm repo update

    helm install prometheus prometheus-community/prometheus --namespace monitoring --create-namespace
    helm install grafana grafana/grafana --namespace monitoring --create-namespace
    helm install elasticsearch elastic/elasticsearch --namespace logging --create-namespace
    helm install logstash elastic/logstash --namespace logging --create-namespace
    helm install kibana elastic/kibana --namespace logging --create-namespace
    helm install jaeger jaegertracing/jaeger --namespace tracing --create-namespace
    helm install fluentd fluent/fluentd --namespace logging --create-namespace -f fluentd-values.yaml

    kubectl apply -f complete-demo.yaml

    POD_NAME=$(kubectl get pods -n monitoring -l "app.kubernetes.io/name=grafana" -o jsonpath="{.items[0].metadata.name}")
    kubectl exec -it $POD_NAME -n monitoring -- grafana-cli plugins install grafana-llm-app
    kubectl delete pod $POD_NAME -n monitoring
    EOT
  }
  depends_on = [module.eks]
}

resource "helm_release" "fluentd" {
  name       = "fluentd"
  repository = "https://fluent.github.io/helm-charts"
  chart      = "fluentd"
  namespace  = "logging"
  values = [
    file("${path.module}/fluentd-values.yaml")
  ]
}
