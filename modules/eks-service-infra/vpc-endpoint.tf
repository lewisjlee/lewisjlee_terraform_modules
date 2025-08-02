# S3 VPC 엔드포인트
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${data.aws_region.current.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [
    aws_route_table.nodes_rt_1.id,
    aws_route_table.nodes_rt_2.id
  ]
  tags = {
    Name = "${var.SERVICE_NAME}_s3_endpoint_${var.ENVIRONMENT}"
  }
}

# DynamoDB VPC 엔드포인트
resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${data.aws_region.current.region}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [
    aws_route_table.nodes_rt_1.id,
    aws_route_table.nodes_rt_2.id
  ]
  tags = {
    Name = "${var.SERVICE_NAME}_dynamodb_endpoint_${var.ENVIRONMENT}"
  }
} 