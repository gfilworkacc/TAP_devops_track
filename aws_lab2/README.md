## AWS lab 2:

### Task 1:

VPC creation :

```bash
aws ec2 create-vpc --cidr-block 10.0.0.0/16 --query Vpc.VpcId --output text --region eu-central-1
```

```bash
vpc-0d1b34296dd94edbf
```

Public network creation :

```bash
aws ec2 create-subnet --vpc-id vpc-0d1b34296dd94edbf --cidr-block 10.0.2.0/24 --region eu-central-1 --availability-zone eu-central-1c --tag-specifications ResourceType=subnet,Tags=[{Key=Name,Value=public_subnet_eu-central-1c}]
```

```bash
{
    "Subnet": {
        "AvailabilityZone": "eu-central-1a",
        "AvailabilityZoneId": "euc1-az2",
        "AvailableIpAddressCount": 251,
        "CidrBlock": "10.0.0.0/24",
        "DefaultForAz": false,
        "MapPublicIpOnLaunch": false,
        "State": "available",
        "SubnetId": "subnet-0002b5202006f61d4",
        "VpcId": "vpc-0d1b34296dd94edbf",
        "OwnerId": "900990357819",
        "AssignIpv6AddressOnCreation": false,
        "Ipv6CidrBlockAssociationSet": [],
        "Tags": [
            {
                "Key": "Name",
                "Value": "public_subnet_eu-central-1a"
            }
        ],
        "SubnetArn": "arn:aws:ec2:eu-central-1:900990357819:subnet/subnet-0002b5202006f61d4",
        "EnableDns64": false,
        "Ipv6Native": false,
        "PrivateDnsNameOptionsOnLaunch": {
            "HostnameType": "ip-name",
            "EnableResourceNameDnsARecord": false,
            "EnableResourceNameDnsAAAARecord": false
        }
    }
}
{
    "Subnet": {
        "AvailabilityZone": "eu-central-1b",
        "AvailabilityZoneId": "euc1-az3",
        "AvailableIpAddressCount": 251,
        "CidrBlock": "10.0.1.0/24",
        "DefaultForAz": false,
        "MapPublicIpOnLaunch": false,
        "State": "available",
        "SubnetId": "subnet-0e70acf7e3f1bce74",
        "VpcId": "vpc-0d1b34296dd94edbf",
        "OwnerId": "900990357819",
        "AssignIpv6AddressOnCreation": false,
        "Ipv6CidrBlockAssociationSet": [],
        "Tags": [
            {
                "Key": "Name",
                "Value": "public_subnet_eu-central-1b"
            }
        ],
        "SubnetArn": "arn:aws:ec2:eu-central-1:900990357819:subnet/subnet-0e70acf7e3f1bce74",
        "EnableDns64": false,
        "Ipv6Native": false,
        "PrivateDnsNameOptionsOnLaunch": {
            "HostnameType": "ip-name",
            "EnableResourceNameDnsARecord": false,
            "EnableResourceNameDnsAAAARecord": false
        }
    }
}
{
    "Subnet": {
        "AvailabilityZone": "eu-central-1c",
        "AvailabilityZoneId": "euc1-az1",
        "AvailableIpAddressCount": 251,
        "CidrBlock": "10.0.2.0/24",
        "DefaultForAz": false,
        "MapPublicIpOnLaunch": false,
        "State": "available",
        "SubnetId": "subnet-084c3d8e2d9b78f41",
        "VpcId": "vpc-0d1b34296dd94edbf",
        "OwnerId": "900990357819",
        "AssignIpv6AddressOnCreation": false,
        "Ipv6CidrBlockAssociationSet": [],
        "Tags": [
            {
                "Key": "Name",
                "Value": "public_subnet_eu-central-1c"
            }
        ],
        "SubnetArn": "arn:aws:ec2:eu-central-1:900990357819:subnet/subnet-084c3d8e2d9b78f41",
        "EnableDns64": false,
        "Ipv6Native": false,
        "PrivateDnsNameOptionsOnLaunch": {
            "HostnameType": "ip-name",
            "EnableResourceNameDnsARecord": false,
            "EnableResourceNameDnsAAAARecord": false
        }
    }
}
```

Internal gateway creation and attach to VPC:

```bash
aws ec2 create-internet-gateway --query InternetGateway.InternetGatewayId --output text --region eu-central-1
```

