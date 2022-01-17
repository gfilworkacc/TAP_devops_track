## AWS lab 1 task:

```bash 
TAP_NAME: TAP_<attendee name>

Create 2 custom IAM policies:
named TAP_NAME_S3_read that provides all read-only S3 permissions but deny all actions to VPC
named TAP_NAME_VPC_read that provides all read-only VPC permissions but deny all actions to S3  


Create a role name TAP_NAME_VPC_read_Role and attach the policy TAP_NAME_VPC_read;

Create an EC2 instance with AmazonLinux OS and 1 CPU and 1 GB of RAM with the following tags:
Department: DevOps
Name: TAP_NAME
Environment: test

Update condition for the IAM policy TAP_NAME_VPC_read only effective with the EC2 with tag “Name”: “TAP_NAME”
Attach the role TAP_NAME_VPC_read_Role to the EC2


Connect SSH to the EC2, use aws cli to: 
List all available VPCs
list all s3 buckets by the role TAP_NAME_S3_read
``` 

## Configuration files and execution per step:

### S3 read policy file content:

```bash
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:List*",
                "s3-object-lambda:Get*",
                "s3-object-lambda:List*"
            ],
            "Resource": "*"
        }
    ]
}
```

```bash
aws iam create-policy --policy-name TAP_georgif_S3_read --policy-document file://read_oly_s3_pol.json
```
### VPC read policy file content:

```bash
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeAccountAttributes",
                "ec2:DescribeAddresses",
                "ec2:DescribeCarrierGateways",
                "ec2:DescribeClassicLinkInstances",
                "ec2:DescribeCustomerGateways",
                "ec2:DescribeDhcpOptions",
                "ec2:DescribeEgressOnlyInternetGateways",
                "ec2:DescribeFlowLogs",
                "ec2:DescribeInternetGateways",
                "ec2:DescribeLocalGatewayRouteTables",
                "ec2:DescribeLocalGatewayRouteTableVpcAssociations",
                "ec2:DescribeMovingAddresses",
                "ec2:DescribeNatGateways",
                "ec2:DescribeNetworkAcls",
                "ec2:DescribeNetworkInterfaceAttribute",
                "ec2:DescribeNetworkInterfacePermissions",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DescribePrefixLists",
                "ec2:DescribeRouteTables",
                "ec2:DescribeSecurityGroupReferences",
                "ec2:DescribeSecurityGroupRules",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeStaleSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeTags",
                "ec2:DescribeVpcAttribute",
                "ec2:DescribeVpcClassicLink",
                "ec2:DescribeVpcClassicLinkDnsSupport",
                "ec2:DescribeVpcEndpoints",
                "ec2:DescribeVpcEndpointConnectionNotifications",
                "ec2:DescribeVpcEndpointConnections",
                "ec2:DescribeVpcEndpointServiceConfigurations",
                "ec2:DescribeVpcEndpointServicePermissions",
                "ec2:DescribeVpcEndpointServices",
                "ec2:DescribeVpcPeeringConnections",
                "ec2:DescribeVpcs",
                "ec2:DescribeVpnConnections",
                "ec2:DescribeVpnGateways"
            ],
            "Resource": "*"
        }
    ]
}
```

```bash
aws iam create-policy --policy-name TAP_georgif_VPC_read --policy-document file://read_only_vpc_pol.json
```

### Role policy file content:

```bash
{

  "Version": "2012-10-17",

  "Statement": {
    "Effect": "Allow",
    "Principal": {
      "Service": "ec2.amazonaws.com"
    },
    "Action": "sts:AssumeRole"
  }
}
```

```bash
aws iam create-role --assume-role-policy-document file://role_pol.json --role-name TAP_georgif_VPC_read_Role

aws iam attach-role-policy --role-name TAP_georgif_VPC_read_Role --policy-arn arn:aws:iam::900990357819:policy/TAP_georgif_VPC_read
```

### EC2 instance was created via AWS management console, instance details:

```bash
aws ec2 describe-instances --region eu-central-1
```

