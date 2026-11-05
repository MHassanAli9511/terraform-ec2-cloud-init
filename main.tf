terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.72.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}


resource "aws_instance" "nginx" {
  ami           = "ami-021aaf3749be66813"
  instance_type = "t3.micro"

  tags = {
    Name = "NginxInstance"
  }

  user_data = file("${path.module}/cloud-init.yaml")

  vpc_security_group_ids = [aws_security_group.nginx_sg.id]

  associate_public_ip_address = true

}


resource "aws_security_group" "nginx_sg" {
  name        = "nginx_sg"
  description = "Allow HTTP and HTTPs traffic"
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.nginx_sg.id
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "allow_http" {
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.nginx_sg.id
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "allow_https" {
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.nginx_sg.id
  cidr_ipv4         = "0.0.0.0/0"
}