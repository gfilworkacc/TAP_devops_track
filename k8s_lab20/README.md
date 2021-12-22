# K8s task 20:<br/> 
# * Create a multi node cluster with minikube.<br/> 
# * Create a deployment that spread two replica of pods on the nodes with node affinity<br/> 
# * Use the topologyKey: kubernetes.io/hostname<br/> 

## Labeling the node:

```bash
kubectl label nodes minikube-m02 type=nginx-deployment
```

```bash
kubectl get nodes minikube-m02 --show-labels
NAME           STATUS   ROLES    AGE    VERSION   LABELS
minikube-m02   Ready    <none>   3h3m   v1.22.3   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=minikube-m02,kubernetes.io/os=linux,type=nginx-deployment
```

## Deployment yaml configuration file:

```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      topologySpreadConstraints:
      - maxSkew: 1
        topologyKey: "kubernetes.io/hostname"
        whenUnsatisfiable: DoNotSchedule
        labelSelector:
          matchLabels:
            app: nginx
      containers:
      - name: nginx
        image: nginx:stable
        ports:
        - containerPort: 80
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: type
                operator: In
                values:
                - nginx-deployment
```

## Results:

```bash
kubectl get pods
```

```bash
NAME                               READY   STATUS    RESTARTS   AGE
nginx-deployment-76c668fdf-hwrf5   1/1     Running   0          17m
nginx-deployment-76c668fdf-ljtxd   1/1     Running   0          17m
```

```bash
for pod in $(kubectl get pods | awk 'NR > 1 {print $1}');do kubectl get pod $pod -o json | jq '.spec | .nodeName, .affinity, .topologySpreadConstraints'; done
```

```bash
"minikube-m02"
{
  "nodeAffinity": {
    "requiredDuringSchedulingIgnoredDuringExecution": {
      "nodeSelectorTerms": [
        {
          "matchExpressions": [
            {
              "key": "type",
              "operator": "In",
              "values": [
                "nginx-deployment"
              ]
            }
          ]
        }
      ]
    }
  }
}
[
  {
    "labelSelector": {
      "matchLabels": {
        "app": "nginx"
      }
    },
    "maxSkew": 1,
    "topologyKey": "kubernetes.io/hostname",
    "whenUnsatisfiable": "DoNotSchedule"
  }
]
"minikube-m02"
{
  "nodeAffinity": {
    "requiredDuringSchedulingIgnoredDuringExecution": {
      "nodeSelectorTerms": [
        {
          "matchExpressions": [
            {
              "key": "type",
              "operator": "In",
              "values": [
                "nginx-deployment"
              ]
            }
          ]
        }
      ]
    }
  }
}
[
  {
    "labelSelector": {
      "matchLabels": {
        "app": "nginx"
      }
    },
    "maxSkew": 1,
    "topologyKey": "kubernetes.io/hostname",
    "whenUnsatisfiable": "DoNotSchedule"
  }
]
```
