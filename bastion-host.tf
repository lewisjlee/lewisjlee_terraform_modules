resource "aws_instance" "bastion-host" {
  ami           = var.AMIS
  instance_type = "t2.micro"

  # the VPC subnet
  subnet_id = aws_subnet.lewisjlee-public-1.id

  # the security group
  vpc_security_group_ids = [aws_security_group.bastion-host-sg.id]

  # the public SSH key
  key_name = aws_key_pair.mykeypair.key_name
}

resource "aws_security_group" "bastion-host-sg" {
  vpc_id      = aws_vpc.main.id
  name        = "allow-ssh"
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
    cidr_blocks = ["58.225.107.164/32"]
  }
  tags = {
    Name = "bastion-host-sg"
  }
}

resource "aws_key_pair" "mykeypair" {
  key_name   = "mykeypair"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

