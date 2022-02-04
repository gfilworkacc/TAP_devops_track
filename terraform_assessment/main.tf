#ECR task:
resource "aws_ecr_repository" "tap_gf_repo" {
  name = "tap_gf_repo"
  image_tag_mutability = "MUTABLE"

  encryption_configuration {
    encryption_type = "KMS"
  }

  image_scanning_configuration {
    scan_on_push = true
  }
}

data "aws_ecr_authorization_token" "aws_token"{
  registry_id = aws_ecr_repository.tap_gf_repo.registry_id
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
  registry_auth {
    address = data.aws_ecr_authorization_token.aws_token.proxy_endpoint
    username = data.aws_ecr_authorization_token.aws_token.user_name
    password = data.aws_ecr_authorization_token.aws_token.password

  }
}

resource "docker_registry_image" "tap_gf_connection_app" {
  name = "${aws_ecr_repository.tap_gf_repo.repository_url}:latest"
  build {
    context = "${path.cwd}/app"
    dockerfile = "Dockerfile"
  }
}

data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_ecr_repository_policy" "tap_gf_ecr_policy" {
  repository = aws_ecr_repository.tap_gf_repo.name
  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "AllowPushPull",
            "Effect": "Allow",
            "Principal": {
              "AWS" : [
                "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"
                  ]
            },
            "Action": [
              "ecr:BatchGetImage",
              "ecr:BatchCheckLayerAvailability",
              "ecr:CompleteLayerUpload",
              "ecr:GetDownloadUrlForLayer",
              "ecr:InitiateLayerUpload",
              "ecr:PutImage",
              "ecr:UploadLayerPart"
            ]
        }
    ]
}
EOF
}

#VPC task:

#Virtual private cloud creation:

resource "aws_vpc" "tap_gf_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "tap_gf_vpc"
  }
}

#Subnets creation:

resource "aws_subnet" "tap_gf_public_sns" {
  for_each = {
    subnet_1 = {
      name              = "tap_gf_public_sn_1",
      cidr_block        = "10.0.1.0/24",
      availability_zone = "eu-central-1a"
    },
    subnet_2 = {
      name              = "tap_gf_public_sn_2",
      cidr_block        = "10.0.2.0/24",
      availability_zone = "eu-central-1b"
    },
    subnet_3 = {
      name              = "tap_gf_public_sn_3",
      cidr_block        = "10.0.3.0/24",
      availability_zone = "eu-central-1c"
    }
  }
  vpc_id                  = aws_vpc.tap_gf_vpc.id
  cidr_block              = each.value["cidr_block"]
  availability_zone       = each.value["availability_zone"]
  map_public_ip_on_launch = true
  tags = {
    Name = each.value["name"]
    AZ = each.value["availability_zone"]
  }
}

resource "aws_subnet" "tap_gf_private_sns" {
  for_each = {
    subnet_1 = {
      name              = "tap_gf_private_sn_1",
      cidr_block        = "10.0.4.0/24",
      availability_zone = "eu-central-1a"
    },
    subnet_2 = {
      name              = "tap_gf_private_sn_2",
      cidr_block        = "10.0.5.0/24",
      availability_zone = "eu-central-1b"
    },
    subnet_3 = {
      name              = "tap_gf_private_sn_3",
      cidr_block        = "10.0.6.0/24",
      availability_zone = "eu-central-1c"
    }
  }
  vpc_id                  = aws_vpc.tap_gf_vpc.id
  cidr_block              = each.value["cidr_block"]
  availability_zone       = each.value["availability_zone"]
  map_public_ip_on_launch = true
  tags = {
    Name = each.value["name"]
    AZ = each.value["availability_zone"]
  }
}

resource "aws_subnet" "tap_gf_db_sns" {
  for_each = {
    subnet_1 = {
      name              = "tap_gf_db_sn_1",
      cidr_block        = "10.0.7.0/24",
      availability_zone = "eu-central-1a"
    },
    subnet_2 = {
      name              = "tap_gf_db_sn_2",
      cidr_block        = "10.0.8.0/24",
      availability_zone = "eu-central-1b"
    },
    subnet_3 = {
      name              = "tap_gf_db_sn_3",
      cidr_block        = "10.0.9.0/24",
      availability_zone = "eu-central-1c"
    }
  }
  vpc_id                  = aws_vpc.tap_gf_vpc.id
  cidr_block              = each.value["cidr_block"]
  availability_zone       = each.value["availability_zone"]
  map_public_ip_on_launch = true
  tags = {
    Name = each.value["name"]
    AZ = each.value["availability_zone"]
  }
}

#Internet gateway creation:
resource "aws_internet_gateway" "tap_gf_igw" {
  vpc_id = aws_vpc.tap_gf_vpc.id
  tags = {
    Name = "tap_gf_igw"
  }
}

#Elastic IP for network address translation:
resource "aws_eip" "tap_gf_eip" {
  vpc = true
  tags = {
    Name = "tap_gf_nat_eip"
  }
}

#Network address translation:

resource "aws_nat_gateway" "tap_gf_nat" {
  allocation_id = aws_eip.tap_gf_eip.id
  subnet_id     = aws_subnet.tap_gf_public_sns["subnet_1"].id
  tags = {
    Name = "tap_gf_nat"
  }
}

#SG, ROUTES and ROUTE TABLES !!!

#Secrets manager task

resource "aws_secretsmanager_secret" "tap_gf_secrets_rds" {
  name = "tap_gf_secrets_rds"
}

resource "aws_secretsmanager_secret_version" "tap_gf_sv" {
  secret_id     = aws_secretsmanager_secret.tap_gf_secrets_rds.id
  secret_string = jsonencode(var.creds)
}

data aws_secretsmanager_secret "db"{
  arn = aws_secretsmanager_secret.tap_gf_secrets_rds.arn
}

data aws_secretsmanager_secret_version "creds"{
  secret_id = aws_secretsmanager_secret.tap_gf_secrets_rds.arn
}

locals {
  creds = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string)
}

#DB task

resource "aws_security_group" "tap_gf_rds_sg" {
  name        = "tap_gf_rds_sg"
  description = "rds_sg"
  vpc_id      = aws_vpc.tap_gf_vpc.id
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "tap_gf_rds_sg"
  }
}

resource "aws_db_subnet_group" "tap_gf_sng" {
  name = "tap_gf_sng"
  subnet_ids = [aws_subnet.tap_gf_db_sns["subnet_1"].id,aws_subnet.tap_gf_db_sns["subnet_2"].id, aws_subnet.tap_gf_db_sns["subnet_3"].id]
}

resource "aws_db_instance" "tap_gf_rds_instance" {
  allocated_storage    = 10
  engine               = "postgres"
  engine_version       = "13"
  instance_class       = "db.t3.micro"
  name                 = "gf_db"
  username             = local.creds.username
  password             = local.creds.password
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.tap_gf_sng.id
  vpc_security_group_ids = [aws_security_group.tap_gf_rds_sg.id]
  tags = {
    Name = "tap_georgif_rds_instance"
  }
}