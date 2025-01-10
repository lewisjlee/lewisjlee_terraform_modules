resource "aws_security_group" "vpc-endpoint" {
  vpc_id = aws_vpc.main.id
  name = "vpc-endpoint-sg-eks"
  description = "sg to controll the access to eks"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpc-endpoint-sg-eks"
    "kubernetes.io/cluster/${var.cluster-name}" = "owned"
  }
}

resource "aws_security_group_rule" "endpoint-ingress" {
  description              = "Allow vpc endpoint to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.vpc-endpoint.id
  cidr_blocks = [
    aws_subnet.lewisjlee-was-1.cidr_block,
    aws_subnet.lewisjlee-was-2.cidr_block
  ]
  to_port                  = 443
  type                     = "ingress"
}