FROM golang:1.19.2-alpine3.16 AS builder
WORKDIR /builder
COPY app .
RUN go mod tidy
RUN go build -o app .

FROM alpine:3.16
WORKDIR /app
RUN apk add --no-cache curl
COPY --from=builder /builder/app .
ENTRYPOINT [ "./app" ]