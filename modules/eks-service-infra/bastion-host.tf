resource "aws_instance" "bastion_host" {
  ami           = var.bastion_host_ami
  instance_type = var.bastion_host_instance_type

  # the VPC subnet
  subnet_id = aws_subnet.public_subnet_1.id

  # the security group
  vpc_security_group_ids = [aws_security_group.bastion_host_sg.id]

  # the public SSH key
  key_name = aws_key_pair.mykeypair.key_name
}

resource "aws_security_group" "bastion_host_sg" {
  vpc_id      = aws_vpc.main.id
  name        = "${var.SERVICE_NAME}_allow_ssh_${var.ENVIRONMENT}"
  description = "security group that allows ssh and all egress traffic to bastion host"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.LOCAL_PC_IP]
  }
  tags = {
    Name = "${var.SERVICE_NAME}_bastion_host_sg_${var.ENVIRONMENT}"
  }
}

resource "aws_key_pair" "mykeypair" {
  key_name   = "mykeypair"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