```bash
igw-01aedfa80d5e9c4de

```bash
aws ec2 attach-internet-gateway --vpc-id vpc-0d1b34296dd94edbf --internet-gateway-id igw-01aedfa80d5e9c4de --region eu-central-1
```

Route table creation:

```bash
aws ec2 create-route-table --vpc-id vpc-0d1b34296dd94edbf --query RouteTable.RouteTableId --output text --region eu-central-1
rtb-065f7831ab78fe2c6
```

Create route and attach to internal gateway:

```bash
aws ec2 create-route --route-table-id rtb-065f7831ab78fe2c6 --destination-cidr-block 0.0.0.0/0 --gateway-id igw-01aedfa80d5e9c4de --region eu-central-1
```

Subnet to route table:

```bash
aws ec2 associate-route-table --subnet-id subnet-0002b5202006f61d4 --route-table-id rtb-065f7831ab78fe2c6 --region eu-central-1
aws ec2 associate-route-table --subnet-id subnet-0e70acf7e3f1bce74 --route-table-id rtb-065f7831ab78fe2c6 --region eu-central-1
aws ec2 associate-route-table --subnet-id subnet-084c3d8e2d9b78f41 --route-table-id rtb-065f7831ab78fe2c6 --region eu-central-1
```

Private networks creation:

```bash
aws ec2 create-subnet --vpc-id vpc-0d1b34296dd94edbf --cidr-block 10.0.3.0/24 --region eu-central-1 --availability-zone eu-central-1a --tag-specifications ResourceType=subnet,Tags=[{Key=Name,Value=private_subnet_eu-central-1a}]
```

```bash
{
    "Subnet": {
        "AvailabilityZone": "eu-central-1a",
        "AvailabilityZoneId": "euc1-az2",
        "AvailableIpAddressCount": 251,
        "CidrBlock": "10.0.3.0/24",
        "DefaultForAz": false,
        "MapPublicIpOnLaunch": false,
        "State": "available",
        "SubnetId": "subnet-02b627d81037a31b7",
        "VpcId": "vpc-0d1b34296dd94edbf",
        "OwnerId": "900990357819",
        "AssignIpv6AddressOnCreation": false,
        "Ipv6CidrBlockAssociationSet": [],
        "Tags": [
            {
                "Key": "Name",
                "Value": "private_subnet_eu-central-1a"
            }
        ],
        "SubnetArn": "arn:aws:ec2:eu-central-1:900990357819:subnet/subnet-02b627d81037a31b7",
        "EnableDns64": false,
        "Ipv6Native": false,
        "PrivateDnsNameOptionsOnLaunch": {
            "HostnameType": "ip-name",
            "EnableResourceNameDnsARecord": false,
            "EnableResourceNameDnsAAAARecord": false
        }
    }
}
```

```bash
aws ec2 create-subnet --vpc-id vpc-0d1b34296dd94edbf --cidr-block 10.0.4.0/24 --region eu-central-1 --availability-zone eu-central-1b --tag-specifications ResourceType=subnet,Tags=[{Key=Name,Value=private_subnet_eu-central-1b}]

