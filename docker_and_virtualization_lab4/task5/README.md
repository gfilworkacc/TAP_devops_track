# Docker and virtualization lab4 - task5

## Simple script to start the alpine base image in detached mode, prints the container ID, stops the container and remove it.

```bash
#!/usr/bin/env bash

hash=$(docker run --name "lab8" --rm -d alpine:latest "/bin/sh" -c "sleep 30")

echo "Launched container with id $hash named lab8, which will destroy itself after 30 seconds."
```
