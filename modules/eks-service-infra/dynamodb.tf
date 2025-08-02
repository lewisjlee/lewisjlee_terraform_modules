# DynamoDB 테이블 생성
resource "aws_dynamodb_table" "main" {
  name           = "${var.SERVICE_NAME}-dynamodb-table-${var.ENVIRONMENT}"
  billing_mode   = var.dynamodb_billing_mode
  hash_key       = var.dynamodb_hash_key
  range_key      = var.dynamodb_range_key

  dynamic "attribute" {
    for_each = concat(
      [{
        name = var.dynamodb_hash_key
        type = "S"
      }],
      var.dynamodb_range_key != null ? [{
        name = var.dynamodb_range_key
        type = "S"
      }] : []
    )
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  # PROVISIONED 모드일 때만 read_capacity와 write_capacity 설정
  read_capacity  = var.dynamodb_billing_mode == "PROVISIONED" ? var.dynamodb_read_capacity : null
  write_capacity = var.dynamodb_billing_mode == "PROVISIONED" ? var.dynamodb_write_capacity : null

  point_in_time_recovery {
    enabled = var.dynamodb_enable_point_in_time_recovery
  }

  server_side_encryption {
    enabled = var.dynamodb_enable_server_side_encryption
  }

  tags = {
    Name        = "${var.SERVICE_NAME}_dynamodb_table_${var.ENVIRONMENT}"
    Environment = var.ENVIRONMENT
    Service     = var.SERVICE_NAME
  }
}

# DynamoDB 접근을 위한 IAM 정책
resource "aws_iam_policy" "dynamodb_access" {
  name        = "${var.SERVICE_NAME}-dynamodb-access-${var.ENVIRONMENT}"
  description = "DynamoDB 접근을 위한 IAM 정책"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:BatchGetItem",
          "dynamodb:BatchWriteItem"
        ]
        Resource = [
          aws_dynamodb_table.main.arn,
          "${aws_dynamodb_table.main.arn}/index/*"
        ]
      }
    ]
  })

  tags = {
    Name        = "${var.SERVICE_NAME}-dynamodb-access-${var.ENVIRONMENT}"
    Environment = var.ENVIRONMENT
    Service     = var.SERVICE_NAME
  }
}

# EKS 노드 그룹에 DynamoDB 접근 권한 부여
resource "aws_iam_role_policy_attachment" "eks_node_dynamodb" {
  policy_arn = aws_iam_policy.dynamodb_access.arn
  role       = aws_iam_role.eks_node_group.name
} 