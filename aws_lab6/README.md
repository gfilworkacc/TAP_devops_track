## AWS lab 6:

### Task 1:
Created the RDS within database subnets and stored the credentials in Secrets Manager:

![](db_creation.png)

![](db_subnets.png)

![](secrets.png)

### Task 2:

Added the following commands to user data in the instance configuration:

```bash
#!/bin/bash
sudo yum update
sudo amazon-linux-extras install -y postgresql13
```
![](instance_conf.png)

### Task 3:

Verified that postgres service is running, connected to the database and listed the connection:

![](db_connected.png)

Managed to do ssh port forwarding via EC2 instance, although this could be wrong, since the instance must be private, nevertheless:

![](port_forward.png)

### Task 3 subsection b:

Created new private instance, installed ssm plugin on my localhost and created a tunnel to the postgres db:

![](db_instance.png)

![](ssh_tunnel.png)

![](connection.png)

### Task 4:

Created the snapshot:

![](snapshot_created.png)

Copied the snapshot to eu-west-1 and restored the database from it:

![](db_eu-west-1.png)

Created backup plan via AWS backup:

![](backup_plan.png)

### Task 5:

Modified the database to be Multi-AZ:

![](multi_az.png)

Created the replica in region eu-west-1:

![](replica.png)

Promoted the replica to instance in region eu-west-1:

![](replica_to_instance.png)