{
    "Subnet": {
        "AvailabilityZone": "eu-central-1b",
        "AvailabilityZoneId": "euc1-az3",
        "AvailableIpAddressCount": 251,
        "CidrBlock": "10.0.4.0/24",
        "DefaultForAz": false,
        "MapPublicIpOnLaunch": false,
        "State": "available",
        "SubnetId": "subnet-04cf7e3994967e44b",
        "VpcId": "vpc-0d1b34296dd94edbf",
        "OwnerId": "900990357819",
        "AssignIpv6AddressOnCreation": false,
        "Ipv6CidrBlockAssociationSet": [],
        "Tags": [
            {
                "Key": "Name",
                "Value": "private_subnet_eu-central-1b"
            }
        ],
        "SubnetArn": "arn:aws:ec2:eu-central-1:900990357819:subnet/subnet-04cf7e3994967e44b",
        "EnableDns64": false,
        "Ipv6Native": false,
        "PrivateDnsNameOptionsOnLaunch": {
            "HostnameType": "ip-name",
            "EnableResourceNameDnsARecord": false,
            "EnableResourceNameDnsAAAARecord": false
        }
    }
}
```

```bash
aws ec2 create-subnet --vpc-id vpc-0d1b34296dd94edbf --cidr-block 10.0.5.0/24 --region eu-central-1 --availability-zone eu-central-1c --tag-specifications ResourceType=subnet,Tags=[{Key=Name,Value=private_subnet_eu-central-1c}]
```

```bash
{
    "Subnet": {
        "AvailabilityZone": "eu-central-1c",
        "AvailabilityZoneId": "euc1-az1",
        "AvailableIpAddressCount": 251,
        "CidrBlock": "10.0.5.0/24",
        "DefaultForAz": false,
        "MapPublicIpOnLaunch": false,
        "State": "available",
        "SubnetId": "subnet-06c333981ee273e6e",
        "VpcId": "vpc-0d1b34296dd94edbf",
        "OwnerId": "900990357819",
        "AssignIpv6AddressOnCreation": false,
        "Ipv6CidrBlockAssociationSet": [],
        "Tags": [
            {
                "Key": "Name",
                "Value": "private_subnet_eu-central-1c"
            }
        ],
        "SubnetArn": "arn:aws:ec2:eu-central-1:900990357819:subnet/subnet-06c333981ee273e6e",
        "EnableDns64": false,
        "Ipv6Native": false,
        "PrivateDnsNameOptionsOnLaunch": {
            "HostnameType": "ip-name",
            "EnableResourceNameDnsARecord": false,
            "EnableResourceNameDnsAAAARecord": false
        }
    }
}
```

Routing table for the private networks:

```bash
aws ec2 create-route-table --vpc-id vpc-0d1b34296dd94edbf --query RouteTable.RouteTableId --output text --region eu-central-1
```

```bash
rtb-0ec76c79c5d51276d
```

Allocate IP for the NAT:

```bash
aws_lab2 % aws ec2 allocate-address --region eu-central-1
```

```bash
{
    "PublicIp": "3.124.252.171",
    "AllocationId": "eipalloc-01871c4ed81c85fa1",
    "PublicIpv4Pool": "amazon",
    "NetworkBorderGroup": "eu-central-1",
    "Domain": "vpc"
}
```

Create the NAT:

```bash
aws ec2 create-nat-gateway --subnet-id subnet-0002b5202006f61d4 --allocation-id eipalloc-01871c4ed81c85fa1 --region eu-central-1
```

```bash
{
    "ClientToken": "95b62ace-2f9b-4042-a82f-b6c3994edb89",
    "NatGateway": {
        "CreateTime": "2022-01-18T14:40:18+00:00",
        "NatGatewayAddresses": [
            {
                "AllocationId": "eipalloc-01871c4ed81c85fa1"
            }
        ],
        "NatGatewayId": "nat-093256d5c8f1de11e",
        "State": "pending",
        "SubnetId": "subnet-0002b5202006f61d4",
        "VpcId": "vpc-0d1b34296dd94edbf",
        "ConnectivityType": "public"
    }
}
```

Create routing table and associate it to the private networks:

```bash
aws ec2 create-route --route-table-id rtb-0ec76c79c5d51276d --destination-cidr-block 0.0.0.0/0 --nat-gateway-id nat-093256d5c8f1de11e --region eu-central-1
```

```bash
aws ec2 associate-route-table --route-table-id rtb-0ec76c79c5d51276d --subnet-id subnet-06c333981ee273e6e --region eu-central-1
```

Private database network creation:

```bash
aws ec2 create-subnet --vpc-id vpc-0d1b34296dd94edbf --cidr-block 10.0.6.0/24 --region eu-central-1 --availability-zone eu-central-1a --tag-specifications ResourceType=subnet,Tags=[{Key=Name,Value=database_subnet_eu-central-1a}]
```

```bash
{
    "Subnet": {
        "AvailabilityZone": "eu-central-1a",
        "AvailabilityZoneId": "euc1-az2",
        "AvailableIpAddressCount": 251,
        "CidrBlock": "10.0.6.0/24",
        "DefaultForAz": false,
        "MapPublicIpOnLaunch": false,
        "State": "available",
        "SubnetId": "subnet-01bd9f82e5d282403",
        "VpcId": "vpc-0d1b34296dd94edbf",
        "OwnerId": "900990357819",
        "AssignIpv6AddressOnCreation": false,
        "Ipv6CidrBlockAssociationSet": [],
        "Tags": [
            {
                "Key": "Name",
                "Value": "database_subnet_eu-central-1a"
            }
        ],
        "SubnetArn": "arn:aws:ec2:eu-central-1:900990357819:subnet/subnet-01bd9f82e5d282403",
        "EnableDns64": false,
        "Ipv6Native": false,
        "PrivateDnsNameOptionsOnLaunch": {
            "HostnameType": "ip-name",
            "EnableResourceNameDnsARecord": false,
            "EnableResourceNameDnsAAAARecord": false
        }
    }
}

