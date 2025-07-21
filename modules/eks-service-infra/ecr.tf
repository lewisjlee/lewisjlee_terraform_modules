resource "aws_ecr_repository" "ecr_repository" {
  count = var.ENVIRONMENT == "prod" ? 1 : 0
  name  = var.SERVICE_NAME
}