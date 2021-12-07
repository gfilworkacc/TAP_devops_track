# Docker and virtualization lab4 - task1

## Create hello.py and  Dockerfile files in a common directory with the following content:

hello.py:

```python
print('Hello World')
```

Dockerfile:

```bash
FROM python

WORKDIR /

COPY . .

ENTRYPOINT ["/bin/bash", "-c"]

CMD ["python3 hello.py"]
```
## Build the image, get the image_id and run the script:

```bash
docker build -t image_name .

docker images

docker run image_id
```