{
    "Subnet": {
        "AvailabilityZone": "eu-central-1b",
        "AvailabilityZoneId": "euc1-az3",
        "AvailableIpAddressCount": 251,
        "CidrBlock": "10.0.7.0/24",
        "DefaultForAz": false,
        "MapPublicIpOnLaunch": false,
        "State": "available",
        "SubnetId": "subnet-0c7d1613b4f033747",
        "VpcId": "vpc-0d1b34296dd94edbf",
        "OwnerId": "900990357819",
        "AssignIpv6AddressOnCreation": false,
        "Ipv6CidrBlockAssociationSet": [],
        "Tags": [
            {
                "Key": "Name",
                "Value": "database_subnet_eu-central-1b"
            }
        ],
        "SubnetArn": "arn:aws:ec2:eu-central-1:900990357819:subnet/subnet-0c7d1613b4f033747",
        "EnableDns64": false,
        "Ipv6Native": false,
        "PrivateDnsNameOptionsOnLaunch": {
            "HostnameType": "ip-name",
            "EnableResourceNameDnsARecord": false,
            "EnableResourceNameDnsAAAARecord": false
        }
    }
}
{
    "Subnet": {
        "AvailabilityZone": "eu-central-1c",
        "AvailabilityZoneId": "euc1-az1",
        "AvailableIpAddressCount": 251,
        "CidrBlock": "10.0.8.0/24",
        "DefaultForAz": false,
        "MapPublicIpOnLaunch": false,
        "State": "available",
        "SubnetId": "subnet-09860b577dca2884c",
        "VpcId": "vpc-0d1b34296dd94edbf",
        "OwnerId": "900990357819",
        "AssignIpv6AddressOnCreation": false,
        "Ipv6CidrBlockAssociationSet": [],
        "Tags": [
            {
                "Key": "Name",
                "Value": "database_subnet_eu-central-1c"
            }
        ],
        "SubnetArn": "arn:aws:ec2:eu-central-1:900990357819:subnet/subnet-09860b577dca2884c",
        "EnableDns64": false,
        "Ipv6Native": false,
        "PrivateDnsNameOptionsOnLaunch": {
            "HostnameType": "ip-name",
            "EnableResourceNameDnsARecord": false,
            "EnableResourceNameDnsAAAARecord": false
        }
    }
}
```

## Task 2:
Instance creation

```bash
aws ec2 describe-instances --instance-ids i-046051ccf7d98a34e --region eu-central-1
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
                    "InstanceId": "i-046051ccf7d98a34e",
                    "InstanceType": "t2.micro",
                    "KeyName": "TAP_georgif",
                    "LaunchTime": "2022-01-18T15:10:05+00:00",
                    "Monitoring": {
                        "State": "disabled"
                    },
                    "Placement": {
                        "AvailabilityZone": "eu-central-1c",
                        "GroupName": "",
                        "Tenancy": "default"
                    },
                    "PrivateDnsName": "ip-10-0-2-132.eu-central-1.compute.internal",
                    "PrivateIpAddress": "10.0.2.132",
                    "ProductCodes": [],
                    "PublicDnsName": "",
                    "PublicIpAddress": "3.68.118.2",
                    "State": {
                        "Code": 16,
                        "Name": "running"
                    },
                    "StateTransitionReason": "",
                    "SubnetId": "subnet-084c3d8e2d9b78f41",
                    "VpcId": "vpc-0d1b34296dd94edbf",
                    "Architecture": "x86_64",
                    "BlockDeviceMappings": [
                        {
                            "DeviceName": "/dev/xvda",
                            "Ebs": {
                                "AttachTime": "2022-01-18T15:10:06+00:00",
                                "DeleteOnTermination": true,
                                "Status": "attached",
                                "VolumeId": "vol-0796e1a574b0c96c1"
                            }
                        }
                    ],
                    "ClientToken": "",
                    "EbsOptimized": false,
                    "EnaSupport": true,
                    "Hypervisor": "xen",
                    "NetworkInterfaces": [
                        {
                            "Association": {
                                "IpOwnerId": "amazon",
                                "PublicDnsName": "",
                                "PublicIp": "3.68.118.2"
                            },
                            "Attachment": {
                                "AttachTime": "2022-01-18T15:10:05+00:00",
                                "AttachmentId": "eni-attach-04be3bc1f431cc54b",
                                "DeleteOnTermination": true,
                                "DeviceIndex": 0,
                                "Status": "attached",
                                "NetworkCardIndex": 0
                            },
                            "Description": "Primary network interface",
                            "Groups": [
                                {
                                    "GroupName": "launch-wizard-2",
                                    "GroupId": "sg-0be9d3ac2e10466cb"
                                }
                            ],
                            "Ipv6Addresses": [],
                            "MacAddress": "0a:0f:b8:3c:a6:30",
                            "NetworkInterfaceId": "eni-091928c4b6713690c",
                            "OwnerId": "900990357819",
                            "PrivateIpAddress": "10.0.2.132",
                            "PrivateIpAddresses": [
                                {
                                    "Association": {
                                        "IpOwnerId": "amazon",
                                        "PublicDnsName": "",
                                        "PublicIp": "3.68.118.2"
                                    },
                                    "Primary": true,
                                    "PrivateIpAddress": "10.0.2.132"
                                }
                            ],
                            "SourceDestCheck": true,
                            "Status": "in-use",
                            "SubnetId": "subnet-084c3d8e2d9b78f41",
                            "VpcId": "vpc-0d1b34296dd94edbf",
                            "InterfaceType": "interface"
                        }
                    ],
                    "RootDeviceName": "/dev/xvda",
                    "RootDeviceType": "ebs",
                    "SecurityGroups": [
                        {
                            "GroupName": "launch-wizard-2",
                            "GroupId": "sg-0be9d3ac2e10466cb"
                        }
                    ],
                    "SourceDestCheck": true,
                    "Tags": [
                        {
                            "Key": "Name",
                            "Value": "pi1"
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
                    "UsageOperationUpdateTime": "2022-01-18T15:10:05+00:00",
                    "PrivateDnsNameOptions": {
                        "HostnameType": "ip-name",
                        "EnableResourceNameDnsARecord": true,
                        "EnableResourceNameDnsAAAARecord": false
                    }
                }
            ],
            "OwnerId": "900990357819",
            "ReservationId": "r-0791a3660141980d6"
        }
    ]
}
```

```bash
aws ec2 describe-instances --instance-ids i-0f22821ed024141ae --region eu-central-1
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
                    "InstanceId": "i-0f22821ed024141ae",
                    "InstanceType": "t2.micro",
                    "KeyName": "TAP_georgif",
                    "LaunchTime": "2022-01-18T15:13:29+00:00",
                    "Monitoring": {
                        "State": "disabled"
                    },
                    "Placement": {
                        "AvailabilityZone": "eu-central-1a",
                        "GroupName": "",
                        "Tenancy": "default"
                    },
                    "PrivateDnsName": "ip-10-0-0-186.eu-central-1.compute.internal",
                    "PrivateIpAddress": "10.0.0.186",
                    "ProductCodes": [],
                    "PublicDnsName": "",
                    "PublicIpAddress": "3.120.174.3",
                    "State": {
                        "Code": 16,
                        "Name": "running"
                    },
                    "StateTransitionReason": "",
                    "SubnetId": "subnet-0002b5202006f61d4",
                    "VpcId": "vpc-0d1b34296dd94edbf",
                    "Architecture": "x86_64",
                    "BlockDeviceMappings": [
                        {
                            "DeviceName": "/dev/xvda",
                            "Ebs": {
                                "AttachTime": "2022-01-18T15:13:29+00:00",
                                "DeleteOnTermination": true,
                                "Status": "attached",
                                "VolumeId": "vol-0cee3b1f8679d8f6b"
                            }
                        }
                    ],
                    "ClientToken": "",
                    "EbsOptimized": false,
                    "EnaSupport": true,
                    "Hypervisor": "xen",
                    "NetworkInterfaces": [
                        {
                            "Association": {
                                "IpOwnerId": "amazon",
                                "PublicDnsName": "",
                                "PublicIp": "3.120.174.3"
                            },
                            "Attachment": {
                                "AttachTime": "2022-01-18T15:13:29+00:00",
                                "AttachmentId": "eni-attach-017f1f1343b5da7ed",
                                "DeleteOnTermination": true,
                                "DeviceIndex": 0,
                                "Status": "attached",
                                "NetworkCardIndex": 0
                            },
                            "Description": "Primary network interface",
                            "Groups": [
                                {
                                    "GroupName": "launch-wizard-3",
                                    "GroupId": "sg-0f7588abdbbb934f7"
                                }
                            ],
                            "Ipv6Addresses": [],
                            "MacAddress": "02:21:fe:12:ae:90",
                            "NetworkInterfaceId": "eni-04c127903d4d570ac",
                            "OwnerId": "900990357819",
                            "PrivateIpAddress": "10.0.0.186",
                            "PrivateIpAddresses": [
                                {
                                    "Association": {
                                        "IpOwnerId": "amazon",
                                        "PublicDnsName": "",
                                        "PublicIp": "3.120.174.3"
                                    },
                                    "Primary": true,
                                    "PrivateIpAddress": "10.0.0.186"
                                }
                            ],
                            "SourceDestCheck": true,
                            "Status": "in-use",
                            "SubnetId": "subnet-0002b5202006f61d4",
                            "VpcId": "vpc-0d1b34296dd94edbf",
                            "InterfaceType": "interface"
                        }
                    ],
                    "RootDeviceName": "/dev/xvda",
                    "RootDeviceType": "ebs",
                    "SecurityGroups": [
                        {
                            "GroupName": "launch-wizard-3",
                            "GroupId": "sg-0f7588abdbbb934f7"
                        }
                    ],
                    "SourceDestCheck": true,
                    "Tags": [
                        {
                            "Key": "Name",
                            "Value": "pi2"
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
                    "UsageOperationUpdateTime": "2022-01-18T15:13:29+00:00",
                    "PrivateDnsNameOptions": {
                        "HostnameType": "ip-name",
                        "EnableResourceNameDnsARecord": true,
                        "EnableResourceNameDnsAAAARecord": false
                    }
                }
            ],
            "OwnerId": "900990357819",
            "ReservationId": "r-04d01610ed8b054cc"
        }
    ]
}
```

```bash
ssh -i /Users/gf/Documents/TAP_georgif.pem ec2-user@52.59.244.161 ping -c 1 10.0.1.147
```

```bash
PING 10.0.1.147 (10.0.1.147) 56(84) bytes of data.
64 bytes from 10.0.1.147: icmp_seq=1 ttl=64 time=0.972 ms

