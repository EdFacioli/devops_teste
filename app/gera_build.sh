#!/bin/bash

GO_VERSION=$(go version | grep -oE [0-9]\.[0-9]{2})

if [ "$(echo "${GO_VERSION} < 1.18" | bc)" -eq 1 ]; then
  echo "go version 1.18+ is required"
  exit 1
fi

go mod tidy

darwin() {
  echo "Build..."
  CGO_ENABLED=0 GOARCH=arm64 GOOS=darwin go build .
  echo "Done!"
}

linux() {
  echo "Build..."
  CGO_ENABLED=0 GOARCH=amd64 GOOS=linux go build .
  echo "Done!"
}

usage() {
  echo -e "Build de binarios para linux/amd64 e/ou darwin/arm64 \n"
  echo "Digite ./gera_build.sh linux para gerar binarios para linux"
  echo "Digite ./gera_build.sh darwin para gerar binarios para macos"
}

case $1 in
  linux)
    linux
    ;;
  darwin)
    darwin
    ;;
  *)
    usage
    ;;
esac