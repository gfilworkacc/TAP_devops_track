# Docker and virtualization lab6 - task2

## Dockerfile content:

```bash
# syntax=docker/dockerfile:1
FROM python:3.9-alpine
WORKDIR /code
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
RUN apk add --no-cache gcc musl-dev linux-headers
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
EXPOSE 5000
COPY . .
CMD ["flask", "run"]
```

## docker-compose.yml content:

```bash
version: "3.9"

volumes:
  redis:

services:
  redis:
    image: "redis:alpine"
    volumes:
      - .:/code
  web:
    build: .
    ports:
      - "127.0.0.1:5000:5000"
    environment:
      - FLASK_ENV=development
```

## See the png file for POC of the working app.
