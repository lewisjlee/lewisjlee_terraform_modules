resource "aws_ecr_repository" "ecr_repository" {
  name = var.SERVICE_NAME
}