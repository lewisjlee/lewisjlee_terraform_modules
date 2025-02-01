output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.cluster.endpoint
}

output "region" {
  description = "AWS region"
  value       = var.AWS_REGION
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = aws_eks_cluster.cluster.name
}

output "identity" {
  description = "Kubernetes Cluster Identity"
  value       = aws_eks_cluster.cluster.identity
}
