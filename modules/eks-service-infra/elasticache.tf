resource "aws_security_group" "elasticache_redis_sg" {
  vpc_id      = aws_vpc.main.id
  name        = "${var.SERVICE_NAME}-elasticache-redis-sg-${var.ENVIRONMENT}"
  description = "Elasticache-Redis security group"
  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    cidr_blocks = [
    aws_subnet.nodes_subnet_1.cidr_block,
    aws_subnet.nodes_subnet_2.cidr_block,
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
    Name = "elasticache_redis_sg"
  }
}

resource "aws_elasticache_replication_group" "elasticache_rg" {
  automatic_failover_enabled  = true
  multi_az_enabled = true
  preferred_cache_cluster_azs = slice(data.aws_availability_zones.available.names, 0, 2)
  replication_group_id        = "${var.SERVICE_NAME}-replication-group-1-${var.ENVIRONMENT}"
  description                 = "ElastiCache replication"
  node_type                   = "cache.t2.micro"
  num_cache_clusters          = 2
  port                        = 6379
  security_group_ids = [aws_security_group.elasticache_redis_sg.id]
  subnet_group_name = aws_elasticache_subnet_group.elasticache_subnet_group.name

  at_rest_encryption_enabled = true
}

resource "aws_elasticache_subnet_group" "elasticache_subnet_group" {
  name       = "${var.SERVICE_NAME}-elasticache-subnet-group-${var.ENVIRONMENT}"
  subnet_ids = [aws_subnet.elasticache_subnet_1.id, aws_subnet.elasticache_subnet_2.id]
}