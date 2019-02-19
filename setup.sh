#!/bin/bash
set -eu

docker pull oiax/rails6-deps:latest

case "$OSTYPE" in
  darwin*)
    docker-compose build web
    ;;
  linux*)
    docker-compose build --build-arg UID=$(id -u) --build-arg GID=$(id -g) web
    ;;
  *)
    echo "Unknown OS Type: $OSTYPE"
    ;;
esac