```bash
{
    "Reservations": [
        {
            "Groups": [],
            "Instances": [
                {
                    "AmiLaunchIndex": 0,
                    "ImageId": "ami-05cafdf7c9f772ad2",
                    "InstanceId": "i-0354ed13af70e6c13",
                    "InstanceType": "t2.micro",
                    "KeyName": "TAP_georgif",
                    "LaunchTime": "2022-01-17T14:18:06+00:00",
                    "Monitoring": {
                        "State": "disabled"
                    },
                    "Placement": {
                        "AvailabilityZone": "eu-central-1a",
                        "GroupName": "",
                        "Tenancy": "default"
                    },
                    "PrivateDnsName": "ip-172-31-16-99.eu-central-1.compute.internal",
                    "PrivateIpAddress": "172.31.16.99",
                    "ProductCodes": [],
                    "PublicDnsName": "ec2-3-120-30-174.eu-central-1.compute.amazonaws.com",
                    "PublicIpAddress": "3.120.30.174",
                    "State": {
                        "Code": 16,
                        "Name": "running"
                    },
                    "StateTransitionReason": "",
                    "SubnetId": "subnet-0f5550982c861d958",
                    "VpcId": "vpc-04fafae192bae8e5f",
                    "Architecture": "x86_64",
                    "BlockDeviceMappings": [
                        {
                            "DeviceName": "/dev/xvda",
                            "Ebs": {
                                "AttachTime": "2022-01-17T14:18:07+00:00",
                                "DeleteOnTermination": true,
                                "Status": "attached",
                                "VolumeId": "vol-0d76baa1ad80eb94b"
                            }
                        }
                    ],
                    "ClientToken": "",
                    "EbsOptimized": false,
                    "EnaSupport": true,
                    "Hypervisor": "xen",
                    "IamInstanceProfile": {
                        "Arn": "arn:aws:iam::900990357819:instance-profile/TAP_georgif_instance_profile",
                        "Id": "AIPA5DRZV2E52WHOLUEEY"
                    },
                    "NetworkInterfaces": [
                        {
                            "Association": {
                                "IpOwnerId": "amazon",
                                "PublicDnsName": "ec2-3-120-30-174.eu-central-1.compute.amazonaws.com",
                                "PublicIp": "3.120.30.174"
                            },
                            "Attachment": {
                                "AttachTime": "2022-01-17T14:18:06+00:00",
                                "AttachmentId": "eni-attach-0db9d4bd26cdcee8a",
                                "DeleteOnTermination": true,
                                "DeviceIndex": 0,
                                "Status": "attached",
                                "NetworkCardIndex": 0
                            },
                            "Description": "",
                            "Groups": [
                                {
                                    "GroupName": "launch-wizard-1",
                                    "GroupId": "sg-098e7b7b551fcb50d"
                                }
                            ],
                            "Ipv6Addresses": [],
                            "MacAddress": "02:c0:d3:b9:3d:fa",
                            "NetworkInterfaceId": "eni-086dd3fbe6779812b",
                            "OwnerId": "900990357819",
                            "PrivateDnsName": "ip-172-31-16-99.eu-central-1.compute.internal",
                            "PrivateIpAddress": "172.31.16.99",
                            "PrivateIpAddresses": [
                                {
                                    "Association": {
                                        "IpOwnerId": "amazon",
                                        "PublicDnsName": "ec2-3-120-30-174.eu-central-1.compute.amazonaws.com",
                                        "PublicIp": "3.120.30.174"
                                    },
                                    "Primary": true,
                                    "PrivateDnsName": "ip-172-31-16-99.eu-central-1.compute.internal",
                                    "PrivateIpAddress": "172.31.16.99"
                                }
                            ],
                            "SourceDestCheck": true,
                            "Status": "in-use",
                            "SubnetId": "subnet-0f5550982c861d958",
                            "VpcId": "vpc-04fafae192bae8e5f",
                            "InterfaceType": "interface"
                        }
                    ],
                    "RootDeviceName": "/dev/xvda",
                    "RootDeviceType": "ebs",
                    "SecurityGroups": [
                        {
                            "GroupName": "launch-wizard-1",
                            "GroupId": "sg-098e7b7b551fcb50d"
                        }
                    ],
                    "SourceDestCheck": true,
                    "Tags": [
                        {
                            "Key": "Name",
                            "Value": "TAP_georgif"
                        },
                        {
                            "Key": "Environment",
                            "Value": "test"
                        },
                        {
                            "Key": "Department",
                            "Value": "DevOps"
                        }
                    ],
                    "VirtualizationType": "hvm",
                    "CpuOptions": {
                        "CoreCount": 1,
                        "ThreadsPerCore": 1
                    },
                    "CapacityReservationSpecification": {
                        "CapacityReservationPreference": "open"
                    },
                    "HibernationOptions": {
                        "Configured": false
                    },
                    "MetadataOptions": {
                        "State": "applied",
                        "HttpTokens": "optional",
                        "HttpPutResponseHopLimit": 1,
                        "HttpEndpoint": "enabled",
                        "HttpProtocolIpv6": "disabled",
                        "InstanceMetadataTags": "disabled"
                    },
                    "EnclaveOptions": {
                        "Enabled": false
                    },
                    "PlatformDetails": "Linux/UNIX",
                    "UsageOperation": "RunInstances",
                    "UsageOperationUpdateTime": "2022-01-17T14:18:06+00:00",
                    "PrivateDnsNameOptions": {
                        "HostnameType": "ip-name",
                        "EnableResourceNameDnsARecord": true,
                        "EnableResourceNameDnsAAAARecord": false
                    }
                }
            ],
            "OwnerId": "900990357819",
            "ReservationId": "r-0ef856f039f08ec4f"
        },
```

### Update IAM policy, tag it and attach it to EC2 instance:

```bash
aws iam tag-policy --policy-arn arn:aws:iam::900990357819:policy/TAP_georgif_VPC_read --tags {"Key": "Name", "Value": "TAP_georgif"}
aws iam create-instance-profile --instance-profile-name TAP_georgif_instance_profile
aws iam add-role-to-instance-profile --instance-profile-name TAP_georgif_instance_profile --role-name TAP_georgif_VPC_read_Role
aws ec2 associate-iam-instance-profile --iam-instance-profile Name=TAP_georgif_instance_profile --instance-id i-0354ed13af70e6c13 --region eu-central-1
```

### Connect to the instance and list VPCs and s3 buckets:

```bash
aws ec2 describe-vpcs --region eu-central-1
```

```bash
{
    "Vpcs": [
        {
            "VpcId": "vpc-04fafae192bae8e5f", 
            "InstanceTenancy": "default", 
            "CidrBlockAssociationSet": [
                {
                    "AssociationId": "vpc-cidr-assoc-00875acea98a8d29f", 
                    "CidrBlock": "172.31.0.0/16", 
                    "CidrBlockState": {
                        "State": "associated"
                    }
                }
            ], 
            "State": "available", 
            "DhcpOptionsId": "dopt-0b4944a054c0da888", 
            "OwnerId": "900990357819", 
            "CidrBlock": "172.31.0.0/16", 
            "IsDefault": true
        }
    ]
}
```

```bash 
aws s3 ls
```

```bash 
An error occurred (AccessDenied) when calling the ListBuckets operation: Access Denied
```
