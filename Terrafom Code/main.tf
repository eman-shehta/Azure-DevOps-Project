terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.95.0"
    }
  }
}

provider "aws" {
  region  = "eu-north-1"
  profile = "default"
}


resource "aws_security_group" "SG" {
  name        = var.SG_name
  description = "Security"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "aws_security_group"
    project = "Terraform-with-AzureDevOps"
  }
}


resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name    = "VPC"
    project = "Terraform-with-AzureDevOps"
  }
}


resource "aws_subnet" "pub_subnet_1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-north-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "pub_subnet_2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-north-1b"
  map_public_ip_on_launch = true
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "Internet Gateway"
    project = "Terraform-with-AzureDevOps"
  }
}


resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name    = "Route Table"
    project = "Terraform-with-AzureDevOps"
  }
}


resource "aws_route_table_association" "route_assoc_1" {
  subnet_id      = aws_subnet.pub_subnet_1.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "route_assoc_2" {
  subnet_id      = aws_subnet.pub_subnet_2.id
  route_table_id = aws_route_table.route_table.id
}


resource "aws_instance" "NewInstance_SSH" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.pub_subnet_1.id
  associate_public_ip_address = true

  key_name = "eman"
  vpc_security_group_ids = [aws_security_group.SG.id]

  tags = {
    Name    = var.tags_name
    project = "Terraform-with-AzureDevOps"
  }
}

output "instance_public_ip" {
  value = aws_instance.NewInstance_SSH.public_ip
}

