# K8s task 14:
# Create a PersistentVolume referencing a disk in your environment.<br/> 
#   * Create PV and PVC with ReadWriteOnce access mode, storage and request of 2Gi<br/> 
# Create a MySQL Deployment.<br/> 
#   * Create Deployment with mysql image open container port 3306.<br/> 
#   * Create Service use the selector for the deployment and open port 3306<br/> 
# Expose MySQL to other pods in the cluster at a known DNS name.<br/> 

## Yaml file content:

```bash
---
apiVersion: v1
kind: Namespace
metadata:
  name: volume-task
---
apiVersion: v1
kind: Service
metadata:
  namespace: volume-task
  name: mysql-service
spec:
  selector:
    app:  mysql
  ports:
    - protocol: TCP
      port: 3306
      targetPort: 3306
---
apiVersion: v1
kind: PersistentVolume
metadata:
  namespace: volume-task
  name: volume-task
  labels:
    type: local
spec:
  storageClassName: manual
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mnt/volume-task"
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  namespace: volume-task
  name: claim-volume
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 2Gi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql-deploy
  namespace: volume-task
  labels:
    app: mysql
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: mysql:8
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: passwd
        ports:
          - containerPort:  3306
            name: mysql
        volumeMounts:
        - name: claim-volume
          mountPath: /var/lib/mysql
      volumes:
        - name: claim-volume
          persistentVolumeClaim:
            claimName: claim-volume
---
apiVersion: v1
kind: Pod
metadata:
  name: nc
  namespace: volume-task
spec:
  containers:
  - name: nc
    image: subfuzion/netcat
    args: ["-vz", "mysql-service", "3306"]
  restartPolicy: OnFailure
```

## Results:

```bash
kubectl get svc -n volume-task
```

```bash
NAME            TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
mysql-service   ClusterIP   10.104.129.15   <none>        3306/TCP   11m
```

```bash
kubectl get pods -n volume-task
```

```bash
NAME                            READY   STATUS      RESTARTS   AGE
mysql-deploy-548744559f-rvm2s   1/1     Running     0          12m
nc                              0/1     Completed   0          6m11s
```

```bash
kubectl exec  -n volume-task mysql-deploy-548744559f-rvm2s  -- mysql -c version -p passwd | head
```

```bash
mysql  Ver 8.0.27 for Linux on x86_64 (MySQL Community Server - GPL)
Copyright (c) 2000, 2021, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Usage: mysql [OPTIONS] [database]
  -?, --help          Display this help and exit.
  -I, --help          Synonym for -?
```

```bash
kubectl logs -n volume-task nc
```

```bash
Connection to mysql-service 3306 port [tcp/mysql] succeeded!
```