--- 10.0.1.147 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.972/0.972/0.972/0.000 ms
```

```bash
ssh -i /Users/gf/Documents/TAP_georgif.pem ec2-user@35.159.26.190 ping -c 1 10.0.0.242
```

```bash
PING 10.0.0.242 (10.0.0.242) 56(84) bytes of data.
64 bytes from 10.0.0.242: icmp_seq=1 ttl=64 time=0.962 ms

--- 10.0.0.242 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.962/0.962/0.962/0.000 ms
```

## Task 3

```bash
aws ec2 describe-instances --instance-ids i-03e5f7062d36697c2 --region eu-central-1
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
                    "InstanceId": "i-03e5f7062d36697c2",
                    "InstanceType": "t2.micro",
                    "KeyName": "TAP_georgif",
                    "LaunchTime": "2022-01-18T16:02:33+00:00",
                    "Monitoring": {
                        "State": "disabled"
                    },
                    "Placement": {
                        "AvailabilityZone": "eu-central-1a",
                        "GroupName": "",
                        "Tenancy": "default"
                    },
                    "PrivateDnsName": "ip-10-0-3-184.eu-central-1.compute.internal",
                    "PrivateIpAddress": "10.0.3.184",
                    "ProductCodes": [],
                    "PublicDnsName": "",
                    "PublicIpAddress": "3.120.180.114",
                    "State": {
                        "Code": 16,
                        "Name": "running"
                    },
                    "StateTransitionReason": "",
                    "SubnetId": "subnet-02b627d81037a31b7",
                    "VpcId": "vpc-0d1b34296dd94edbf",
                    "Architecture": "x86_64",
                    "BlockDeviceMappings": [
                        {
                            "DeviceName": "/dev/xvda",
                            "Ebs": {
                                "AttachTime": "2022-01-18T16:02:34+00:00",
                                "DeleteOnTermination": true,
                                "Status": "attached",
                                "VolumeId": "vol-0ececf3cfe275ccb2"
                            }
                        }
                    ],
                    "ClientToken": "",
                    "EbsOptimized": false,
                    "EnaSupport": true,
                    "Hypervisor": "xen",
                    "NetworkInterfaces": [
                        {
                            "Association": {
                                "IpOwnerId": "amazon",
                                "PublicDnsName": "",
                                "PublicIp": "3.120.180.114"
                            },
                            "Attachment": {
                                "AttachTime": "2022-01-18T16:02:33+00:00",
                                "AttachmentId": "eni-attach-0fdaa08b0a8f1276a",
                                "DeleteOnTermination": true,
                                "DeviceIndex": 0,
                                "Status": "attached",
                                "NetworkCardIndex": 0
                            },
                            "Description": "Primary network interface",
                            "Groups": [
                                {
                                    "GroupName": "default",
                                    "GroupId": "sg-05babb29a4252223d"
                                }
                            ],
                            "Ipv6Addresses": [],
                            "MacAddress": "02:57:7f:aa:af:78",
                            "NetworkInterfaceId": "eni-0f3fcb3f589115ad3",
                            "OwnerId": "900990357819",
                            "PrivateIpAddress": "10.0.3.184",
                            "PrivateIpAddresses": [
                                {
                                    "Association": {
                                        "IpOwnerId": "amazon",
                                        "PublicDnsName": "",
                                        "PublicIp": "3.120.180.114"
                                    },
                                    "Primary": true,
                                    "PrivateIpAddress": "10.0.3.184"
                                }
                            ],
                            "SourceDestCheck": true,
                            "Status": "in-use",
                            "SubnetId": "subnet-02b627d81037a31b7",
                            "VpcId": "vpc-0d1b34296dd94edbf",
                            "InterfaceType": "interface"
                        }
                    ],
                    "RootDeviceName": "/dev/xvda",
                    "RootDeviceType": "ebs",
                    "SecurityGroups": [
                        {
                            "GroupName": "default",
                            "GroupId": "sg-05babb29a4252223d"
                        }
                    ],
                    "SourceDestCheck": true,
                    "Tags": [
                        {
                            "Key": "Name",
                            "Value": "pri1"
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
                        "InstanceMetadataTags": "enabled"
                    },
                    "EnclaveOptions": {
                        "Enabled": false
                    },
                    "PlatformDetails": "Linux/UNIX",
                    "UsageOperation": "RunInstances",
                    "UsageOperationUpdateTime": "2022-01-18T16:02:33+00:00",
                    "PrivateDnsNameOptions": {
                        "HostnameType": "ip-name",
                        "EnableResourceNameDnsARecord": true,
                        "EnableResourceNameDnsAAAARecord": false
                    }
                }
            ],
            "OwnerId": "900990357819",
            "ReservationId": "r-0ad63350ad058651b"
        }
    ]
}
```

```bash
scp -i /Users/gf/Documents/TAP_georgif.pem /Users/gf/Documents/TAP_georgif.pem ec2-user@52.59.244.161:/home/ec2-user
```

```bash
ssh -i /Users/gf/Documents/TAP_georgif.pem ec2-user@52.59.244.161 ssh -i ~/TAP_georgif.pem ec2-user@10.0.3.184 ''"ping -c 1 google.com"'"'
```

```bash
PING google.com (142.250.185.174) 56(84) bytes of data.
64 bytes from fra16s51-in-f14.1e100.net (142.250.185.174): icmp_seq=1 ttl=109 time=2.29 ms

