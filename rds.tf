resource "aws_security_group" "aurora-mysql-sg" {
  vpc_id      = aws_vpc.main.id
  name        = "aurora-mysql-sg"
  description = "Aurora-mysql security group"
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks = [
    aws_subnet.lewisjlee-nodes-1.cidr_block,
    aws_subnet.lewisjlee-nodes-2.cidr_block,
    aws_subnet.lewisjlee-cache-1.cidr_block,
    aws_subnet.lewisjlee-cache-2.cidr_block
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
    Name = "aurora-mysql-sg"
  }
}

data "aws_rds_engine_version" "db-engine" {
  engine             = "aurora-mysql"
  latest = true
}

resource "aws_rds_cluster_parameter_group" "default" {
  name        = "rds-cluster-pg"
  family      = "aurora5.6"
  description = "RDS default cluster parameter group"

  for_each = local.db-parameters

  parameter {
    name  = each.key
    value = each.value
  }
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  for_each = var.db-suffix
  identifier         = "database-${each.value}"
  cluster_identifier = aws_rds_cluster.lewisjlee-rds-cluster.id
  instance_class     = "db.t3.medium"
  engine             = aws_rds_cluster.lewisjlee-rds-cluster.engine
  engine_version     = aws_rds_cluster.lewisjlee-rds-cluster.engine_version
  lifecycle {
    ignore_changes = [
      cluster_identifier
    ]
  }
}

resource "aws_db_subnet_group" "rds-subnet-group" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.lewisjlee-db-1.id, aws_subnet.lewisjlee-db-2.id]

  tags = {
    Name = "RDS subnet group"
  }
}

resource "aws_rds_cluster" "lewisjlee-rds-cluster" {
  cluster_identifier      = "lewisjlee"
  engine                  = data.aws_rds_engine_version.db-engine.engine
  engine_version          = data.aws_rds_engine_version.db-engine.version
  availability_zones      = ["${var.AWS_REGION}a", "${var.AWS_REGION}c"]
  database_name           = "lewisjlee"
  master_username = "lewisjlee"
  manage_master_user_password = true
  backup_retention_period = 5
  preferred_backup_window = "04:00-05:00"

  db_subnet_group_name = aws_db_subnet_group.rds-subnet-group.name
  vpc_security_group_ids = [
    aws_security_group.aurora-mysql-sg.id
  ]

  lifecycle {
    ignore_changes = [
      availability_zones
    ]
  }

  final_snapshot_identifier = "lewisjlee-${formatdate("YYYYMMDD-hhmm",timestamp())}"
}

