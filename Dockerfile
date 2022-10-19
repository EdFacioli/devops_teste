FROM golang:1.19.2-alpine3.16 AS builder
WORKDIR /builder
COPY app .
RUN go mod tidy
RUN go build -o app .

FROM alpine:latest
WORKDIR /app
COPY --from=builder /builder/app .
ENTRYPOINT [ "./app" ]