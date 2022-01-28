## AWS task day 9:

### Cluster and repository creation:

```bash
aws ecs create-cluster --cluster-name tap-georgif-cluster --tags key=Name,value=gf-cluster

aws ecr create-repository --repository-name tap-georgif/python-app --image-scanning-configuration scanOnPush=true --encryption-configuration {"encryptionType":"KMS"} --tags Key=Name,Value=tap-georgif-repo
```
### Building and pushing the image:

Files content:

app.py

```python
#!/usr/bin/env python3
from psycopg2 import connect
import os
import json
import time

os.mkdir('/script/state')

def state_to_file():
    try:
        conn = connect (
        dbname = "",
        user = os.environ.get('DATABASE_USER'),
        host = os.environ.get('DATABASE_HOST'),
        password = os.environ.get('DATABASE_PASS')
        )

        dsm_param = conn.get_dsn_parameters()
        info = json.dumps(dsm_param, indent=4)

        with open('state/db_connection_detail', 'w') as f:
            f.write(info)

    except Exception as err:
        print ("\npsycopg2 connection error:", err)

    time.sleep(30)
    state_to_file()

state_to_file()
```

requirements.txt

```bash
psycopg2-binary
```

Dockerfile

```bash
FROM --platform=linux/amd64 python:alpine

WORKDIR /script

COPY requirements.txt requirements.txt

RUN pip3 install -r requirements.txt

COPY . .

EXPOSE 80

CMD [ "/bin/sh", "-c", "(python3 app.py &) && python3 -m http.server --directory state 80" ]
```

Building image and pushing to AWS repository:

```bash
docker build -t py-app .

aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin AWS_ID.dkr.ecr.eu-central-1.amazonaws.com

docker tag df54567d45f4 AWS_ID.dkr.ecr.eu-central-1.amazonaws.com/tap-georgif/python-app:latest

docker push AWS_ID.dkr.ecr.eu-central-1.amazonaws.com/tap-georgif/python-app:latest
```

### Creating ECS policies and roles for execution and to get secrets:

ecs-tasks-trust-policy.json content:

```bash
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

```bash
aws iam create-role --role-name tap-georgif-ecsTaskExecutionRole --assume-role-policy-document file://ecs-tasks-trust-policy.json

aws iam attach-role-policy --role-name tap-georgif-ecsTaskExecutionRole --policy-arn arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy
```

ecs-secrets.json

```bash
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetSecretValue",
      ],
      "Resource": [
        "arn:aws:secretsmanager:AWS_REGION:AWS_ID:secret:tap-georgif-postgresql-db-rUdJDt",
      ]
    }
  ]
}
```

```bash
aws iam create-policy --policy-name ecs-secrets --policy-document file://ecs-secrets.json

aws iam attach-role-policy --role-name tap-georgif-ecsTaskExecutionRole --policy-arn arn:aws:iam::AWS_ID:policy/ecs-secrets
```

### Task definition content and registration:

```bash
{
    "family": "py-app",
    "cpu": "256",
    "memory": "512",
    "executionRoleArn": "arn:aws:iam::AWS_ID:role/tap-georgif-ecsTaskExecutionRole",
    "runtimePlatform": {
        "operatingSystemFamily": "LINUX"
    },
    "networkMode": "awsvpc",
    "containerDefinitions": [
        {
            "name": "py-app",
            "image": "AWS_ID.dkr.ecr.eu-central-1.amazonaws.com/tap-georgif/python-app:latest",
            "portMappings": [
                {
                    "containerPort": 80, 
                    "hostPort": 80, 
                    "protocol": "tcp"
                }
            ],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "tap-georgif-logs",
                    "awslogs-region": "eu-central-1",
                    "awslogs-stream-prefix": "ecs-logs"
                }
            },
            "environment": [
                {
                    "name": "DATABASE_HOST",
                    "value": "tap-georgif-postgresql-db.cohp5mdd9ipi.eu-central-1.rds.amazonaws.com"
                }
            ],
            "secrets": [
                {
                    "name": "DATABASE_USER",
                        "valueFrom": "arn:aws:secretsmanager:eu-central-1:AWS_ID:secret:tap-georgif-postgresql-db-rUdJDt:username::"
                },
                {
                    "name": "DATABASE_PASS",
                    "valueFrom": "arn:aws:secretsmanager:eu-central-1:AWS_ID:secret:tap-georgif-postgresql-db-rUdJDt:password::"
                }
            ],
            "essential": true
        }
    ],
    "requiresCompatibilities": [
        "FARGATE"
    ]
}
```

```bash
aws ecs register-task-definition --cli-input-json file://python-app-task.json
```

### Target group and load balancer creation:

```bash
aws elbv2 create-target-group --name tap-georgif-ecs --protocol HTTP --port 80 --target-type ip --vpc-id vpc-0d1b34296dd94edbf

aws elbv2 create-load-balancer --name tap-georgif-lb --subnets subnet-0002b5202006f61d4 subnet-0e70acf7e3f1bce74 subnet-084c3d8e2d9b78f41 --security-groups sg-0b86408488563ab91 --scheme internet-facing --type application --ip-address-type ipv4

aws elbv2 create-listener --load-balancer-arn arn:aws:elasticloadbalancing:eu-central-1:AWS_ID:loadbalancer/app/tap-georgif-lb/33d055c6b4d39b5d --protocol HTTP --port 80 --default-actions Type=forward,TargetGroupArn=arn:aws:elasticloadbalancing:eu-central-1:AWS_ID:targetgroup/tap-georgif-ecs/29f51309f308ed43
```

### Service creation:

```bash
aws ecs create-service --cluster tap-georgif-cluster --service-name tap-georgif-service --task-definition py-app:1 --desired-count 1 --launch-type FARGATE --network-configuration awsvpcConfiguration={subnets=[subnet-02b627d81037a31b7,subnet-04cf7e3994967e44b,subnet-06c333981ee273e6e],securityGroups=[sg-0b86408488563ab91]} --load-balancers targetGroupArn=arn:aws:elasticloadbalancing:eu-central-1:AWS_ID:targetgroup/tap-georgif-ecs/29f51309f308ed43,containerName=py-app,containerPort=80
```

### Result:

```bash
curl tap-georgif-lb-1395130299.eu-central-1.elb.amazonaws.com/db_connection_detail
```

```bash
{
    "user": "postgres",
    "dbname": "postgres",
    "host": "tap-georgif-postgresql-db.cohp5mdd9ipi.eu-central-1.rds.amazonaws.com",
    "port": "5432",
    "tty": "",
    "options": "",
    "sslmode": "prefer",
    "sslcompression": "0",
    "gssencmode": "disable",
    "krbsrvname": "postgres",
    "target_session_attrs": "any"
}
```
