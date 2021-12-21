# K8s task 18:<br/>
# 1. Create a helm chart that creates a deployment of nginx<br/>
# 2. In the helm chart insert a configmap with data myvar=5 and a secret with data myvar2=6<br/>
# 3. Attach both configurations to the deployment as environment variables.<br/>
# 4. Create all resources via helm in namespace test<br/>

## Deployment and values yaml files content:

```bash
---
apiVersion: v1
kind: Namespace
metadata:
  name: {{ .Values.namespace }}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-config
  namespace: {{ .Values.namespace }}
data:
  variable: "{{ .Values.config_var }}"
---
apiVersion: v1
kind: Secret
metadata:
  name: {{ .Release.Name }}-secret
  namespace: {{ .Values.namespace }}
stringData:
  variable: "{{ .Values.secret_var }}"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}-deployment
  namespace: {{ .Values.namespace }}
spec:
  replicas: 1
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
        image: {{ .Values.image.repository }}:{{ .Values.image.tag }}
        env:
          - name: myvar
            valueFrom:
              configMapKeyRef:
                name: {{ .Release.Name }}-config
                key: variable
          - name: myvar2
            valueFrom:
              secretKeyRef:
                name: {{ .Release.Name }}-secret
                key: variable
```

```bash
namespace: test

config_var: 5

secret_var: 6

image:
  repository: nginx
  tag: "latest"
```

## Execution and results:

```bash
helm install --generate-name nginx/ 
```

```bash
NAME: nginx-1640110925
LAST DEPLOYED: Tue Dec 21 20:22:06 2021
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
```

```bash
pod=$(kubectl get pods -n test | awk NR == 2 {print }) && kubectl exec -n test $pod -- printenv | grep "^myvar"
```

```bash
myvar=5
myvar2=6
```
