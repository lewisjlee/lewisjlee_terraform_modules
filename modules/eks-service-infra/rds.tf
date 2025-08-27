locals {
  db_parameters = {
    max_allowed_packet  = "16777216"
  }
}

data "aws_rds_engine_version" "db_engine" {
  engine  = "aurora-mysql"
  version = "8.0.mysql_aurora.3.07.1"
}

resource "aws_security_group" "aurora_mysql_sg" {
  vpc_id      = aws_vpc.main.id
  name        = "${var.SERVICE_NAME}-aurora-mysql-sg-${var.ENVIRONMENT}"
  description = "Aurora-MySQL security group"
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks = [
    aws_subnet.nodes_subnet_1.cidr_block,
    aws_subnet.nodes_subnet_2.cidr_block,
    aws_subnet.elasticache_subnet_1.cidr_block,
    aws_subnet.elasticache_subnet_2.cidr_block
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
    Name = "aurora_mysql_sg"
  }
}

resource "aws_db_parameter_group" "default" {
  name        = "${var.SERVICE_NAME}-rds-cluster-pg-${var.ENVIRONMENT}"
  family      = "aurora-mysql8.0"
  description = "RDS default cluster parameter group"

  dynamic "parameter" {
    for_each = local.db_parameters
    content {
      name  = parameter.key
      value = parameter.value
    }
  }
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  for_each = var.db_suffix
  identifier         = "${var.SERVICE_NAME}-${var.ENVIRONMENT}-database-${each.value}"
  cluster_identifier = aws_rds_cluster.rds_cluster.id
  instance_class     = "db.t3.medium"
  engine             = aws_rds_cluster.rds_cluster.engine
  engine_version     = aws_rds_cluster.rds_cluster.engine_version
  db_parameter_group_name = aws_db_parameter_group.default.name
  lifecycle {
    ignore_changes = [
      cluster_identifier
    ]
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.SERVICE_NAME}-rds-subnet-group-${var.ENVIRONMENT}"
  subnet_ids = [aws_subnet.rds_subnet_1.id, aws_subnet.rds_subnet_2.id]

  tags = {
    Name = "RDS subnet group"
  }
}

resource "aws_rds_cluster" "rds_cluster" {
  cluster_identifier      = var.SERVICE_NAME
  engine                  = data.aws_rds_engine_version.db_engine.engine
  engine_version          = data.aws_rds_engine_version.db_engine.version
  availability_zones      = slice(data.aws_availability_zones.available.names, 0, 2)
  database_name           = var.SERVICE_NAME
  master_username = var.SERVICE_NAME
  manage_master_user_password = true
  backup_retention_period = 5
  preferred_backup_window = "04:00-05:00"

  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [
    aws_security_group.aurora_mysql_sg.id
  ]

  lifecycle {
    ignore_changes = [
      availability_zones
    ]
  }

  final_snapshot_identifier = "${var.SERVICE_NAME}-${var.ENVIRONMENT}-${formatdate("YYYYMMDD-hhmm",timestamp())}"
}

