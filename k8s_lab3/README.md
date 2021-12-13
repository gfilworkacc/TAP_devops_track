# K8s task 3 - nginx installation via declerative and imperative approach:

## Imperative approach:

```bash
kubectl run nginx --image=nginx:stable --port=80

kubectl describe pod nginx
```

```bash
Name:         nginx
Namespace:    default
Priority:     0
Node:         minikube/192.168.49.2
Start Time:   Mon, 13 Dec 2021 11:06:35 +0200
Labels:       run=nginx
Annotations:  <none>
Status:       Running
IP:           172.17.0.3
IPs:
  IP:  172.17.0.3
Containers:
  nginx:
    Container ID:   docker://807f379ed2787612b83c65568bb31021bd4dd83d3d9c0e0afa8d876b3788b3d1
    Image:          nginx:stable
    Image ID:       docker-pullable://nginx@sha256:71a1217d769cbfb5640732263f81d74e853f101b7f2b20fcce991a22e68adbc7
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Mon, 13 Dec 2021 11:06:50 +0200
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-zgz2b (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  kube-api-access-zgz2b:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  11m   default-scheduler  Successfully assigned default/nginx to minikube
  Normal  Pulling    11m   kubelet            Pulling image "nginx:stable"
  Normal  Pulled     11m   kubelet            Successfully pulled image "nginx:stable" in 13.181718541s
  Normal  Created    11m   kubelet            Created container nginx
  Normal  Started    11m   kubelet            Started container nginx
```

## Declerative approach:

```bash
cat nginx.yaml
```

```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-lab-server
spec:
  selector:
    matchLabels:
      app: nginx
  minReadySeconds: 5
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:stable
        ports:
        - containerPort: 80
```

```bash
kubectl apply -f .
```

```bash
kubectl get pod nginx-lab-server-5ff58d798d-9v9cd -o json
```

```bash
{
    "apiVersion": "v1",
    "kind": "Pod",
    "metadata": {
        "creationTimestamp": "2021-12-13T09:25:40Z",
        "generateName": "nginx-lab-server-5ff58d798d-",
        "labels": {
            "app": "nginx",
            "pod-template-hash": "5ff58d798d"
        },
        "name": "nginx-lab-server-5ff58d798d-9v9cd",
        "namespace": "default",
        "ownerReferences": [
            {
                "apiVersion": "apps/v1",
                "blockOwnerDeletion": true,
                "controller": true,
                "kind": "ReplicaSet",
                "name": "nginx-lab-server-5ff58d798d",
                "uid": "5701d1d9-1b39-4de6-9fcf-c973babb50f8"
            }
        ],
        "resourceVersion": "3869",
        "uid": "ff36f67a-d4f5-40a5-b342-5f4886333a08"
    },
    "spec": {
        "containers": [
            {
                "image": "nginx:stable",
                "imagePullPolicy": "IfNotPresent",
                "name": "nginx",
                "ports": [
                    {
                        "containerPort": 80,
                        "protocol": "TCP"
                    }
                ],
                "resources": {},
                "terminationMessagePath": "/dev/termination-log",
                "terminationMessagePolicy": "File",
                "volumeMounts": [
                    {
                        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                        "name": "kube-api-access-jhr76",
                        "readOnly": true
                    }
                ]
            }
        ],
        "dnsPolicy": "ClusterFirst",
        "enableServiceLinks": true,
        "nodeName": "minikube",
        "preemptionPolicy": "PreemptLowerPriority",
        "priority": 0,
        "restartPolicy": "Always",
        "schedulerName": "default-scheduler",
        "securityContext": {},
        "serviceAccount": "default",
        "serviceAccountName": "default",
        "terminationGracePeriodSeconds": 30,
        "tolerations": [
            {
                "effect": "NoExecute",
                "key": "node.kubernetes.io/not-ready",
                "operator": "Exists",
                "tolerationSeconds": 300
            },
            {
                "effect": "NoExecute",
                "key": "node.kubernetes.io/unreachable",
                "operator": "Exists",
                "tolerationSeconds": 300
            }
        ],
        "volumes": [
            {
                "name": "kube-api-access-jhr76",
                "projected": {
                    "defaultMode": 420,
                    "sources": [
                        {
                            "serviceAccountToken": {
                                "expirationSeconds": 3607,
                                "path": "token"
                            }
                        },
                        {
                            "configMap": {
                                "items": [
                                    {
                                        "key": "ca.crt",
                                        "path": "ca.crt"
                                    }
                                ],
                                "name": "kube-root-ca.crt"
                            }
                        },
                        {
                            "downwardAPI": {
                                "items": [
                                    {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "metadata.namespace"
                                        },
                                        "path": "namespace"
                                    }
                                ]
                            }
                        }
                    ]
                }
            }
        ]
    },
    "status": {
        "conditions": [
            {
                "lastProbeTime": null,
                "lastTransitionTime": "2021-12-13T09:25:41Z",
                "status": "True",
                "type": "Initialized"
            },
            {
                "lastProbeTime": null,
                "lastTransitionTime": "2021-12-13T09:25:42Z",
                "status": "True",
                "type": "Ready"
            },
            {
                "lastProbeTime": null,
                "lastTransitionTime": "2021-12-13T09:25:42Z",
                "status": "True",
                "type": "ContainersReady"
            },
            {
                "lastProbeTime": null,
                "lastTransitionTime": "2021-12-13T09:25:41Z",
                "status": "True",
                "type": "PodScheduled"
            }
        ],
        "containerStatuses": [
            {
                "containerID": "docker://54016eaf9d703f02eb7a88a1b14141dba8b7e063d2fa718b4e20c4dd0793d0bc",
                "image": "nginx:stable",
                "imageID": "docker-pullable://nginx@sha256:71a1217d769cbfb5640732263f81d74e853f101b7f2b20fcce991a22e68adbc7",
                "lastState": {},
                "name": "nginx",
                "ready": true,
                "restartCount": 0,
                "started": true,
                "state": {
                    "running": {
                        "startedAt": "2021-12-13T09:25:41Z"
                    }
                }
            }
        ],
        "hostIP": "192.168.49.2",
        "phase": "Running",
        "podIP": "172.17.0.3",
        "podIPs": [
            {
                "ip": "172.17.0.3"
            }
        ],
        "qosClass": "BestEffort",
        "startTime": "2021-12-13T09:25:41Z"
    }
}
```
