FROM golang as build

WORKDIR /app

COPY example/ .

WORKDIR /app/hello

RUN go build -o hello

FROM scratch
COPY --from=build /app/hello /app/hello
ENTRYPOINT ["/app/hello/hello"]
CMD ["--help"]
