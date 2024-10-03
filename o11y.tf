resource "aws_s3_bucket" "trail_bucket" {
  bucket = "eks-cloudtrail-bucket-${random_string.suffix.result}"
}

resource "aws_cloudtrail" "eks_trail" {
  name                          = "eks-cloudtrail"
  s3_bucket_name                = aws_s3_bucket.trail_bucket.bucket
  include_global_service_events = true
  is_multi_region_trail         = true
}

resource "aws_kms_key" "eks" {
  description = "KMS key for encrypting EKS logs"
}

resource "aws_cloudwatch_log_group" "eks_log_group" {
  name              = "/aws/eks/${local.cluster_name}/logs"
  retention_in_days = 90
  kms_key_id        = aws_kms_key.eks.arn
}

resource "aws_iam_policy" "xray_policy" {
  name        = "XRayDaemonWriteAccess"
  description = "Policy for XRay daemon to send traces"
  policy      = data.aws_iam_policy_document.xray_policy.json
}

data "aws_iam_policy_document" "xray_policy" {
  statement {
    actions   = ["xray:PutTraceSegments", "xray:PutTelemetryRecords"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy_attachment" "xray" {
  role       = module.eks.cluster_iam_role_arn
  policy_arn = aws_iam_policy.xray_policy.arn
}

resource "aws_iam_role_policy_attachment" "alb_ingress" {
  role       = module.eks.cluster_iam_role_arn
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_ALB_Ingress_Controller"
}


resource "null_resource" "helm_install_xray_alb" {
  depends_on = [module.eks]

  provisioner "local-exec" {
    command = <<EOT
    aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.region}
    helm repo add eks https://aws.github.io/eks-charts
    helm repo update
    helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=${module.eks.cluster_name}
    helm install xray-daemon aws/xray-daemon --set xray.region=${var.region}
    EOT
  }
}
