# 1. Create a simple helm chart from scratch that installs a pod the only parameter in the value file should be image and tag. Insert the values for image and tag to nginx latest and run the helmchart.
# 2. List the helm releases
# 3. Upgrade the helm release’s image and tag to redis latest
# 4. List again the helm releases

## Step 1:

```bash
helm create release
```

## Image yaml file content with values:

```bash
image:
  repository: nginx
  tag: "latest"
```

## Pod creation:

```bash
helm install -f image.yalm nginx ./release/
```

## Step 2:

```bash
helm list 
```

```bash
NAME 	NAMESPACE	REVISION	UPDATED                                	STATUS  	CHART        	APP VERSION
nginx	default  	1       	2021-12-21 14:15:52.178852867 +0200 EET	deployed	release-0.1.0	1.16.0     
```

## Step 3 - changed yaml file content with values:

```bash
image:
  repository: redis
  tag: "latest"
```

```bash
helm upgrade -f image.yalm nginx ./release/ 
```

## Step 4 - final releases:

```bash
helm list
```

```bash
NAME 	NAMESPACE	REVISION	UPDATED                                	STATUS  	CHART        	APP VERSION
nginx	default  	2       	2021-12-21 14:24:31.721136339 +0200 EET	deployed	release-0.1.0	1.16.0     
```
