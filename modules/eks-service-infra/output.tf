data "aws_region" "current" {}

locals {
  kubeconfig = "aws eks update-kubeconfig --region ${data.aws_region.current.region} --name ${aws_eks_cluster.cluster.name}"
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.cluster.endpoint
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = aws_eks_cluster.cluster.name
}

output "identity" {
  description = "Kubernetes Cluster Identity"
  value       = aws_eks_cluster.cluster.identity
}

output "kubeconfig_command" {
  description = "Command to update kubeconfig for the EKS cluster"
  value       = local.kubeconfig
}
