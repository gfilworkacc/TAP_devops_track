## Terraform day 3 tasks:

### Task1:	Create a simple flask hello world style python app, and create a Dockerfile from it.

Flask application and docker file content:

```bash
# Importing flask module in the project is mandatory
# An object of Flask class is our WSGI application.
from flask import Flask

# Flask constructor takes the name of
# current module (__name__) as argument.
app = Flask(__name__)

# The route() function of the Flask class is a decorator,
# which tells the application which URL should call
# the associated function.
@app.route('/')
# ‘/’ URL is bound with hello_world() function.
def hello_world():
    return 'Hello :)'

# main driver function
if __name__ == '__main__':

	# run() method of Flask class runs the application
	# on the local development server.
	app.run()
```

```bash
#Do not forget architecture issue.
FROM --platform=linux/amd64 python:alpine

ENV FLASK_APP flask_app.py

WORKDIR /app

COPY flask_app.py requirements.txt ./

RUN pip3 install -r requirements.txt

EXPOSE 5000

CMD ["flask", "run", "--host=0.0.0.0"]
```

### Task2	Create an AWS ECR where you can store Docker images.

```bash
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

```

### Providers:

```bash
#-------------
# PIN VERSIONS
#-------------
terraform {
  # Terraform version
  required_version = ">=1.1.0"

  # Provider versions
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
    time = {
      source = "hashicorp/time"
      version = "0.7.2"
    }
    docker = {
      source = "kreuzwerker/docker"
      version = "2.16.0"
    }
  }
}
```

### Task3	Use time provider and formatdate() to create a YYYYMMDD format tag for the image.

```bash
resource "time_static" "docker_image_time_stamp" {}

locals {
  current_date = formatdate("YYYYMMDD",time_static.docker_image_time_stamp.rfc3339)
}

resource "docker_registry_image" "tap_gf_flask_image" {
  name = "${aws_ecr_repository.tap_gf_repo.repository_url}:${local.current_date}"
  build {
    context = path.cwd
    dockerfile = "Dockerfile"
  }
}

```

### Task4	Use docker provider to build, and push the image to the ECR.

```bash
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
```

### Task5	Create a policy, that allow to push and pull from the created ECR.

```bash
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
```
