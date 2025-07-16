data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "${var.SERVICE_NAME}_vpc_${var.ENVIRONMENT}"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, 1)
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.SERVICE_NAME}-public-subnet-1-${var.ENVIRONMENT}"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, 2)
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.SERVICE_NAME}-public-subnet-2-${var.ENVIRONMENT}"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "nodes_subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, 10)
  map_public_ip_on_launch = "false"
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.SERVICE_NAME}_nodes_subnet_1_${var.ENVIRONMENT}"
    "kubernetes.io/role/internal-elb" = "1"
  }
}


resource "aws_subnet" "nodes_subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, 11)
  map_public_ip_on_launch = "false"
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.SERVICE_NAME}_nodes_subnet_2_${var.ENVIRONMENT}"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "elasticache_subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, 20)
  map_public_ip_on_launch = "false"
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.SERVICE_NAME}_elasticache_subnet_1_${var.ENVIRONMENT}"
  }
}

resource "aws_subnet" "elasticache_subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, 21)
  map_public_ip_on_launch = "false"
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.SERVICE_NAME}_elasticache_subnet_2_${var.ENVIRONMENT}"
  }
}

resource "aws_subnet" "rds_subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, 30)
  map_public_ip_on_launch = "false"
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.SERVICE_NAME}_rds_subnet_1_${var.ENVIRONMENT}"
  }
}

resource "aws_subnet" "rds_subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, 31)
  map_public_ip_on_launch = "false"
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.SERVICE_NAME}_rds_subnet_2_${var.ENVIRONMENT}"
  }
}

# Internet GW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.SERVICE_NAME}_igw_${var.ENVIRONMENT}"
  }
}

# route tables
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    cidr_block = var.vpc_cidr_block
    gateway_id = "local"
  }

  tags = {
    Name = "${var.SERVICE_NAME}_rt_${var.ENVIRONMENT}"
  }
}

# route associations public
resource "aws_route_table_association" "public_1_a" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_2_a" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

# NAT Gateway용 EIP
resource "aws_eip" "nat" {
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = "${var.SERVICE_NAME}_nat_eip_${var.ENVIRONMENT}"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet_1.id
  depends_on    = [aws_internet_gateway.igw]
  tags = {
    Name = "${var.SERVICE_NAME}_nat_${var.ENVIRONMENT}"
  }
}

# nodes_subnet용 라우팅 테이블
resource "aws_route_table" "nodes_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  route {
    cidr_block = var.vpc_cidr_block
    gateway_id = "local"
  }
  tags = {
    Name = "${var.SERVICE_NAME}_nodes_rt_${var.ENVIRONMENT}"
  }
}

# nodes_subnet 라우팅 테이블 연결
resource "aws_route_table_association" "nodes_1_a" {
  subnet_id      = aws_subnet.nodes_subnet_1.id
  route_table_id = aws_route_table.nodes_rt.id
}

resource "aws_route_table_association" "nodes_2_a" {
  subnet_id      = aws_subnet.nodes_subnet_2.id
  route_table_id = aws_route_table.nodes_rt.id
}