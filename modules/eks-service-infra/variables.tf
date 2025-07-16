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