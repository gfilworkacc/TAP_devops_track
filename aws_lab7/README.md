## AWS lab 8:

### Cluster and node creation:

```bash
eksctl create cluster --name tap-georgif-eks-test --version 1.21 --without-nodegroup --with-oidc
```

```bash
eksctl create nodegroup --cluster tap-georgif-eks-test --region eu-central-1 --name ng-1 --nodes 2 --nodes-min 2 --nodes-max 4 --node-type t3.small --node-volume-size 8
```

### Auto scaling creation by steps (was it necessary ?):

Policy and role creation:

```bash
aws iam create-policy  --policy-name AmazonEKSClusterAutoscalerPolicy --policy-document file://cluster-autoscaler-policy.json
	
eksctl create iamserviceaccount --cluster=tap-georgif-eks-test --namespace=kube-system --name=cluster-autoscaler --attach-policy-arn=arn:aws:iam::900990357819:policy/AmazonEKSClusterAutoscalerPolicy  --override-existing-serviceaccounts --approve
```

Deployment:

```bash
curl -o cluster-autoscaler-autodiscover.yaml https://raw.githubusercontent.com/kubernetes/autoscaler/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-autodiscover.yaml
```

Modified the yaml by adding the proper cluster name.

```bash
kubectl apply -f cluster-autoscaler-autodiscover.yaml
kubectl patch deployment cluster-autoscaler -n kube-system -p '{"spec":{"template":{"metadata":{"annotations":{"cluster-autoscaler.kubernetes.io/safe-to-evict": "false"}}}}}'
kubectl set image deployment cluster-autoscaler -n kube-system cluster-autoscaler=k8s.gcr.io/autoscaling/cluster-autoscaler:v1.21.5
```
### AWS load balancer controller creation and deployment:

Policy and role creation:

```bash
aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document file://iam_policy.json

eksctl create iamserviceaccount  --cluster=tap-georgif-eks-test  --namespace=kube-system --name=aws-load-balancer-controller --attach-policy-arn=arn:aws:iam::900990357819:policy/AWSLoadBalancerControllerIAMPolicy  --override-existing-serviceaccounts --approve
```

Installation via k8s manifest:

```bash
kubectl apply  --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.5.4/cert-manager.yaml

curl -Lo v2_3_1_full.yaml https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/v2.3.1/v2_3_1_full.yaml

edited cluster name in v2_3_1_full.yaml

kubectl apply -f v2_3_1_full.yaml
```

### K8s yaml file:

```bash
apiVersion: v1
kind: Namespace
metadata:
  name: nginx
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
  namespace: nginx
  labels:
    app: nginx
spec:
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: NodePort
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx
  namespace: nginx
  annotations:
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
  labels:
    app: nginx
spec:
  rules:
    - host: "*.amazonaws.com"
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: nginx-service
                port:
                  number: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  namespace: nginx
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
      containers:
      - name: nginx
        image: public.ecr.aws/nginx/nginx:latest
        ports:
        - containerPort: 80
```

### Result :

```bash
curl -IL k8s-nginx-nginx-fd8adbf61d-1537863902.eu-central-1.elb.amazonaws.com
```

```bash
HTTP/1.1 200 OK
Date: Wed, 26 Jan 2022 20:05:31 GMT
Content-Type: text/html
Content-Length: 615
Connection: keep-alive
Server: nginx/1.21.5
Last-Modified: Tue, 28 Dec 2021 15:28:38 GMT
ETag: "61cb2d26-267"
Accept-Ranges: bytes
```