--- google.com ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 2.296/2.296/2.296/0.000 ms
```

## Task 4:

```bash
aws ec2 create-vpc --cidr-block 10.1.0.0/16 --query Vpc.VpcId --output text --region eu-west-1
```

```bash
vpc-03d3af192446c96b0
```

```bash
aws ec2 create-subnet --vpc-id vpc-03d3af192446c96b0 --cidr-block 10.1.0.0/24 --region eu-west-1 --tag-specifications ResourceType=subnet,Tags=[{Key=Name,Value=public_subnet_eu-west-1}]
```

```bash
{
    "Subnet": {
        "AvailabilityZone": "eu-west-1c",
        "AvailabilityZoneId": "euw1-az3",
        "AvailableIpAddressCount": 251,
        "CidrBlock": "10.1.0.0/24",
        "DefaultForAz": false,
        "MapPublicIpOnLaunch": false,
        "State": "available",
        "SubnetId": "subnet-004dad5d593c2f3a2",
        "VpcId": "vpc-03d3af192446c96b0",
        "OwnerId": "900990357819",
        "AssignIpv6AddressOnCreation": false,
        "Ipv6CidrBlockAssociationSet": [],
        "Tags": [
            {
                "Key": "Name",
                "Value": "public_subnet_eu-west-1"
            }
        ],
        "SubnetArn": "arn:aws:ec2:eu-west-1:900990357819:subnet/subnet-004dad5d593c2f3a2",
        "EnableDns64": false,
        "Ipv6Native": false,
        "PrivateDnsNameOptionsOnLaunch": {
            "HostnameType": "ip-name",
            "EnableResourceNameDnsARecord": false,
            "EnableResourceNameDnsAAAARecord": false
        }
    }
}
```

```bash
aws ec2 create-internet-gateway --query InternetGateway.InternetGatewayId --output text --region eu-west-1
```

```bash
igw-0f23620da2ccd0919
```

```bash
aws ec2 attach-internet-gateway --vpc-id vpc-03d3af192446c96b0 --internet-gateway-id igw-0f23620da2ccd0919 --region eu-west-1
```

```bash
aws ec2 create-route-table --vpc-id vpc-03d3af192446c96b0 --query RouteTable.RouteTableId --output text --region eu-west-1
```

```bash
rtb-092bee5325528f7df
```

```bash
aws ec2 create-internet-gateway --query InternetGateway.InternetGatewayId --output text --region eu-west-1
```

```bash
igw-0f23620da2ccd0919
```

```bash
aws ec2 attach-internet-gateway --vpc-id vpc-03d3af192446c96b0 --internet-gateway-id igw-0f23620da2ccd0919 --region eu-west-1
```

```bash
aws ec2 create-route-table --vpc-id vpc-03d3af192446c96b0 --query RouteTable.RouteTableId --output text --region eu-west-1
```

```bash
rtb-092bee5325528f7df
```

```bash
aws ec2 create-route --route-table-id rtb-092bee5325528f7df --destination-cidr-block 0.0.0.0/0 --gateway-id igw-0f23620da2ccd0919 --region eu-west-1
```

```bash
aws ec2 associate-route-table --subnet-id subnet-004dad5d593c2f3a2 --route-table-id rtb-092bee5325528f7df --region eu-west-1
{
    "Reservations": [
        {
            "Groups": [],
            "Instances": [
                {
                    "AmiLaunchIndex": 0,
                    "ImageId": "ami-01efa4023f0f3a042",
                    "InstanceId": "i-03fe4adf957a928fd",
                    "InstanceType": "t2.micro",
                    "KeyName": "TAP_gf_west",
                    "LaunchTime": "2022-01-18T16:49:09+00:00",
                    "Monitoring": {
                        "State": "disabled"
                    },
                    "Placement": {
                        "AvailabilityZone": "eu-west-1c",
                        "GroupName": "",
                        "Tenancy": "default"
                    },
                    "PrivateDnsName": "ip-10-1-0-27.eu-west-1.compute.internal",
                    "PrivateIpAddress": "10.1.0.27",
                    "ProductCodes": [],
                    "PublicDnsName": "",
                    "PublicIpAddress": "52.17.18.13",
                    "State": {
                        "Code": 16,
                        "Name": "running"
                    },
                    "StateTransitionReason": "",
                    "SubnetId": "subnet-004dad5d593c2f3a2",
                    "VpcId": "vpc-03d3af192446c96b0",
                    "Architecture": "x86_64",
                    "BlockDeviceMappings": [
                        {
                            "DeviceName": "/dev/xvda",
                            "Ebs": {
                                "AttachTime": "2022-01-18T16:49:09+00:00",
                                "DeleteOnTermination": true,
                                "Status": "attached",
                                "VolumeId": "vol-0bdcf64edd99f9fd9"
                            }
                        }
                    ],
                    "ClientToken": "",
                    "EbsOptimized": false,
                    "EnaSupport": true,
                    "Hypervisor": "xen",
                    "NetworkInterfaces": [
                        {
                            "Association": {
                                "IpOwnerId": "amazon",
                                "PublicDnsName": "",
                                "PublicIp": "52.17.18.13"
                            },
                            "Attachment": {
                                "AttachTime": "2022-01-18T16:49:09+00:00",
                                "AttachmentId": "eni-attach-0290cd36d2252ad90",
                                "DeleteOnTermination": true,
                                "DeviceIndex": 0,
                                "Status": "attached",
                                "NetworkCardIndex": 0
                            },
                            "Description": "Primary network interface",
                            "Groups": [
                                {
                                    "GroupName": "default",
                                    "GroupId": "sg-0d0abd4e953f2e597"
                                }
                            ],
                            "Ipv6Addresses": [],
                            "MacAddress": "0a:79:d0:a4:bd:f9",
                            "NetworkInterfaceId": "eni-015c1f86a4675c990",
                            "OwnerId": "900990357819",
                            "PrivateIpAddress": "10.1.0.27",
                            "PrivateIpAddresses": [
                                {
                                    "Association": {
                                        "IpOwnerId": "amazon",
                                        "PublicDnsName": "",
                                        "PublicIp": "52.17.18.13"
                                    },
                                    "Primary": true,
                                    "PrivateIpAddress": "10.1.0.27"
                                }
                            ],
                            "SourceDestCheck": true,
                            "Status": "in-use",
                            "SubnetId": "subnet-004dad5d593c2f3a2",
                            "VpcId": "vpc-03d3af192446c96b0",
                            "InterfaceType": "interface"
                        }
                    ],
                    "RootDeviceName": "/dev/xvda",
                    "RootDeviceType": "ebs",
                    "SecurityGroups": [
                        {
                            "GroupName": "default",
                            "GroupId": "sg-0d0abd4e953f2e597"
                        }
                    ],
                    "SourceDestCheck": true,
                    "Tags": [
                        {
                            "Key": "Name",
                            "Value": "p4"
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
                    "UsageOperationUpdateTime": "2022-01-18T16:49:09+00:00",
                    "PrivateDnsNameOptions": {
                        "HostnameType": "ip-name",
                        "EnableResourceNameDnsARecord": true,
                        "EnableResourceNameDnsAAAARecord": false
                    }
                }
            ],
            "OwnerId": "900990357819",
            "ReservationId": "r-04222238ecd1ae111"
        }
    ]
}
```

```bash
ssh -i /Users/gf/Documents/TAP_gf_west.pem ec2-user@52.17.18.13 'id'
```

```bash
uid=1000(ec2-user) gid=1000(ec2-user) groups=1000(ec2-user),4(adm),10(wheel),190(systemd-journal)
```
