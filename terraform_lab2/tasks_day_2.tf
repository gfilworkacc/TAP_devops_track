#Terraform backend s3 bucket
terraform {
  backend "s3" {
    bucket         = "tap-gf"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "tap-gf-table"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 1.0.0"
}

provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}

#Task 1: Create a VPC with at least 2 private subnets with different AZ.

#Virtual private cloud creation:
resource "aws_vpc" "tap_gf_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "tap_gf_vpc"
  }
}

#Public subnet creation:
resource "aws_subnet" "tap_gf_public_sns" {
  for_each = {
    subnet_1 = {
      name              = "tap_gf_public_sn_1",
      cidr_block        = "10.0.10.0/24",
      availability_zone = "eu-central-1a"
    },
    subnet_2 = {
      name              = "tap_gf_public_sn_2",
      cidr_block        = "10.0.11.0/24",
      availability_zone = "eu-central-1b"
    }
  }
  vpc_id                  = aws_vpc.tap_gf_vpc.id
  cidr_block              = each.value["cidr_block"]
  availability_zone       = each.value["availability_zone"]
  map_public_ip_on_launch = true
  tags = {
    Name = "tap_gf_public_sn"
  }
}

#Internet gateway creation:
resource "aws_internet_gateway" "tap_gf_igw" {
  vpc_id = aws_vpc.tap_gf_vpc.id
  tags = {
    Name = "tap_gf_igw"
  }
}

#Elastic IP for NAT:
resource "aws_eip" "tap_gf_nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.tap_gf_igw]
}

#Network address translation:

resource "aws_nat_gateway" "tap_gf_nat" {
  allocation_id = aws_eip.tap_gf_nat_eip.id
  subnet_id     = aws_subnet.tap_gf_public_sns["subnet_1"].id
  tags = {
    Name = "tap_gf_nat"
  }
}

#Private subnets creation:

resource "aws_subnet" "tap_gf_private_sns" {
  for_each = {
    subnet_1 = {
      name              = "tap_gf_sn_1",
      cidr_block        = "10.0.15.0/24",
      availability_zone = "eu-central-1a"
    },
    subnet_2 = {
      name              = "tap_gf_sn_2",
      cidr_block        = "10.0.20.0/24",
      availability_zone = "eu-central-1b"
    }
  }
  vpc_id                  = aws_vpc.tap_gf_vpc.id
  cidr_block              = each.value["cidr_block"]
  availability_zone       = each.value["availability_zone"]
  map_public_ip_on_launch = false
  tags = {
    Name = each.value["name"]
  }
}

#Routing table and routes:
resource "aws_route_table" "tap_gf_public_rtable" {
  vpc_id = aws_vpc.tap_gf_vpc.id
  tags = {
    Name = "tap_gf_public_rtable"
  }
}

resource "aws_route_table" "tap_gf_private_rtable" {
  vpc_id = aws_vpc.tap_gf_vpc.id
  tags = {
    Name = "tap_gf_private_rtable"
  }
}

resource "aws_route" "tap_gf_rt_public" {
  route_table_id         = aws_route_table.tap_gf_public_rtable.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.tap_gf_igw.id
}

resource "aws_route" "tap_gf_rt_private" {
  route_table_id         = aws_route_table.tap_gf_private_rtable.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.tap_gf_nat.id
}

resource "aws_route_table_association" "tap_gf_rta_public_1" {
  subnet_id      = aws_subnet.tap_gf_public_sns["subnet_1"].id
  route_table_id = aws_route_table.tap_gf_public_rtable.id
}

resource "aws_route_table_association" "tap_gf_rta_public_2" {
  subnet_id      = aws_subnet.tap_gf_public_sns["subnet_2"].id
  route_table_id = aws_route_table.tap_gf_public_rtable.id
}

resource "aws_route_table_association" "tap_gf_rta_private_1" {
  subnet_id      = aws_subnet.tap_gf_private_sns["subnet_1"].id
  route_table_id = aws_route_table.tap_gf_private_rtable.id
}

resource "aws_route_table_association" "tap_gf_rta_private_2" {
  subnet_id      = aws_subnet.tap_gf_private_sns["subnet_2"].id
  route_table_id = aws_route_table.tap_gf_private_rtable.id
}

#Security group creation:

resource "aws_security_group" "tap_gf_sg" {
  vpc_id = aws_vpc.tap_gf_vpc.id
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "TCP"
    cidr_blocks = ["0.0.0.0/0", "10.0.0.0/16"]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "TCP"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "tap_gf_sg"
  }
}



data "aws_ami" "tap_gf_ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-*-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_launch_configuration" "tap_gf_lc" {
  name          = "tap_gf_lc"
  image_id      = data.aws_ami.tap_gf_ubuntu.id
  instance_type = "t2.micro"
  key_name = "TAP_georgif"
  user_data     = <<EOF
#!/bin/bash
sudo apt update
sudp apt install -y nginx
sudo systemctl enable --now nginx.service
echo "Hello from $HOSTNAME" | sudo tee /var/www/html/index.html

EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "tap_gf_asg" {
  vpc_zone_identifier  = [for subnet in aws_subnet.tap_gf_public_sns : subnet.id]
  name                 = "tap_gf_asg"
  launch_configuration = aws_launch_configuration.tap_gf_lc.id
  target_group_arns = [aws_alb_target_group.tap_gf_lb_tg.arn]
  desired_capacity = 2
  min_size             = 1
  max_size             = 4

  lifecycle {
    create_before_destroy = true
  }
}

#Task 3: Create an ALB to distribute traffic across the ASG

resource "aws_security_group" "tap_gf_sg_alb" {
  vpc_id      = aws_vpc.tap_gf_vpc.id

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
    Name = "tap_gf_sg_alb"
  }
}

resource "aws_alb" "tap_gf_alb" {
  name = "tap-gf-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.tap_gf_sg_alb.id]
  subnets         = [for subnet in aws_subnet.tap_gf_public_sns: subnet.id]
  tags = {
    Name = "tap_gf_alb"
  }
}

resource "aws_alb_target_group" "tap_gf_lb_tg" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.tap_gf_vpc.id
  tags = {
    Name = "tap_gf_lb_tg"
  }
}

resource "aws_alb_listener" "tap_gf_lb_listener" {
  load_balancer_arn = aws_alb.tap_gf_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.tap_gf_lb_tg.arn
    type             = "forward"
  }
  tags = {
    Name = "tap_gf_lb_listener"
  }
}