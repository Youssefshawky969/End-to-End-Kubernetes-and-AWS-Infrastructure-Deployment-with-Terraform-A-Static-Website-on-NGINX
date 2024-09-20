provider "aws" {
    region = "us-east-1"
    access_key = ""
    secret_key = ""
  
}

# VPC 
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
  
}

#subnets
resource "aws_subnet" "subnet_a" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
  
}

resource "aws_subnet" "subnet_b" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"
}

#internet Gateway

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
  
}

# Route table 

resource "aws_route_table" "main_rt" {
    vpc_id= aws_vpc.main.id
    route {
        cidr_block= "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
  
}

# secutiry group
resource "aws_security_group" "web_sg" {
    vpc_id = aws_vpc.main.id
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
}

# ELB
resource "aws_lb" "app_lb" {
    name = "app-load-balancer"
    internal = false
    load_balancer_type = "application"
    subnets = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
    security_groups = [aws_security_group.web_sg.id]
    
  
}