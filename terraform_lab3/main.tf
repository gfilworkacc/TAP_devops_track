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

resource "time_static" "docker_image_time_stamp" {}

locals {
  current_date = formatdate("YYYYMMDD",time_static.docker_image_time_stamp.rfc3339)
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

resource "docker_registry_image" "tap_gf_flask_image" {
  name = "${aws_ecr_repository.tap_gf_repo.repository_url}:${local.current_date}"
  build {
    context = path.cwd
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