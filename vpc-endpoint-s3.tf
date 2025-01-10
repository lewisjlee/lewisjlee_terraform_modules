# https://docs.aws.amazon.com/vpc/latest/privatelink/gateway-endpoints.html
# We need this API as images are stored in S3 buckets. 
# So when it’s not enabled, nodes won’t be able to start essential services (pods)

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.ap-northeast-2.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [
    aws_route_table.was-1.id,
    aws_route_table.was-2.id
  ]
}

resource "aws_route_table" "was-1" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "was-2" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "was-1" {
  subnet_id      = aws_subnet.lewisjlee-was-1.id
  route_table_id = aws_route_table.was-1.id
}

resource "aws_route_table_association" "was-2" {
  subnet_id      = aws_subnet.lewisjlee-was-2.id
  route_table_id = aws_route_table.was-2.id
}