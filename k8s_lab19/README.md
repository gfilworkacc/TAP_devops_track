# K8s task 19:<br/>
# Create a multi node cluster with minikube.<br/>
# * Taint one of the node in a way that no pod should be able to schedule on the that node, unless it has a matching toleration.<br/>
# * Deploy a pod with the same key and value.<br/>
# * Deploy a pod with a toleration that if the same key exist it should be able to schedule the pod on that node.<br/>
# * Check the pods on which nodes are scheduled.<br/>

## Multi node cluster with minikube:
```bash
minikube node add
```

```bash
minikube	192.168.49.2
minikube-m02	192.168.49.3
```

## Node tained:

```bash
kubectl taint node minikube-m02 pod=no:NoSchedule
```
## Pod with same key and value yaml configuration:

```bash
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    env: test
spec:
  containers:
  - name: nginx
    image: nginx:stable
  tolerations:
  - key: "pod"
    operator: "Equal"
    value: "no"
    effect: "NoSchedule"
```

## Pod with same key existing yaml configuration:

```bash
apiVersion: v1
kind: Pod
metadata:
  name: redis
  labels:
    env: test
spec:
  containers:
  - name: redis
    image: redis:stable
  tolerations:
  - key: "pod"
    operator: "Exists"
    effect: "NoSchedule"
```

## Results:

```bash
for pod in nginx redis; do kubectl get pod $pod -o json | jq '.spec | .nodeName, .tolerations[0]';done 
```

```bash
"minikube-m02"
{
  "effect": "NoSchedule",
  "key": "pod",
  "operator": "Equal",
  "value": "no"
}
"minikube-m02"
{
  "effect": "NoSchedule",
  "key": "pod",
  "operator": "Exists"
}
```
