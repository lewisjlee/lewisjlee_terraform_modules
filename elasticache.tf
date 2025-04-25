resource "aws_security_group" "cache-redis-sg" {
  vpc_id      = aws_vpc.main.id
  name        = "cache-redis-sg"
  description = "Elasticache-redis security group"
  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    cidr_blocks = [
    aws_subnet.lewisjlee-nodes-1.cidr_block,
    aws_subnet.lewisjlee-nodes-2.cidr_block,
    ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }
  tags = {
    Name = "cache-redis-sg"
  }
}

resource "aws_elasticache_replication_group" "lewisjlee-elasticache-rg" {
  automatic_failover_enabled  = true
  multi_az_enabled = true
  preferred_cache_cluster_azs = ["${var.AWS_REGION}a", "${var.AWS_REGION}c"]
  replication_group_id        = "lewisjlee-rep-group-1"
  description                 = "ElastiCache replication"
  node_type                   = "cache.t2.micro"
  num_cache_clusters          = 2
  port                        = 6379
  security_group_ids = [aws_security_group.cache-redis-sg.id]
  subnet_group_name = aws_elasticache_subnet_group.lewisjlee-cache-subnet-group.name

  at_rest_encryption_enabled = true
}

resource "aws_elasticache_subnet_group" "lewisjlee-cache-subnet-group" {
  name       = "lewisjlee-cache-subnet"
  subnet_ids = [aws_subnet.lewisjlee-cache-1.id, aws_subnet.lewisjlee-cache-2.id]
}