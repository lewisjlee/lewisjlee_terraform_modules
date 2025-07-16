resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "${var.SERVICE_NAME}-eks-node-group-${var.ENVIRONMENT}"
  node_role_arn   = aws_iam_role.eks_worker_role.arn
  instance_types  = [var.node_instance_type]
  subnet_ids = [
    aws_subnet.nodes_subnet_1.id,
    aws_subnet.nodes_subnet_2.id
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
    aws_iam_role_policy_attachment.eks_worker_role_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_worker_role_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks_worker_role_AmazonEC2ContainerRegistryReadOnly,
    //aws_iam_role_policy_attachment.eks_worker_role_AmazonSSMManagedInstanceCore
  ]
}

resource "aws_iam_role" "eks_worker_role" {
  name = "${var.SERVICE_NAME}_eks_worker_role_${var.ENVIRONMENT}"

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

resource "aws_iam_role_policy_attachment" "eks_worker_role_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.eks_worker_role.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_role_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.eks_worker_role.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_role_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = aws_iam_role.eks_worker_role.name
}

/*resource "aws_iam_role_policy_attachment" "eks_worker_role_AmazonSSMManagedInstanceCore" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role = aws_iam_role.eks_worker_role.name
}*/

