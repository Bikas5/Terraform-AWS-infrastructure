# main.tf

# Specify the provider and region
provider "aws" {
  region = "us-east-1"  # Choose your AWS region
}

# Define a VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Define a subnet in the VPC
resource "aws_subnet" "main_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.1.0/24"
}

# Define a security group for the EC2 instance
resource "aws_security_group" "instance_sg" {
  vpc_id = aws_vpc.main_vpc.id
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
}

# Define an EC2 instance
resource "aws_instance" "my_instance" {
  ami             = "ami-0c55b159cbfafe1f0"  # Replace with a valid AMI ID for your region
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.main_subnet.id
  security_groups = [aws_security_group.instance_sg.name]
  
  tags = {
    Name = "MyTerraformInstance"
  }
}
