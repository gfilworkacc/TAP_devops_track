# Docker and virtualization lab7

## Dockerfile content:

```bash
FROM golang as build

WORKDIR /app

COPY example/ .

WORKDIR /app/hello

RUN go build -o hello

FROM scratch
COPY --from=build /app/hello /app/hello
ENTRYPOINT ["/app/hello/hello"]
CMD ["--help"]
```
## Output from the container:

```bash
Hello, Go examples!
```

## Rest of the steps to finish the lab:

```bash
htpasswd -Bc docker-reg/auth/registry.password admin #Create the admin account

cd docker-reg; docker-compose up #Start the local repository

docker login localhost:5004 #Log into the repository

docker tag image_id localhost:5004/go-hello #Map the image to the local repository

docker push localhost:5004/go-hello #Push to the repository
```

