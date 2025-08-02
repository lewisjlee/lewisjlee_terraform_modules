variable "SERVICE_NAME" {
  type   = string
  default = "servicename"
}

variable bastion_host_instance_type {
  default = "t2.micro"
}

variable "bastion_host_ami" {
  default = "ami-097e8439574e902b4"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "mykey"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "mykey.pub"
}

variable "LOCAL_PC_IP" {
}

variable "ENVIRONMENT" {
  type    = string
  default = "test"
}

variable "vpc_cidr_block" {
  default = "10.10.0.0/16"
}

variable "node_instance_type" {
  default = "t3.small"
}

variable "db_suffix" {
  type = map(string)
  default = {
    "primary" = "primary",
    "secondary" = "secondary"
  }
}

variable "dynamodb_billing_mode" {
  type        = string
  description = "DynamoDB 결제 모드 (PROVISIONED 또는 PAY_PER_REQUEST)"
  default     = "PAY_PER_REQUEST"
}

variable "dynamodb_read_capacity" {
  type        = number
  description = "DynamoDB 읽기 용량 (billing_mode가 PROVISIONED일 때만 사용)"
  default     = 5
}

variable "dynamodb_write_capacity" {
  type        = number
  description = "DynamoDB 쓰기 용량 (billing_mode가 PROVISIONED일 때만 사용)"
  default     = 5
}

variable "dynamodb_hash_key" {
  type        = string
  description = "DynamoDB 해시 키"
  default     = "id"
}

variable "dynamodb_range_key" {
  type        = string
  description = "DynamoDB 범위 키 (선택사항)"
  default     = null
}

variable "dynamodb_enable_point_in_time_recovery" {
  type        = bool
  description = "DynamoDB 포인트 인 타임 복구 활성화"
  default     = true
}

variable "dynamodb_enable_server_side_encryption" {
  type        = bool
  description = "DynamoDB 서버 사이드 암호화 활성화"
  default     = true
}