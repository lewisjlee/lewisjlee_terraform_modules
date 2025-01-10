resource "aws_vpc" "main" {
  cidr_block           = "10.10.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "projectA"
  }
}

resource "aws_subnet" "lewisjlee-public-1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.10.14.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.AWS_REGION}a"

  tags = {
    Name = "lewisjlee-public-1"
  }
}

resource "aws_subnet" "lewisjlee-public-2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.10.15.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.AWS_REGION}c"

  tags = {
    Name = "lewisjlee-public-2"
  }
}

resource "aws_subnet" "lewisjlee-was-1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.10.24.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.AWS_REGION}a"

  tags = {
    Name = "lewisjlee-was-1"
  }
}


resource "aws_subnet" "lewisjlee-was-2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.10.25.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.AWS_REGION}c"

  tags = {
    Name = "lewisjlee-was-2"
  }
}

resource "aws_subnet" "lewisjlee-cache-1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.10.34.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.AWS_REGION}a"

  tags = {
    Name = "lewisjlee-cache-1"
  }
}

resource "aws_subnet" "lewisjlee-cache-2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.10.35.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.AWS_REGION}c"

  tags = {
    Name = "lewisjlee-cache-2"
  }
}

resource "aws_subnet" "lewisjlee-db-1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.10.44.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.AWS_REGION}a"

  tags = {
    Name = "lewisjlee-db-1"
  }
}

resource "aws_subnet" "lewisjlee-db-2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.10.45.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.AWS_REGION}c"

  tags = {
    Name = "lewisjlee-db-2"
  }
}

# Internet GW
resource "aws_internet_gateway" "lewisjlee-gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.cluster-name
  }
}

# route tables
resource "aws_route_table" "lewisjlee-public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lewisjlee-gw.id
  }

  route {
    cidr_block = "10.10.0.0/16"
    gateway_id = "local"
  }

  tags = {
    Name = "lewisjlee-public-1"
  }
}

# route associations public
resource "aws_route_table_association" "lewisjlee-public-1-a" {
  subnet_id      = aws_subnet.lewisjlee-public-1.id
  route_table_id = aws_route_table.lewisjlee-public.id
}

resource "aws_route_table_association" "lewisjlee-public-2-a" {
  subnet_id      = aws_subnet.lewisjlee-public-2.id
  route_table_id = aws_route_table.lewisjlee-public.id
}