# K8s task 13:<br/>
# 1. Create a ServiceAccount on your cluster e.g. test-user<br/>
# 2. Create a Role that only lets interaction with Pods<br/>
# 3. Attach a RoleBinding to the ServiceAccount with the Role<br/>
# 4. Create a Pod based on an Image that contains the Kubectl command and attach the Service Account to this Pod, then connect to it<br/>
#   * You should be able to connect to the Pod<br/>
# 5. Try to create a Deployment with Nginx image with the ServiceAccount<br/>
#   * You shouldn’t be able to create a deployment<br/>
#   * You can always check ServiceAccount permissions with kubectl auth can-i command<br/>

## Yaml file content for steps from 1 to 4:

```bash
---
apiVersion: v1
kind: Namespace
metadata:
  name: lab
---
apiVersion: v1
kind: ServiceAccount
metadata:
  namespace: lab
  name: gf
automountServiceAccountToken: false
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: lab
  name: pod-interaction
rules:
- apiGroups: [""]
  resources: ["pods", "pods/exec"] 
  verbs: ["create", "delete", "get", "list", "update", "watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: pod-interaction
  namespace: lab
subjects:
- kind: User
  name: gf
  namespace: lab
  apiGroup: 
roleRef:
  kind: Role
  name: pod-interaction
  apiGroup: rbac.authorization.k8s.io
---
apiVersion: v1
kind: Pod
metadata:
  name: image-kubectl
  namespace: lab
spec:
  containers:
  - image: bitnami/kubectl
    name: image-kubectl
    command: ["/bin/sleep"]
    args: ["1d"]
  serviceAccountName: gf
  automountServiceAccountToken: false
```

## Results for steps from 1 to 4:

```bash
kubectl exec image-kubectl --as gf -n lab -- bash -c "id && echo && which kubectl && echo && printenv"
```

```bash
uid=1001 gid=0(root) groups=0(root)

/opt/bitnami/kubectl/bin/kubectl

KUBERNETES_SERVICE_PORT_HTTPS=443
KUBERNETES_SERVICE_PORT=443
HOSTNAME=image-kubectl
PWD=/
OS_FLAVOUR=debian-10
HOME=/
KUBERNETES_PORT_443_TCP=tcp://10.96.0.1:443
BITNAMI_IMAGE_VERSION=1.23.1-debian-10-r0
SHLVL=1
KUBERNETES_PORT_443_TCP_PROTO=tcp
BITNAMI_APP_NAME=kubectl
KUBERNETES_PORT_443_TCP_ADDR=10.96.0.1
KUBERNETES_SERVICE_HOST=10.96.0.1
KUBERNETES_PORT=tcp://10.96.0.1:443
KUBERNETES_PORT_443_TCP_PORT=443
OS_NAME=linux
PATH=/opt/bitnami/kubectl/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
OS_ARCH=amd64
_=/usr/bin/printenv
```

## Yaml file content for step 5:

```bash
---
apiVersion: v1
kind: Namespace
metadata:
  name: deploy
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
  namespace: deploy
  labels:
    app: nginx
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 1
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:stable
      serviceAccountName: gf
```

## Result for step 5:

```bash
kubectl auth -n deploy --as gf can-i get pods
no
```
