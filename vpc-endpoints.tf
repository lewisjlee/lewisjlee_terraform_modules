resource "aws_vpc_endpoint" "ec2" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.ap-northeast-2.ec2"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.vpc-endpoint.id
  ]

  subnet_ids = [
    aws_subnet.lewisjlee-was-1.id,
    aws_subnet.lewisjlee-was-2.id
  ]

  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.ap-northeast-2.ecr.api"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.vpc-endpoint.id
  ]

  subnet_ids = [
    aws_subnet.lewisjlee-was-1.id,
    aws_subnet.lewisjlee-was-2.id
  ]

  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.ap-northeast-2.ecr.dkr"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.vpc-endpoint.id
  ]

  subnet_ids = [
    aws_subnet.lewisjlee-was-1.id,
    aws_subnet.lewisjlee-was-2.id
  ]

  private_dns_enabled = true
}

#resource "aws_vpc_endpoint" "rds" {
#  vpc_id            = aws_vpc.main.id
#  service_name      = "com.amazonaws.ap-northeast-2.rds"
#  vpc_endpoint_type = "Interface"

#  security_group_ids = [
#    aws_security_group.aurora-mysql-sg.id
#  ]

#  subnet_ids = [
#    aws_subnet.lewisjlee-was-1.id,
#    aws_subnet.lewisjlee-was-2.id
#  ]
#
#  private_dns_enabled = true
#}