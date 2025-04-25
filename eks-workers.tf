resource "aws_eks_node_group" "eks-node-group" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "eks-node-group"
  node_role_arn   = aws_iam_role.eks-worker-role.arn
  instance_types  = ["t3.small"]
  subnet_ids = [
    aws_subnet.lewisjlee-nodes-1.id,
    aws_subnet.lewisjlee-nodes-2.id
  ]

  scaling_config {
    desired_size = 2
    max_size     = 5
    min_size     = 2
  }

  lifecycle {
    ignore_changes = [
      scaling_config[0].desired_size
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-worker-role-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-worker-role-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-worker-role-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.eks-worker-role-AmazonSSMManagedInstanceCore
  ]

  provisioner "local-exec" {
    command = local.kubeconfig
  }
}

locals {
  kubeconfig = "aws eks update-kubeconfig --region ${var.AWS_REGION} --name ${aws_eks_cluster.cluster.name}"
}

resource "aws_iam_role" "eks-worker-role" {
  name = "eks-worker-role"

  assume_role_policy = jsonencode(
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
})
}

resource "aws_iam_role_policy_attachment" "eks-worker-role-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.eks-worker-role.name
}

resource "aws_iam_role_policy_attachment" "eks-worker-role-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.eks-worker-role.name
}

resource "aws_iam_role_policy_attachment" "eks-worker-role-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = aws_iam_role.eks-worker-role.name
}

resource "aws_iam_role_policy_attachment" "eks-worker-role-AmazonSSMManagedInstanceCore" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role = aws_iam_role.eks-worker-role.name
}

