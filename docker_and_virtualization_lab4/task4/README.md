# Docker and virtualization lab7

## Optimized test_arg image by merging 3 RUN instructions into 1:

```bash
FROM alpine

ARG username
ARG group

RUN apk update \
	&& apk upgrade \
	&& apk add "bash" \
	&& adduser $username -D \
	&& addgroup $group	

WORKDIR /

COPY --chown=$username:$group hello.py . 

ENTRYPOINT ["/bin/bash", "-c"]

CMD ["ls -l hello.py"]
```

See the screenshots for more information.
