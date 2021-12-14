# K8s task 4 - Ubuntu deployments: 

## Ubuntu image with one replica and information about runnig deployments:

Configuration:

```bash
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ubuntu-task-server
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ubuntu-task-server
  template:
    metadata:
      labels:
        app: ubuntu-task-server
    spec:
      containers:
        - name: ubuntu-task-server
          image: ubuntu:20.04
          command:  ["/bin/sleep",  "365d"]
```

Running deployments information:

```bash
kubectl get deployments.apps -o json
```

```bash
{
    "apiVersion": "v1",
    "items": [
        {
            "apiVersion": "apps/v1",
            "kind": "Deployment",
            "metadata": {
                "annotations": {
                    "deployment.kubernetes.io/revision": "1",
                    "kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"apps/v1\",\"kind\":\"Deployment\",\"metadata\":{\"annotations\":{},\"name\":\"ubuntu-task-server\",\"namespace\":\"default\"},\"spec\":{\"replicas\":1,\"selector\":{\"matchLabels\":{\"app\":\"ubuntu-task-server\"}},\"template\":{\"metadata\":{\"labels\":{\"app\":\"ubuntu-task-server\"}},\"spec\":{\"containers\":[{\"command\":[\"/bin/sleep\",\"365d\"],\"image\":\"ubuntu:20.04\",\"name\":\"ubuntu-task-server\"}]}}}}\n"
                },
                "creationTimestamp": "2021-12-14T08:06:46Z",
                "generation": 2,
                "name": "ubuntu-task-server",
                "namespace": "default",
                "resourceVersion": "16438",
                "uid": "627f40fb-1b63-4bc6-814b-fe026be50ee4"
            },
            "spec": {
                "progressDeadlineSeconds": 600,
                "replicas": 1,
                "revisionHistoryLimit": 10,
                "selector": {
                    "matchLabels": {
                        "app": "ubuntu-task-server"
                    }
                },
                "strategy": {
                    "rollingUpdate": {
                        "maxSurge": "25%",
                        "maxUnavailable": "25%"
                    },
                    "type": "RollingUpdate"
                },
                "template": {
                    "metadata": {
                        "creationTimestamp": null,
                        "labels": {
                            "app": "ubuntu-task-server"
                        }
                    },
                    "spec": {
                        "containers": [
                            {
                                "command": [
                                    "/bin/sleep",
                                    "365d"
                                ],
                                "image": "ubuntu:20.04",
                                "imagePullPolicy": "IfNotPresent",
                                "name": "ubuntu-task-server",
                                "resources": {},
                                "terminationMessagePath": "/dev/termination-log",
                                "terminationMessagePolicy": "File"
                            }
                        ],
                        "dnsPolicy": "ClusterFirst",
                        "restartPolicy": "Always",
                        "schedulerName": "default-scheduler",
                        "securityContext": {},
                        "terminationGracePeriodSeconds": 30
                    }
                }
            },
            "status": {
                "availableReplicas": 1,
                "conditions": [
                    {
                        "lastTransitionTime": "2021-12-14T08:06:48Z",
                        "lastUpdateTime": "2021-12-14T08:06:48Z",
                        "message": "Deployment has minimum availability.",
                        "reason": "MinimumReplicasAvailable",
                        "status": "True",
                        "type": "Available"
                    },
                    {
                        "lastTransitionTime": "2021-12-14T08:06:46Z",
                        "lastUpdateTime": "2021-12-14T08:06:48Z",
                        "message": "ReplicaSet \"ubuntu-task-server-c475bbcf8\" has successfully progressed.",
                        "reason": "NewReplicaSetAvailable",
                        "status": "True",
                        "type": "Progressing"
                    }
                ],
                "observedGeneration": 2,
                "readyReplicas": 1,
                "replicas": 1,
                "updatedReplicas": 1
            }
        }
    ],
    "kind": "List",
    "metadata": {
        "resourceVersion": "",
        "selfLink": ""
    }
}
```

Deployments events:

```bash
kubectl describe deployments.apps
```

```bash
Name:                   ubuntu-task-server
Namespace:              default
CreationTimestamp:      Tue, 14 Dec 2021 10:06:46 +0200
Labels:                 <none>
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=ubuntu-task-server
Replicas:               1 desired | 1 updated | 1 total | 1 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=ubuntu-task-server
  Containers:
   ubuntu-task-server:
    Image:      ubuntu:20.04
    Port:       <none>
    Host Port:  <none>
    Command:
      /bin/sleep
      365d
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   ubuntu-task-server-c475bbcf8 (1/1 replicas created)
Events:
  Type    Reason             Age    From                   Message
  ----    ------             ----   ----                   -------
  Normal  ScalingReplicaSet  7m2s   deployment-controller  Scaled up replica set ubuntu-task-server-c475bbcf8 to 2
  Normal  ScalingReplicaSet  6m52s  deployment-controller  Scaled down replica set ubuntu-task-server-c475bbcf8 to 1
```

Set the pods of the deployment to 6:

```bash
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ubuntu-task-server
spec:
  replicas: 6
  selector:
    matchLabels:
      app: ubuntu-task-server
  template:
    metadata:
      labels:
        app: ubuntu-task-server
    spec:
      containers:
        - name: ubuntu-task-server
          image: ubuntu:20.04
          command:  ["/bin/sleep",  "365d"]
```

```bash
kubectl get pods -o wide
```

```bash
NAME                                 READY   STATUS    RESTARTS   AGE     IP           NODE       NOMINATED NODE   READINESS GATES
ubuntu-task-server-c475bbcf8-cb4vr   1/1     Running   0          2m13s   172.17.0.6   minikube   <none>           <none>
ubuntu-task-server-c475bbcf8-gglmv   1/1     Running   0          2m13s   172.17.0.8   minikube   <none>           <none>
ubuntu-task-server-c475bbcf8-s4b8s   1/1     Running   0          14m     172.17.0.5   minikube   <none>           <none>
ubuntu-task-server-c475bbcf8-sxngh   1/1     Running   0          2m13s   172.17.0.3   minikube   <none>           <none>
ubuntu-task-server-c475bbcf8-t7m2p   1/1     Running   0          2m13s   172.17.0.7   minikube   <none>           <none>
ubuntu-task-server-c475bbcf8-vxlst   1/1     Running   0          2m13s   172.17.0.4   minikube   <none>           <none>
```

Delete the deployment:

```bash
kubectl delete deployments.apps ubuntu-task-server
```
